#!/usr/bin/perl -w
# Dualstrusion post-processing script for Slic3r output and a Replicator Dual-like printer.
# Version: 0.8
# Alexander Thomas a.k.a. DrLex, https://www.dr-lex.be/
# Released under Creative Commons Attribution 4.0 International license.
#
# Usage: dualstrusion-postproc.pl [-d] input.gcode > output.gcode
#   -d enables debug output on stderr.
#
# Features:
# * Minimise the number of tool changes.
# * Prime nozzle on a priming tower after tool change.
# * Cool down the unused nozzle. This replaces the ooze prevention temperature drop in Slic3r,
#     do not bother trying to enable it. Last time I tried it, it was a bucket of bugs.
#     It didn't even wait for the temperature to settle.
# * Wipe inactive nozzle on tower before resuming print.
# * Maintain tower with minimal perimeters when no tool change, unless no more tool changes.
# * Disable fan during heating and priming.
#
# It is recommended to enable a tall skirt because the wipe is not always perfect, and the
# active nozzle will ooze during the travel move from the tower to the print. This skirt only
# needs to reach up to the last layer that has two materials.
#
# Limitation: the print must start with the right extruder (T0). Otherwise things will go haywire.
#   If need be, add a dummy object to the first layer and assign it to the right extruder.
#
# This script assumes you are using the custom G-code I published at
#    https://www.dr-lex.be/info-stuff/print3d-ffcp.html#slice_gcode
#    or https://www.thingiverse.com/thing:2367350
#    You could adapt it to your own G-code snippets by modifying the parseInputFile method.
# This version of the script MUST be used with the latest printer profiles and snippets that
#   use relative E distances! It will exit with an error if this condition is not met.
# Variable layer heights are allowed. It should also work with supports printed at layer heights
#   different from the object's, but this is not recommended as it will incur additional tool
#   changes. You should enable 'Synchronize with object layers' in Slic3r.
# Lift Z is now supported. Be sure to use it for inlays (coasters etc.), otherwise travel moves
#   from the second color printed in the same layer risk smudging the first color.
#
# TODOs: 1. allow any extruder to be the first one to start printing. This would mean altering
#           the start G-code, or better: only let Slic3r insert a skeleton for the start G-code,
#           and the script replaces this with the right bit of code.
#        2. make the priming tower more stable at tall heights, either rotate it 45° or make it
#           more circular, or maybe make the base wider.
#        3. print our own additional wipe wall in between the tower and the object, to reduce the
#           need for a tall skirt, which is especially wasteful on large prints. This could be
#           automatic: only print it if no skirt was configured.
#        4. smarter priming tower placement and shifting of the print if necessary to keep
#           everything on the platform.

use strict;

# This should be 34 for the FFCP unless you hacked it big time.
my $nozzleDistance = 34;

# The distance between the center of the priming tower, and the nearest coordinate that occurs in
# the print. This should be at least 10 mm, the radius of the first layer of the tower.
my $squareMargin = 12;

# Number of degrees Celsius to lower the inactive extruder's temperature. How much is needed,
# depends on your material and favourite printing temperatures, but 45 is probably a good value.
# It should be the smallest possible drop that stops the oozing. This is highly recommended because
# without this, ooze will be sprinkled all across your print.
# Still, if you want to disable it for a quick & literally dirty print, set it to 0.
my $temperatureDrop = 45;

# Optional time to let the nozzles sit idle in between the tool change and priming the active nozzle.
# Set to 0 to disable. It can be used to give the inactive nozzle extra time to cool down, but it
# may be better to wipe the nozzle while it has not yet completely cooled down anyway.
my $dwell = 0;

# Number of perimeters to print while printing a non-priming layer of the priming tower.
# Two perimeters should be sufficient. Set to 0 to always print a full layer.
my $towerMaintainPerimeters = 2;

# Assume the unused tool to be retracted this far. This should be at least the normal retraction
# distance for this extruder, plus some extra to combat the typical initial extrusion lag.
# If you notice considerable lag when the second tool is first primed, increase this number.
# If it squirts out too much of a blob, reduce it. In my setup, 1.6 proves a good value.
my $initRetractT1 = 1.6;

# Set to 1 to add a vertical line in the middle of tower maintaining layers (except first layer).
# This line helps with the first wipe after a set of maintaining layers, and it helps anchor the
# ooze as well as the next priming layer.
my $maintainVLine = 1;


#### The variables below should normally not be modified. ####

# The factor between mm/s values as used by Slic3r, and the feed rates as specified in the G-code.
my $feedRateMultiplier = 60; 

# These values will be overridden with those found in the file.
my @retractLen = (1, 1);
my @retractLenTC = (2, 2);
my @retractLift = (0, 0);
my @retractLiftAbove = (0, 0);
my @retractLiftBelow = (0, 0);  # if below is 0, it actually means: always lift

# These values will be parsed from the file unless the names have changed, and the scale factors
# will be computed using these original values, which represent the values with which the
# coordinates below were calculated.
my @filament_diameters = (1.75, 1.75);
my @nozzle_diameters = (0.4, 0.4);
my @extrusion_multipliers = (1.0, 1.0);

# It is extremely important that these values can be parsed from the file. The script will simply
# bail out if it doesn't find them.
my @temperature;
my @first_layer_temperature;
# We don't really need first_layer, but parse it anyway to omit the heat command if it is the same.
my ($bed_temperature, $first_layer_bed_temperature);

# These should also be parsed although these defaults should be sensible.
my $travelFeedRate = 8400;
my @retractFeedRate = (1800, 1800);
my $layer1FeedRate = 1200;

# This has proven to be a generally good speed to chop off ooze on something else.
my $wipeFeedRate = 4000;

# This should be slow because the tool change move is not accelerated. Moreover, when using the
# temperature drop, we have all the time in the world to do the tool change anyway.
my $toolChangeSpeed = 3200;

# Feedrates for the inner and outer perimeters of the tower respectively. You could tweak the outer
# rate to more closely match the normal print rate so there won't be a huge pressure difference
# when the print resumes.
my $innerFeedRate = 1200;
my $outerFeedRate = 1200;

# The thicknesses for which the extrusion coordinates below were calculated.
my ($layerHeightDefault, $firstLayerHeightDefault) = (0.2, 0.25);

# Layer 1 coordinates were generated for a 0.25mm layer, with a 0.4mm nozzle, printing 1.75mm filament at 20mm/s, 0.6mm width.
my @squareLayer1Travels = (
[2.497, -2.497],
[3.044, -3.044],
[3.590, -3.590],
[4.137, -4.137],
[4.683, -4.683],
[5.229, -5.229],
[5.776, -5.776],
[6.322, -6.322],
[6.868, -6.868],
[7.415, -7.415],
[7.961, -7.961],
[8.507, -8.507],
[9.054, -9.054],
[9.600, -9.600]
);
# This is a 20mm square, with a 5mm hole in the middle.
my @squareLayer1Coords = (
[[2.497, 2.497, 0.28364], [-2.497, 2.497, 0.28365], [-2.497, -2.497, 0.28364], [2.437, -2.497, 0.28024]],
[[3.044, 3.044, 0.34569], [-3.044, 3.044, 0.34570], [-3.044, -3.044, 0.34569], [2.984, -3.044, 0.34229]],
[[3.590, 3.590, 0.40774], [-3.590, 3.590, 0.40774], [-3.590, -3.590, 0.40775], [3.530, -3.590, 0.40434]],
[[4.137, 4.137, 0.46979], [-4.137, 4.137, 0.46980], [-4.137, -4.137, 0.46979], [4.077, -4.137, 0.46639]],
[[4.683, 4.683, 0.53184], [-4.683, 4.683, 0.53185], [-4.683, -4.683, 0.53184], [4.623, -4.683, 0.52844]],
[[5.229, 5.229, 0.59390], [-5.229, 5.229, 0.59389], [-5.229, -5.229, 0.59390], [5.169, -5.229, 0.59049]],
[[5.776, 5.776, 0.65594], [-5.776, 5.776, 0.65595], [-5.776, -5.776, 0.65595], [5.716, -5.776, 0.65253]],
[[6.322, 6.322, 0.71800], [-6.322, 6.322, 0.71800], [-6.322, -6.322, 0.71799], [6.262, -6.322, 0.71459]],
[[6.868, 6.868, 0.78005], [-6.868, 6.868, 0.78005], [-6.868, -6.868, 0.78004], [6.808, -6.868, 0.77664]],
[[7.415, 7.415, 0.84210], [-7.415, 7.415, 0.84210], [-7.415, -7.415, 0.84210], [7.355, -7.415, 0.83869]],
[[7.961, 7.961, 0.90414], [-7.961, 7.961, 0.90415], [-7.961, -7.961, 0.90415], [7.901, -7.961, 0.90074]],
[[8.507, 8.507, 0.96620], [-8.507, 8.507, 0.96620], [-8.507, -8.507, 0.96619], [8.447, -8.507, 0.96280]],
[[9.054, 9.054, 1.02824], [-9.054, 9.054, 1.02825], [-9.054, -9.054, 1.02825], [8.994, -9.054, 1.02484]],
[[9.600, 9.600, 1.09030], [-9.600, 9.600, 1.09030], [-9.600, -9.600, 1.09030], [9.540, -9.600, 1.08689]]
);

# Coordinates were generated for a 0.2mm layer, with a 0.4mm nozzle, printing 1.75mm filament at 20mm/s, 0.6mm width.
my @squareTravels = (
[-4.158, -4.158],
[-4.715, -4.715],
[-5.272, -5.272],
[-5.829, -5.829],
[-6.386, -6.386],
[-6.943, -6.943],
[-7.500, -7.500]
);
# This is a 15mm square, with an 8mm hole in the middle.
my @squareCoords = (
[[4.158, -4.158, 0.38517], [4.158, 4.158, 0.38516], [-4.158, 4.158, 0.38517], [-4.158, -4.098, 0.38238]],
[[4.715, -4.715, 0.43677], [4.715, 4.715, 0.43678], [-4.715, 4.715, 0.43677], [-4.715, -4.655, 0.43400]],
[[5.272, -5.272, 0.48838], [5.272, 5.272, 0.48838], [-5.272, 5.272, 0.48838], [-5.272, -5.212, 0.48561]],
[[5.829, -5.829, 0.53999], [5.829, 5.829, 0.53999], [-5.829, 5.829, 0.53999], [-5.829, -5.769, 0.53722]],
[[6.386, -6.386, 0.59160], [6.386, 6.386, 0.59160], [-6.386, 6.386, 0.59160], [-6.386, -6.326, 0.58882]],
[[6.943, -6.943, 0.64321], [6.943, 6.943, 0.64322], [-6.943, 6.943, 0.64321], [-6.943, -6.883, 0.64043]],
[[7.500, -7.500, 0.69482], [7.500, 7.500, 0.69482], [-7.500, 7.500, 0.69482], [-7.500, -7.440, 0.69204]]
);

# Y coordinates for the vertical line in the maintaining layers, if enabled. The first value is for
# a full layer (towerMaintainPerimeters == 0), the next for 1 perimeter, and so on.
my @maintainLineYPos = (3.801, 7.043, 6.486, 5.929, 5.372, 4.815, 4.258);
# The flow rate for the line, in E coordinate per mm.
my $primingFlowRate = 0.0463213;

# Will be prepended as program identifier to log messages
my $progId = 'dual-proc';


###### MAIN ######
my ($DEBUG, $INFO, $WARNING, $ERROR, $FATAL) = (10, 20, 30, 40, 50);
my %logLevelNames = (10 => 'DEBUG', 20 => 'INFO', 30 => 'WARNING', 40 => 'ERROR', 50 => 'FATAL');

my $logLevel = $INFO;

if($ARGV[0] eq '-d') {
	$logLevel = $DEBUG;
	shift;
}

my $inFile = shift;
die "Need input file as argument!\n" if(!$inFile);

my $variableFan = 0;  # If true, use M106/107 commands, otherwise M126/127
my @extruScale = (1, 1);
my @extruScaleL1 = (1, 1);
my (@header, @footer, @layerHeights, @layerThickness);

# Chunks of code grouped per tool and per layer height. The key is "${tool}_${layerheight}".
# Each item in this hash refers to an anonymous array that contains references to arrays
# (blocks) of G-code lines.
my %toolLayers;

# Fan speeds at the start of each of the code blocks within each chunk (same key). This will be
# used to ensure that the fan spins at the correct speed even if chunks are reordered. Each item
# in this hash refers to an anonymous array containing exactly as many elements as the array of
# the same key in %toolLayers.
my %fanState;

# Current speed of the fan in the input or output file. We need to keep track of this because the
# fan should not be enabled during tool change and priming.
my $fanSpeed = 0;

my ($minX, $minY, $maxX, $maxY) = parseInputFile($inFile);
if($logLevel <= $DEBUG) {
	logMsg($DEBUG, "Found XY bounds as ${minX}~${maxX}, ${minY}~${maxY}");
	logMsg($DEBUG, "Normal extrusion scale factors:  $extruScale[0], $extruScale[1]");
	logMsg($DEBUG, "Layer 1 extrusion scale factors: $extruScaleL1[0], $extruScaleL1[1]");
}
my ($squareX, $squareY) = (($minX + $maxX)/2, $maxY + $squareMargin);

# This has two functions: first, ensure that the nozzle doesn't collide with any ooze from a
# previous wipe, and second, do not park the heating nozzle always exactly above the same spot.
my $wipeOffset = 0;

# Scale factor = layer_height/0.2 * filament_diameter/1.75 * nozzle_diameter/0.4 * extrusion_multiplier
# Layer 1 SF = first_layer_height/0.25 * filament_diameter/1.75 * nozzle_diameter/0.4 * extrusion_multiplier

if(!@layerHeights) {
	logMsg($FATAL, 'This file has no printable content!');
	exit(1);
}

# Preprocess the code blocks: wipe any retract command at the very end, because we'll be replacing
# these with our own retracts. (Moreover, Slic3r first changes layer and then retracts, so there
# will be blocks that only have a retract in them.)
my $lastLayerZ = $layerHeights[-1];
my $previousLayerZ = 0;
foreach my $layerZ (@layerHeights) {
	push(@layerThickness, $layerZ - $previousLayerZ);
	foreach my $tool (0, 1) {
		my $key = "${tool}_${layerZ}";
		next if(! $toolLayers{$key});
		my @blockList = @{$toolLayers{$key}};
		my @fanList = @{$fanState{$key}};
		if($#blockList != $#fanList) {
			logMsg($ERROR,
			       'Assertion failure: number of code blocks ('. (1+$#blockList) .
			       ') does not match number of fan states ('. (1+$#fanList) .
			       '). You should probably file a bug including your input file.');
			logMsg($ERROR,
			       'Continuing, although you should not trust the output file to be correct.');
		}

		my @cleanedBlocks;
		my @cleanedFanState;
		foreach my $blockRef (@blockList) {
			my $back = -1;
			# If the final G1 command is a retract move, drop it.
			# Limit the search to the last 16 lines.
			while(@{$blockRef} && $back >= -16) {
				if($$blockRef[$back] =~ /^G1 +(\S+)/) {
					splice(@{$blockRef}, $back, 1) if($1 =~ /^E/);
					last;
				}
				$back--;
				last if(-$back > @$blockRef);
			}
			my $fan = shift(@fanList);
			if(@{$blockRef}) {
				push(@cleanedBlocks, $blockRef);
				push(@cleanedFanState, $fan);
			}
		}
		if(@cleanedBlocks) {
			$toolLayers{$key} = \@cleanedBlocks;
			$fanState{$key} = \@cleanedFanState;
		}
		else {
			delete $toolLayers{$key};
			delete $fanState{$key};
		}
	}
	$previousLayerZ = $layerZ;
}

# Assumption: we always start with T0 and always print a skirt on layer 1 (TODO: remove this restriction!)
# Even if there is no T0 material in the first layer, Slic3r will print a skirt with T0 and then swap tools.
# If this ever changes or the user deems a skirt unnecessary, this script might break.
my $activeTool = 0;
my ($highestToolChangeZ, $highestToolChangeN) = (0, 0);

# Find the highest layer that has a tool change. For this, we mimic the logic of the processing
# below, because trying to find a single formula for this is bad for mental sanity, mostly because
# of the $toolStillActiveNextLayer optimisation.
for(my $layerId = 0; $layerId <= $#layerHeights; $layerId++) {
	my $layerZ = $layerHeights[$layerId];
	my $nextLayerZ = ($layerId < $#layerHeights ? $layerHeights[$layerId + 1] : 0);
	my $otherTool = ($activeTool == 0 ? 1 : 0);

	my $hasOtherTool = defined($toolLayers{"${otherTool}_${layerZ}"});
	my $toolStillActiveNextLayer = defined($toolLayers{"${activeTool}_${nextLayerZ}"}) || $nextLayerZ == 0;
	if($hasOtherTool || !$toolStillActiveNextLayer) {
		$highestToolChangeZ = $layerZ;
		$highestToolChangeN = 1 + $layerId;
		$activeTool = $otherTool;
	}
}
logMsg($DEBUG, "Highest tool change at layer ${highestToolChangeN}, Z=${highestToolChangeZ}");

$activeTool = 0;

# How much was extruded by the original file at the current input line. Only interesting for
# statistics.
my @originalE = (0, 0);

# The offset we're adding, i.e. how much extra filament my extra code has pushed out. Only
# interesting for statistics.
my @offsetE   = (0, 0);

# How far the extruders are currently retracted (regardless of done by the original code, or mine).
# These values can only be negative or 0.
my @retracted = (0, -$initRetractT1);

# Whether a wipe move was last seen on this extruder, necessary to correctly handle retractions
# during wiping.
my @wiping = (0, 0);

$fanSpeed = 0;

push(@header, sprintf('M104 S%d T%d ; heat T1 to standby temperature while T0 starts',
                      $temperature[1] - $temperatureDrop, 1));
my $hNum = 1+$#header;

# Reassemble the file in optimal order and insert retractions and priming code where necessary.
# For every layer:
# Check what tools are used
# If $activeTool is in this layer, start printing with it.
#   Remove any retract moves at the end of each block and replace with normal or TC retract.
#     Normal retract if there is another block, or no other tool block follows in this or the next layer.
# If there is no other tool in this layer and this tool is in the next layer, top up priming tower.
#   Else: swap and prime, and print any blocks of the other tool in this layer.
my @output;
for(my $layerId = 0; $layerId <= $#layerHeights; $layerId++) {
	my $isLayer1 = ($layerId == 0);
	my $layerZ = $layerHeights[$layerId];
	my $nextLayerZ = ($layerId < $#layerHeights ? $layerHeights[$layerId + 1] : 0);

	logMsg($DEBUG, sprintf("LAYER %d: ${layerZ}, thickness %.6g [%d]",
	                       1 + $layerId, $layerThickness[$layerId], $hNum+$#output));
	# Check what tools are active in this layer and the next.
	my (@activeToolBlocks, @otherToolBlocks);
	my (@activeFanState, @otherFanState);
	my $otherTool = ($activeTool == 0 ? 1 : 0);
	if($toolLayers{"${activeTool}_${layerZ}"}) {
		@activeToolBlocks = @{$toolLayers{"${activeTool}_${layerZ}"}};
		@activeFanState = @{$fanState{"${activeTool}_${layerZ}"}};
	}
	if($toolLayers{"${otherTool}_${layerZ}"}) {
		@otherToolBlocks = @{$toolLayers{"${otherTool}_${layerZ}"}};
		@otherFanState = @{$fanState{"${otherTool}_${layerZ}"}};
	}
	# Optimisation: if the next layer will start with the other tool, do not top up the tower
	# but prime the next tool instead.
	my $toolStillActiveNextLayer = defined($toolLayers{"${activeTool}_${nextLayerZ}"});

	push(@output, doRetractMove(-$retractLen[$activeTool]) .' ; normal retract1') unless($retracted[$activeTool]);
	push(@output, sprintf('G1 Z%.3f F%d ; LAYER %d', $layerZ, $travelFeedRate, 1 + $layerId));
	if(@activeToolBlocks) {
		logMsg($DEBUG,
		       "  CONTINUE WITH ACTIVE TOOL $activeTool: ". (1+$#activeToolBlocks) .' BLOCKS ['.
		       ($hNum+$#output) .']');
		for(my $i=0; $i<=$#activeToolBlocks; $i++) {
			ensureFanSpeed($activeFanState[$i]);
			outputTransformedCode($activeToolBlocks[$i]);
			if($i < $#activeToolBlocks && !$retracted[$activeTool]) {
				push(@output, doRetractMove(-$retractLen[$activeTool]) .' ; normal retract2');
			}
		}
	}
	if($layerZ <= $highestToolChangeZ) {
		if(!@otherToolBlocks && $toolStillActiveNextLayer && $layerZ < $highestToolChangeZ) {
			logMsg($DEBUG, '  TOP UP PRIMING TOWER ['. ($hNum+$#output) .']');
			outputTopUpPrimingTower($isLayer1, $layerThickness[$layerId], $layerZ);
		}
		else {
			if($logLevel <= $DEBUG) {
				logMsg($DEBUG, "  SWITCH TO OTHER TOOL ${otherTool}");
				# Number of tool blocks can be 0, see if() above
				logMsg($DEBUG, '  AND PRINT '. (1+$#otherToolBlocks) .' BLOCKS ['.
				       ($hNum+$#output) .']');
			}
			# The tool change code will restore $fanSpeed as a final step.
			$fanSpeed = $otherFanState[0] if(@otherFanState);
			push(@output, doRetractMove(-$retractLenTC[$activeTool]) .' ; tool change retract');
			outputToolChangeAndPrime($isLayer1, $layerThickness[$layerId], $layerZ);
			for(my $i=0; $i<=$#otherToolBlocks; $i++) {
				ensureFanSpeed($otherFanState[$i]) if($i > 0);
				outputTransformedCode($otherToolBlocks[$i]);
				if($i < $#otherToolBlocks && !$retracted[$activeTool]) {
					push(@output, doRetractMove(-$retractLen[$activeTool]) .' ; normal retract3');
				}
			}
		}
	}

	if($isLayer1) {
		my $newTemp = $temperature[$activeTool];
		if($newTemp != $first_layer_temperature[$activeTool]) {
			push(@output, "M104 S${newTemp} T${activeTool} ; change to regular extrusion temperature");
		}
		if($bed_temperature != $first_layer_bed_temperature) {
			push(@output, "M140 S${bed_temperature} ; set regular bed temperature");
		}
	}
}

push(@output, doRetractMove(-$retractLen[$activeTool]) .' ; end of print retract') if(! $retracted[$activeTool]);
ensureFanSpeed(0, '; end of print fan off');
print join("\n", (@header, @output, @footer)) ."\n";



###### SUBROUTINES ######
sub logMsg
# Disadvantage of this fancy logging method: log messages will be interpolated even if they won't
# be printed.
{
	my ($level, $msg) = @_;
	return if($level < $logLevel);
	my $levelStr = $logLevelNames{$level};
	print STDERR "[${progId}] ${levelStr}: ${msg}\n";
}

sub updateFanSpeed
# Set current fanSpeed according to commands found in the line.
{
	my $line = shift;
	if($line =~ /^M126(?:$|\s|;)/) {
		if($variableFan) {
			logMsg($WARNING,
				   'found an M126 command even though the file uses M106/127 commands. Ignoring.');
		}
		else {
			$fanSpeed = 1;
		}
	}
	elsif($line =~ /^M127(?:$|\s|;)/) {
		if($variableFan) {
			logMsg($WARNING,
				   'found an M127 command even though the file uses M106/127 commands. Ignoring.');
		}
		else {
			$fanSpeed = 0;
		}
	}
	elsif($line =~ /^M106(?:$|;|\s+S(\d*\.?\d+)|\s)/) {
		$fanSpeed = $1 ? $1 : 0;
	}
	elsif($line =~ /^M107(?:$|\s|;)/) {
		$fanSpeed = 0;
	}
}

sub ensureFanSpeed
# If current $fanSpeed differs from target, add a G-code line to @output and update $fanSpeed.
{
	my $target = shift;
	my $comment = shift;
	$comment = 'restore previous fan state' if(! defined($comment));
	$comment = $comment ? "; ${comment}" : '';
	return if($fanSpeed == $target);

	if($variableFan) {
		push(@output, sprintf("M106 S%0.2f${comment}", $target));
	}
	else {
		push(@output, ($target ? 'M126' : 'M127') . ${comment});
	}
	$fanSpeed = $target;
}

sub parseInputFile
# Chop up the file into header, footer, and code blocks grouped per layer and per tool.
# Returns print bounds.
# Requires @header, @footer, @layerHeights, %toolLayers, and %fanState to be declared.
{
	my $fName = shift;
	open(my $fHandle, '<', $fName) or die "FAIL: cannot read file: $!";

	my ($isHeaderPart1, $isHeaderPart2, $isFooter, $inToolChangeCode) = (1, 0, 0, 0);
	my ($currentZ, $layerNumber, $activeTool) = (0) x 3;
	# This code will fail for printers with a print bed larger than 65 metres. Too bad.
	my ($minX, $minY, $maxX, $maxY) = (32768, 32768, -32768, -32768);

	# Reference to the anonymous array inside %toolLayers to which we're currently appending code lines
	my $toolLayerRef;
	my $lineNumber = 0;

	my ($filaDiamOK, $nozzleDiamOK, $extruMultiOK, $relativeEOK) = (0) x 4;
	# Last tool change command seen before start of actual print, default to 0 like Slic3r.
	my $startTool = 0;

	foreach my $line (<$fHandle>) {
		$lineNumber++;
		chomp($line);

		if($isHeaderPart1) {
			# First unconditionally treat everything up to the "@body" marker as header.
			if($line =~ /;\@body(\s|;|$)/) {
				$isHeaderPart1 = 0;
				$isHeaderPart2 = 1;
			}
			elsif($line =~ /^M83(;|\s|$)/) {
				$relativeEOK = 1;
			}
			elsif($line =~ /^M82(;|\s|$)/) {
				$relativeEOK = 0;
			}
			push(@header, $line);
			next;
		}
		elsif($isHeaderPart2) {
			# Then look for the point where the main code has 'moved' to the first layer height.
			if($line =~ /^G1 Z(\S+)([ ;]|$)/) {
				$isHeaderPart2 = 0;
				# Do not skip, leave it up to the layer change statement below to handle this.
			}
			elsif($line =~ /^(?:M108 +)?T(\d+)/) {
				# TODO: when allowing to start with T1, these commands should be removed because
				# the start code will already set up the desired tool.
				# NOTE: if there is T0 and T1 in the first layer and only T0 in the next two
				# layers, then it makes the most sense to start with T1 (Slic3r currently isn't
				# smart enough to do this).
				$startTool = $1;
			}
			else {
				push(@header, $line);
				next;
			}
		}
		elsif($isFooter || $line =~ /^;- - - Custom finish printing G-code/) {
			$isFooter = 1;
			push(@footer, $line);
			# Use the OK flags to avoid adjusting the factors multiple times, should the file
			# contain copy-pasted junk.
			if($line =~ /^; filament_diameter = (.+)/ && !$filaDiamOK) {
				my ($dia0, $dia1) = split(/,/, $1);
				my ($factor0, $factor1) = ($dia0/$filament_diameters[0],
				                           $dia1/$filament_diameters[1]);
				@extruScale = ($extruScale[0] * $factor0, $extruScale[1] * $factor1);
				@extruScaleL1 = ($extruScaleL1[0] * $factor0, $extruScaleL1[1] * $factor1);
				$filaDiamOK = 1;
			}
			elsif($line =~ /^; nozzle_diameter = (.+)/ && !$nozzleDiamOK) {
				my ($dia0, $dia1) = split(/,/, $1);
				my ($factor0, $factor1) = ($dia0/$nozzle_diameters[0],
				                           $dia1/$nozzle_diameters[1]);
				@extruScale = ($extruScale[0] * $factor0, $extruScale[1] * $factor1);
				@extruScaleL1 = ($extruScaleL1[0] * $factor0, $extruScaleL1[1] * $factor1);
				$nozzleDiamOK = 1;
			}
			elsif($line =~ /^; extrusion_multiplier = (.+)/ && !$extruMultiOK) {
				my ($mul0, $mul1) = split(/,/, $1);
				my ($factor0, $factor1) = ($mul0/$extrusion_multipliers[0],
				                           $mul1/$extrusion_multipliers[1]);
				@extruScale = ($extruScale[0] * $factor0, $extruScale[1] * $factor1);
				@extruScaleL1 = ($extruScaleL1[0] * $factor0, $extruScaleL1[1] * $factor1);
				$extruMultiOK = 1;
			}
			elsif($line =~ /^; retract_length = (.+)/ ) {
				@retractLen = split(/,/, $1);
			}
			elsif($line =~ /^; retract_length_toolchange = (.+)/ ) {
				@retractLenTC = split(/,/, $1);
			}
			elsif($line =~ /^; retract_lift = (.+)/ ) {
				@retractLift = split(/,/, $1);
			}
			elsif($line =~ /^; retract_lift_above = (.+)/ ) {
				@retractLiftAbove = split(/,/, $1);
			}
			elsif($line =~ /^; retract_lift_below = (.+)/ ) {
				@retractLiftBelow = split(/,/, $1);
			}
			elsif($line =~ /^; first_layer_temperature = (.+)/ ) {
				@first_layer_temperature = split(/,/, $1);
			}
			elsif($line =~ /^; temperature = (.+)/ ) {
				@temperature = split(/,/, $1);
			}
			elsif($line =~ /^; first_layer_bed_temperature = (\d+)/ ) {
				$first_layer_bed_temperature = $1;
			}
			elsif($line =~ /^; bed_temperature = (\d+)/ ) {
				$bed_temperature = $1;
			}
			elsif($line =~ /^; travel_speed = (\d*\.?\d+)/ ) {
				$travelFeedRate = $1 * $feedRateMultiplier;
			}
			elsif($line =~ /^; retract_speed = (.+)/ ) {
				my ($speed0, $speed1) = split(/,/, $1);
				@retractFeedRate = ($speed0 * $feedRateMultiplier, $speed1 * $feedRateMultiplier);
			}
			elsif($line =~ /^; first_layer_speed = (\d*\.?\d+)/ ) {
				$layer1FeedRate = $1 * $feedRateMultiplier;
			}
			next;
		}

		if($line =~ /^G1 X(\S+) Y(\S+)( |$)/) {  # Regular print or travel move
			$minX = $1 if($1 < $minX);
			$maxX = $1 if($1 > $maxX);
			$minY = $2 if($2 < $minY);
			$maxY = $2 if($2 > $maxY);
		}
		elsif($line =~ /^;- - - Custom G-code for tool change/) {
			# Skip these blocks because we're going to replace them entirely
			$inToolChangeCode = 1;
			next;
		}
		elsif($line =~ /^;- - - End custom G-code for tool change/ ) {
			$inToolChangeCode = 0;
			next;
		}

		if($line =~ /^T(0|1)/) {  # Tool change
			my $previousTool = $activeTool;
			$activeTool = $1;
			die "ERROR: more than 2 tools not supported.\n" if($activeTool > 1);
			if($previousTool == $activeTool) {
				logMsg($DEBUG,
				       "ignoring tool change to same tool ${activeTool} at line ${lineNumber}");
				next;
			}
			if(!defined($toolLayers{"${activeTool}_${currentZ}"})) {
				$toolLayers{"${activeTool}_${currentZ}"} = [];
				$fanState{"${activeTool}_${currentZ}"} = []
			}
			push(@{$toolLayers{"${activeTool}_${currentZ}"}}, []);  # Start a new block
			push(@{$fanState{"${activeTool}_${currentZ}"}}, $fanSpeed);
			$toolLayerRef = $toolLayers{"${activeTool}_${currentZ}"}[-1];
			next;
		}
		elsif($line =~ /^G1 Z(\S+)([ ;]|$)/) {  # Layer change
			my $z = 1.0 * $1;  # Ensure it is treated as a number and is in standard format
			next if($z == $currentZ);  # For some reason Slic3r repeats G1 Zz commands even if the layer does not change.
			if($z < $currentZ) {
				# Z went down again, meaning this must have been a 'lift Z'. Undo the presumed last layer change.
				logMsg($DEBUG, "LIFT Z detected at z=${z}");
				$layerNumber--;
				pop(@layerHeights);
				if($layerHeights[-1] != $z) {
					logMsg($ERROR,
					       'Z returned to different height after Z-hop, this makes no sense and things will probably go awry.');
				}
				# We do want to preserve this Z move
				push(@{$toolLayerRef}, $line);
 
				# Append any blocks in the presumed layer to the last real layer. This is probably
				# overkill because I don't expect there to be anything else than a single block
				# with a single travel move, but since performance of this script is unimportant,
				# I go for safety.
				foreach my $tool (0, 1) {
					my $indexToMove = "${activeTool}_${currentZ}";
					my $indexTarget = "${activeTool}_${z}";
					if(defined($toolLayers{$indexToMove})) {
						logMsg($DEBUG, "  Merging ${indexToMove} into ${indexTarget}");
						if(!defined($toolLayers{$indexTarget})) {
							$toolLayers{$indexTarget} = [];
							$fanState{$indexTarget} = [];
						}
						# Restore the snubbed Z move. Because of the cumbersome data structures,
						# simplest is to create an extra block for this.
						push(@{$toolLayers{$indexTarget}},
						     (["G1 Z${currentZ} F${travelFeedRate} ; LIFT Z"],
							  @{$toolLayers{$indexToMove}}));
						# Of course each of these 2 blocks needs its own fanState
						push(@{$fanState{$indexTarget}},
						     (${$fanState{$indexToMove}}[0],
						      @{$fanState{$indexToMove}}));
						delete($toolLayers{$indexToMove});
						delete($fanState{$indexToMove});
					}
				}
				$currentZ = $z;
			}
			else {
				# Either a real layer change, or what will prove to be a Lift Z.
				$layerNumber++;
				$currentZ = $z;
				push(@layerHeights, $currentZ);
			}

			if(!defined($toolLayers{"${activeTool}_${currentZ}"})) {
				$toolLayers{"${activeTool}_${currentZ}"} = [];
				$fanState{"${activeTool}_${currentZ}"} = [];
			}
			push(@{$toolLayers{"${activeTool}_${currentZ}"}}, []);  # Start a new block
			push(@{$fanState{"${activeTool}_${currentZ}"}}, $fanSpeed);
			$toolLayerRef = $toolLayers{"${activeTool}_${currentZ}"}[-1];
			next;
		}
		elsif($line =~ /^M10[67]($| |;)/) {
			$variableFan = 1;
			updateFanSpeed($line);
		}
		elsif($line =~ /^M12[67]($| |;)/ && ! ($isHeaderPart1 || $isFooter)) {
			updateFanSpeed($line);
		}

		push(@{$toolLayerRef}, $line) if(!$inToolChangeCode); 
	}
	if(!($filaDiamOK && $nozzleDiamOK && $extruMultiOK)) {
		logMsg($WARNING,
		       'not all extrusion parameters could be parsed from the file. Extrusion values may be wrong. Check the input file!');
	}
	if(!@temperature || $#temperature < 1 || !@first_layer_temperature || $#first_layer_temperature < 1) {
		logMsg($FATAL,
		       'could not find "temperature" and/or "first_layer_temperature" values in the file, these are essential to avoid utter and complete b0rk.');
		exit(1);
	}
	if(!$relativeEOK) {
		logMsg($FATAL,
		       'The input file does not specify relative E coordinates in its start G-code, this is required for the dualstrusion post-processing script.');
		exit(1);
	}

	if($startTool != 0) {
		logMsg($FATAL,
		       'This script does not yet support starting a print with the left extruder (T1). A simple workaround is to add a small object printed with T0 in the first layer.');
		exit(1);
	}

	logMsg($DEBUG, "Found a total of ${layerNumber} layers");
	return ($minX, $minY, $maxX, $maxY);
}

sub doRetractMove
# Generates code for a retract (negative argument) or unretract (positive) move,
# and updates the retract state of the current extruder.
# The offsetE value may be updated if the move pushes out more than was previously retracted.
{
	my $retractDist = shift;
	# This code allows partial unretracts, although they do not make any sense and should never occur.
	$retracted[$activeTool] += $retractDist;
	# If there was extra length on unretract, add it to the offset. This assumes that only my code
	# will use extra length, extra unretract set in Slic3r is not supported!
	if($retracted[$activeTool] > 0) {
		$offsetE[$activeTool] += $retracted[$activeTool];
		$retracted[$activeTool] = 0;
	}

	return sprintf('G1 E%.5f F%d', $retractDist, $retractFeedRate[$activeTool]);
}

sub generateSquare
# Generate G-code for printing a square consisting of perimeters only, starting at the center.
# The extruder may be retracted, it will be unretracted before printing starts.
# All perimeters except the outer one are printed at the inner feed rate, unless maxPerim is non-zero.
# The 'pos' variables specify the offset, and scaleE allows to scale the E coordinates.
# If isLayer1 is true, first layer coordinates and speed will be used.
# If maxPerim is non-zero, only that many outer perimeters will be printed at the outer perimeter speed.
# If moveZTo is defined, a Z move to the given value will be performed after the first travel move.
# Return value is the total increase in E coordinate.
{
	my ($posX, $posY, $scaleE, $isLayer1, $maxPerim, $moveZTo) = @_;
	my (@travels, @coords);
	my ($innerFR, $outerFR);
	# Obviously it would be way better to generate the coordinates and E values from scratch, but
	# I hope this will end up implemented in Slic3r, therefore reimplementing part of Slic3r in this
	# temporary script would be a waste of effort.
	if($isLayer1) {
		@travels = @squareLayer1Travels;
		@coords = @squareLayer1Coords;
		($innerFR, $outerFR) = ($layer1FeedRate, $layer1FeedRate);
	}
	else {
		@travels = @squareTravels;
		@coords = @squareCoords;
		($innerFR, $outerFR) = ($innerFeedRate, $outerFeedRate);
	}
	if($maxPerim) {
		# Thanks to relative E coordinates, cutting away pieces of the precomputed tables is trivial.
		splice(@travels, 0, 1 + $#travels - $maxPerim);
		splice(@coords, 0, 1 + $#coords - $maxPerim);
	}
	my $eAdded = 0;
	for(my $i=0; $i<=$#travels; $i++) {
		my $feedRate = $innerFR;
		$feedRate = $outerFR if($maxPerim || $i == $#travels);
		push(@output, sprintf('G1 X%.3f Y%.3f F%.0f',
		                      $travels[$i][0] + $posX,
		                      $travels[$i][1] + $posY,
		                      $travelFeedRate));
		push(@output, sprintf('G1 Z%.3f F%d', $moveZTo, $travelFeedRate)) if($i == 0 && defined($moveZTo));
		push(@output, doRetractMove(-$retracted[$activeTool]) .' ; unretract') if($retracted[$activeTool]);
		push(@output, "G1 F${feedRate}");
		foreach my $coord (@{$coords[$i]}) {
			$eAdded += ${$coord}[2];
			push(@output, sprintf('G1 X%.3f Y%.3f E%.5f',
			                      ${$coord}[0] + $posX,
			                      ${$coord}[1] + $posY,
			                      ${$coord}[2] * $scaleE));
		}
	}

	return $eAdded * $scaleE;
}

sub outputTransformedCode
# Transforms and appends commands in a block of code to @output, to fit within the optimised
# output file.
{
	my $codeRef = shift;
	my $inactiveTool = ($activeTool == 0 ? 1 : 0);

	foreach my $line (@{$codeRef}) {
		if($line =~ /^G1 X\S+ Y\S+ E(\S+)($|;.*|\s.*)/) {
			# Print move: insert unretract if needed
			my $e = $1;
			if($e > 0) {
				if($retracted[$activeTool]) {
					# The priming code retracted the nozzle (or something is fishy about the original code).
					# TODO: should take extra length into account
					push(@output, doRetractMove(-$retracted[$activeTool]) .' ; UNRETRACT INSERTED1');
				}
				$originalE[$activeTool] += $e;
				$wiping[$activeTool] = 0;
			}
			else {
				# Moves can be combined with retraction if 'wipe while retracting' is enabled.
				$retracted[$activeTool] += $e;
				$wiping[$activeTool] = 1;
			}
			push(@output, $line);
		}
		elsif($line =~ /^G1 F(\S+)($|;.*|\s.*)/) {
			# Feedrate command which should always signal that printing will begin,
			# except when wiping while retracting.
			if($retracted[$activeTool] && ! $wiping[$activeTool]) {
				# The priming code retracted the nozzle (or something is fishy about the original code).
				# TODO: should take extra length into account
				push(@output, doRetractMove(-$retracted[$activeTool]) .' ; UNRETRACT INSERTED2');
			}
			push(@output, $line);
		}
		elsif($line =~ /^G1 E(\S+) (.*)/) {
			# Retract or unretract
			my ($e, $extra) = ($1, $2);
			# If positive, should correspond to 'extra length on restart' in Slic3r
			my $extraLength = $e + $retracted[$activeTool];
			if($extraLength > 0) {
				$originalE[$activeTool] += $extraLength;
			}
			else {
				$extraLength = 0;
			}

			if($e > 0) {  # unretract
				# Assumption: the code will never try something exotic like a partial unretract.
				# If this is an unretract move, it must be a complete unretract.
				$e = -$retracted[$activeTool] + $extraLength;
			}
			elsif($wiping[$activeTool]) {
				# The end of a wipe should be a bit of pure retract (5% of the total retract length
				# in Prusa3D Slic3r 1.38.4), so just leave $e as-is.
			}
			elsif($e < $retracted[$activeTool]) {
				# If it is a retract move, assume that any existing retract was done by this
				# script, therefore only retract deeper if the original code wants to retract
				# deeper. This shouldn't happen, but we do allow it.
				$e = $e - $retracted[$activeTool];
			}
			else {
				$e = 0;
			}
			$wiping[$activeTool] = 0;  # A(n un)retract move always signals the end of a wipe
			$retracted[$activeTool] += $e;
			$retracted[$activeTool] = 0 if($retracted[$activeTool] > 0);
			push(@output, sprintf('G1 E%.5f %s', $e, $extra)) if($e);
		}
		elsif($line =~ /^M(104|140) S/) {
			# Temperature changes. Disable always because they need to be performed at a different moment.
			push(@output, ";${line} ; DISABLED, will be reinserted at the right location");
		}
		elsif($line =~ /^M108 T/) {
			# Drop these to avoid any confusion, our own tool change code will insert this where appropriate
			next;
		}
		else {  # Anything else
			updateFanSpeed($line) if($line =~ /^M1[02][67]/);
			push(@output, $line);
		}
	}
}

sub outputToolChangeAndPrime
# Appends commands to @output to perform the tool change and prime the new nozzle.
{
	my ($isLayer1, $thickness, $layerZ) = @_;

	my $nextTool = ($activeTool == 0 ? 1 : 0);
	$wipeOffset = ($wipeOffset + 1) % 3;
	# This offset should not be too large: keeping it small ensures that the pillars of ooze
	# created by the heating nozzle, stick together to form one stronger pillar that helps when
	# wiping the other nozzle.
	my $yOffset = ($wipeOffset - 1) * 1.75;

	push(@output, '; - - - - - START TOOL CHANGE AND PRIME NOZZLE - - - - -');

	# Drop the temperature of this nozzle and raise the other
	my $newTemperature = $isLayer1 ? $first_layer_temperature[$nextTool] : $temperature[$nextTool];
	push(@output, "M104 S${newTemperature} T${nextTool} ; heat active nozzle");
	if($temperatureDrop) {
		push(@output, sprintf('M104 S%d T%d ; drop temperature to inhibit oozing',
		                      $temperature[$activeTool] - $temperatureDrop, $activeTool));
	}

	# We only need to consider Z lift while moving to the tower. The move away from the tower will already have lift.
	my $doLift = $retractLift[$activeTool] && $layerZ >= $retractLiftAbove[$activeTool] &&
	             ($retractLiftBelow[$activeTool] == 0 || $layerZ <= $retractLiftBelow[$activeTool]);
	push(@output, sprintf('G1 Z%.3f F%d ; LIFT Z (move to tower)', $layerZ + $retractLift[$activeTool], $travelFeedRate)) if($doLift);
	# Move to the hollow tower center, which will catch any ooze created during heating.
	# Add a variable Y offset so we don't always ooze and wipe at the same position.
	push(@output, sprintf('G1 X%.3f Y%.3f F%d', $squareX, $squareY + $yOffset, $travelFeedRate));
	push(@output, sprintf('G1 Z%.3f F%d', $layerZ, $travelFeedRate)) if($doLift);

	push(@output, 'M106 S0; disable fan') if($variableFan && $fanSpeed);

	# Do the tool swap. Use workaround to do the move at a reasonable speed, because it is not accelerated.
	# TODO: I could parse the original tool change code from the file, and fill in the template.
	$activeTool = $nextTool;
	# I have found the M108 command to be utterly irrelevant for the FFCP, but I insert it anyway
	# in case other scripts rely on it to know the tool has changed.
	push(@output, ("G1 F${toolChangeSpeed}; speed for tool change.",
	               "T${activeTool}; do actual tool swap",
	               "M108 T${activeTool}",
	               'G4 P0; flush pipeline'));
	if(! $variableFan && $fanSpeed) {
		# Only disable the fan now, because Sailfish has the stupid habit of anticipating M12[67]
		# commands for several seconds and possibly already disabling the fan while we might still
		# be printing a difficult overhang.
		push(@output, 'M127; disable fan');
	}
	# Only wait for the active nozzle to heat. The inactive nozzle should have cooled down enough
	# by that time that it will no longer ooze. It is actually better not to wait until it has
	# cooled down entirely, or the wipe may not be successful.
	# NOTE: the M6 command actually is a combined tool change + wait for heating. To merely wait,
	# an M109 command would be appropriate, but it is to avoided: only some recent Sailfish builds
	# seem to treat it as wait-for-temperature, older ones treat it as M104.
	push(@output, "M6 T${activeTool} ; wait for extruder to heat up");
	push(@output, 'G4 P'. int(1000 * $dwell) .' ; wait') if($dwell);

	# Print a full tower layer to prime the nozzle.
	push(@output, '; Print priming tower (full)');
	my $extrusionScale = $isLayer1 ?
		$extruScaleL1[$activeTool] * $thickness / $firstLayerHeightDefault :
		$extruScale[$activeTool] * $thickness / $layerHeightDefault;
	$offsetE[$activeTool] += generateSquare($squareX, $squareY, $extrusionScale, $isLayer1, 0);
	# Do a normal retract. The logic in transformCodeBlock will ensure an unretract when normal code resumes.
	push(@output, doRetractMove(-$retractLen[$activeTool]) .' ; normal retract');
	# Wipe the ooze from the deactivated nozzle.
	push(@output, sprintf('G1 X%.3f Y%.3f F%d', $squareX, $squareY + $yOffset, $travelFeedRate));

	if($fanSpeed) {
		if($variableFan) {
			push(@output, sprintf('M106 S%0.2f; re-enable fan', $fanSpeed));
		}
		else {
			# Again, the fan would enable way earlier than I would like it to, therefore block it
			# with a pipeline flush. Enable the fan before the wipe move, so it has some time to
			# spin up.
			push(@output, ('G4 P0', 'M126; re-enable fan'));
		}
	}

	my $move = $nozzleDistance;
	$move *= -1 if($activeTool == 1);
	push(@output, sprintf('G1 X%.3f Y%.3f F%d ; wipe nozzle on tower',
	                      $squareX + $move, $squareY + $yOffset, $wipeFeedRate));
	push(@output, '; - - - - - END TOOL CHANGE AND PRIME NOZZLE - - - - -');
}

sub outputTopUpPrimingTower
# Appends commands to @output to add a layer to the priming tower with the current extruder.
{
	my ($isLayer1, $thickness, $layerZ) = @_;

	push(@output, '; - - - - - START MAINTAINING PRIMING TOWER - - - - -');
	# Retract for the travel move
	push(@output, doRetractMove(-$retractLen[$activeTool]) .' ; normal retract') if(! $retracted[$activeTool]);
	# Don't move to the tower center, the tower code will make the travel move directly to the starting point.

	my $doLift = $retractLift[$activeTool] && $layerZ >= $retractLiftAbove[$activeTool] &&
	             ($retractLiftBelow[$activeTool] == 0 || $layerZ <= $retractLiftBelow[$activeTool]);
	push(@output, sprintf('G1 Z%.3f F%d ; LIFT Z (move to tower)', $layerZ + $retractLift[$activeTool], $travelFeedRate)) if($doLift);
	my $restoreZTo;
	$restoreZTo = $layerZ if($doLift);

	# Print a minimal tower layer to ensure continuity of the tower (unless this is the first
	# layer, then we want a solid base).
	my $how = $isLayer1 ? 'full' : 'hollow';
	push(@output, "; Print priming tower (${how})");
	my $maxPerim = $isLayer1 ? 0 : $towerMaintainPerimeters;
	my $extrusionScale = $isLayer1 ?
		$extruScaleL1[$activeTool] * $thickness / $firstLayerHeightDefault :
		$extruScale[$activeTool] * $thickness / $layerHeightDefault;
	$offsetE[$activeTool] +=
		generateSquare($squareX, $squareY,
		               $extrusionScale, $isLayer1, $maxPerim, $restoreZTo);
	if($maintainVLine && !$isLayer1) {
		my $lineY = $maintainLineYPos[$maxPerim];
		my $lineE = (2 * $lineY) * $primingFlowRate * $extrusionScale;
		push(@output, sprintf('G1 X%.3f Y%.3f F%.0f ; print maintaining Y line', $squareX, $squareY + $lineY, $travelFeedRate));
		push(@output, sprintf('G1 X%.3f Y%.3f E%.5f F%.5f', $squareX, $squareY - $lineY, $lineE, $outerFeedRate));
		$offsetE[$activeTool] += $lineE;
	}
	# Retract before handing over control to the original code again.
	# The logic in transformCodeBlock will ensure that an unretract is added when resuming
	# printing, and additional attempts at retracts are ignored.
	push(@output, doRetractMove(-$retractLen[$activeTool]) .' ; normal retract');
	push(@output, '; - - - - - END MAINTAINING PRIMING TOWER - - - - -');
}
