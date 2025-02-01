{ config, lib, pkgs, ... }:

{
  imports = [
    ./sway.nix
  ];
  options.local.desktop = with lib; mkOption {
    type = types.nullOr (types.enum [ "sway" ]);
    default = null;
  };
  config = lib.mkIf (config.local.desktop != null) {
    home.packages = with pkgs; [
      wezterm
    ];

    programs.ranger.settings = {
      preview_images = true;
      preview_images_method = "iterm2";
    };
  };
}
