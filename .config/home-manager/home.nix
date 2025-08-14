{ config, lib, pkgs, ... }:

with config.local; {
  imports = [
    ./desktop

    ./local.nix
  ];
  options.local = with lib; {
    username = mkOption { type = types.str; };
    email = mkOption {
      type = types.nullOr types.str;
      default = null;
    };
  };
  config = {
    home = {
      username = username;
      homeDirectory = lib.mkOptionDefault "/home/${username}";
    };

    programs = {
      command-not-found.enable = true;
      direnv = {
        enable = true;
        enableZshIntegration = true;
        nix-direnv.enable = true;
      };
      git = {
        enable = true;
        ignores = [ ".direnv/" ".envrc" ];
        extraConfig = {
          init.defaultBranch = "main";
        };

        userName = lib.mkDefault username;
        userEmail = lib.mkDefault email;
      };
      home-manager.enable = true;
      neovim = {
        defaultEditor = true;
        enable = true;
        extraPackages = with pkgs; [
          fd
          fzf
          gh
          nodejs
          ripgrep
          tree-sitter
        ];
        extraWrapperArgs = [
          "--prefix"
          "PATH"
          ":"
          "${lib.makeBinPath [ pkgs.gcc ]}"
        ];
      };
      ranger.enable = true;
      tmux = {
        enable = true;
        extraConfig = "source ~/.config/tmux/main.tmux";
        sensibleOnTop = false;
        plugins = with pkgs.tmuxPlugins; [ sensible ];
      };
      zathura.enable = true;
      zsh = {
        enable = true;
        enableCompletion = true;
        autosuggestion.enable = true;
        syntaxHighlighting.enable = true;
        initContent = ''
          ranger() {
              if [ -z "$RANGER_LEVEL" ]; then
                  ${config.programs.ranger.package}/bin/ranger "$@"
              else
                  exit
              fi
          }
        '';
        oh-my-zsh = {
          enable = true;
          plugins = [ "aliases" "git" "python" "vi-mode" ];
        };
      };
      starship.enable = true;
    };

    xdg.mimeApps = {
      enable = true;
      defaultApplications = {
        "application/pdf" = [ "org.pwmt.zathura.desktop" ];
      };
    };
  };
}
