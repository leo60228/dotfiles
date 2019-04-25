str: builtins.elemAt (builtins.filter (x: !builtins.isList x) (builtins.split "\n" str)) 0
