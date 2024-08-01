{ config, pkgs, ... }:

{
  imports = [
    ./local.nix
  ];

  home.packages = with pkgs; [
    fd
    flameshot
    i3status-rust
    j4-dmenu-desktop
    neovim
    overskride
    playerctl
    pwvucontrol
    ranger
    rofi
    ripgrep
    waybar
    wezterm
    wl-clipboard
  ];

  programs = {
    direnv = {
      enable = true;
      enableZshIntegration = true;
      nix-direnv.enable = true;
    };
    home-manager.enable = true;
    git = {
      enable = true;
      ignores = [ ".direnv/" ".envrc" ];
    };
    zsh = {
      enable = true;
      enableCompletion = true;
      autosuggestion.enable = true;
      syntaxHighlighting.enable = true;
      oh-my-zsh = {
        enable = true;
        plugins = [ "aliases" "git" "python" "vi-mode" ];
      };
    };
    starship.enable = true;
  };

  services = {
    mako.enable = true;
    mpris-proxy.enable = true;
    playerctld.enable = true;
    swayidle = {
      enable = true;
      events = let command = "${pkgs.swaylock-effects}/bin/swaylock"; in [
        { event = "before-sleep"; inherit command; }
        { event = "lock"; inherit command; }
      ];
      timeouts = [{ timeout = 600; command = "${pkgs.systemd}/bin/loginctl lock-session"; }];
    };
  };

  wayland.windowManager.sway = {
    enable = true;
    config = null;
    extraConfig = "include ~/.config/sway/*.conf\n";
    wrapperFeatures.gtk = true;
  };

  xdg.portal = {
    enable = true;
    extraPortals = with pkgs; [ xdg-desktop-portal-gtk xdg-desktop-portal-wlr ];
    config.common = {
      default = "*";
      "org.freedesktop.impl.portal.Screenshot" = "wlr";
      "org.freedesktop.impl.portal.ScreenCast" = "wlr";
    };
    xdgOpenUsePortal = true;
  };

  home.sessionVariables = {
    EDITOR = "nvim";
  };
}
