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

        userName = lib.mkDefault username;
        userEmail = lib.mkDefault email;
      };
      home-manager.enable = true;
      neovim = {
        defaultEditor = true;
        enable = true;
        extraPackages = with pkgs; [
          fd
          ripgrep
        ];
        extraWrapperArgs = [
          "--prefix"
          "PATH"
          ":"
          "${lib.makeBinPath [ pkgs.gcc ]}"
        ];
        plugins = with pkgs.vimPlugins; [ lazy-nvim ];
      };
      ranger.enable = true;
      tmux = {
        enable = true;
        extraConfig = "source ~/.config/tmux/main.tmux";
        sensibleOnTop = false;
        plugins = with pkgs.tmuxPlugins; [ sensible ];
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
  };
}
