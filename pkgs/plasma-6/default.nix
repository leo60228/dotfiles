{ qt6Packages, lib }:

lib.makeScope qt6Packages.newScope (self: with self; {
  breeze-qt6 = callPackage ./breeze-qt6.nix {};
  extra-cmake-modules = callPackage ./extra-cmake-modules {};
  kactivities = callPackage ./kactivities.nix {};
  karchive = callPackage ./karchive.nix {};
  kauth = callPackage ./kauth {};
  kbookmarks = callPackage ./kbookmarks.nix {};
  kcmutils = callPackage ./kcmutils.nix {};
  kcodecs = callPackage ./kcodecs.nix {};
  kcolorscheme = callPackage ./kcolorscheme.nix {};
  kcompletion = callPackage ./kcompletion.nix {};
  kconfig = callPackage ./kconfig.nix {};
  kconfigwidgets = callPackage ./kconfigwidgets.nix {};
  kcoreaddons = callPackage ./kcoreaddons.nix {};
  kcrash = callPackage ./kcrash.nix {};
  kdbusaddons = callPackage ./kdbusaddons.nix {};
  kglobalaccel = callPackage ./kglobalaccel.nix {};
  kguiaddons = callPackage ./kguiaddons.nix {};
  ki18n = callPackage ./ki18n.nix {};
  kiconthemes = callPackage ./kiconthemes {};
  kio = callPackage ./kio {};
  kirigami2 = callPackage ./kirigami2.nix {};
  kitemviews = callPackage ./kitemviews.nix {};
  kjobwidgets = callPackage ./kjobwidgets.nix {};
  knotifications = callPackage ./knotifications.nix {};
  kservice = callPackage ./kservice {};
  kwidgetsaddons = callPackage ./kwidgetsaddons.nix {};
  kwindowsystem = callPackage ./kwindowsystem {};
  kxmlgui = callPackage ./kxmlgui.nix {};
  plasma-wayland-protocols = callPackage ./plasma-wayland-protocols {};
  solid = callPackage ./solid {};
})
