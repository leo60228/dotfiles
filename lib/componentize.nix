relativePath:
let name = builtins.elemAt (builtins.match ".*\/(.+)\.nix" relativePath) 0;
    path = ./. + "/${relativePath}";
in rec {
  _isComponent = true;
  __functor = self: override: if builtins.elem "_isComponent" (builtins.attrNames override) then self // {
    config = self.config // override.config // {${name} = self.config.${name};};
    enabled = override.enabled // self.enabled;
    _lastComponent = override._name;
  } else self // {
    config = self.config // {
      ${self._lastComponent} = override;
    };
  };
  enabled.${name} = true;
  config.${name} = {};
  _lastComponent = name;
  _name = name;
} {}
