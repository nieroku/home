{ config, lib, pkgs, ... }:

{
  config = lib.mkIf (config.local.desktop == "sway") {
    home.packages = with pkgs; [
      i3status-rust
      j4-dmenu-desktop
      rofi
      wl-clipboard
    ];

    services = {
      flameshot = {
        enable = true;
        settings = {
          General = {
            autoCloseIdleDaemon = false;
            disabledTrayIcon = true;
            drawColor = "#ff0000";
            filenamePattern = "%e.%m.%y_%H.%M";
            saveAfterCopy = false;
            savePath = "Screenshots";
            savePathFixed = true;
            showDesktopNotification = false;
          };
        };
      };
      mako.enable = true;
      mpris-proxy.enable = true;
      playerctld.enable = true;
    };

    wayland.windowManager.sway = {
      enable = true;
      config = null;
      extraConfig = lib.mkMerge [
        ''
          include ~/.config/sway/*.conf
        ''
        (
          lib.mkIf
            (config.local.wallpaper != null)
            ''
              output "*" bg ${config.local.wallpaper} fill
            ''
        )
      ];
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
  };
}
