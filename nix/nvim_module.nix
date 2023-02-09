{
  pkgs,
  config,
  lib,
  ...
}:
with lib; let
  cfg = config.programs.nvim;
  pluginWithConfigType = types.submodule {
    options = with types; {
      config = mkOption {
        type = nullOr lines;
        description = "Lua script to configure this plugin.";
        default = null;
      };

      optional =
        mkEnableOption "optional"
        // {
          description = "Don't load by default (load with :packadd)";
        };

      plugin = mkOption {
        type = package;
        description = "neovim plugin";
      };
    };
  };

  devPluginWithConfigType = types.submodule {
    options = with types; {
      name = mkOption {
        type = str;
        description = "The name of the plugin.";
        example = literalExpression "my-plugin";
      };
      url = mkOption {
        type = str;
        description = "The url to check out.";
        example = literalExpression "git@github.com:owner/my-plugin.git";
      };
      config = mkOption {
        type = nullOr lines;
        description = "Lua script to configure this plugin.";
        default = null;
      };
    };
  };

  luaPackages = cfg.finalPackage.unwrapped.lua.pkgs;
  resolvedExtraLuaPackages = cfg.extraLuaPackages luaPackages;

  defaultPlugin = {
    plugin = null;
    config = null;
    optional = false;
    runtime = {};
  };

  normalizedPlugins = map (x:
    defaultPlugin
    // (
      if x ? plugin
      then x
      else {plugin = x;}
    ))
  cfg.plugins;

  extraMakeWrapperArgs = builtins.concatStringsSep " " (
    (optional (cfg.extraPackages != [])
      ''--prefix PATH : "${makeBinPath cfg.extraPackages}"'')
    ++ (optional (cfg.wrapRc)
      ''--add-flags -u --add-flags "${pkgs.writeText "init.lua" customRC}"'')
  );

  extraMakeWrapperLuaCArgs = optionalString (resolvedExtraLuaPackages != []) ''
    --suffix LUA_CPATH ";" "${
      lib.concatMapStringsSep ";" luaPackages.getLuaCPath
      resolvedExtraLuaPackages
    }"'';

  extraMakeWrapperLuaArgs =
    optionalString (resolvedExtraLuaPackages != [])
    ''
      --suffix LUA_PATH ";" "${
        concatMapStringsSep ";" luaPackages.getLuaPath
        resolvedExtraLuaPackages
      }"'';

  wrappedNeovim = pkgs.wrapNeovimUnstable cfg.package (neovimConfig
    // {
      wrapperArgs =
        lib.escapeShellArgs neovimConfig.wrapperArgs
        + " "
        + extraMakeWrapperArgs
        + " "
        + extraMakeWrapperLuaCArgs
        + " "
        + extraMakeWrapperLuaArgs;
      wrapRc = false;
    });
  neovimConfig = pkgs.neovimUtils.makeNeovimConfig {
    inherit (cfg) extraPython3Packages withPython3 withRuby withNodeJs viAlias vimAlias;
    plugins = normalizedPlugins;
  };

  customRC =
    ''
      local pack_path = vim.fn.stdpath("data") .. "/site/pack/dev",
      local dev_plugins_dir = pack_path .. '/opt'
      local dev_plugin_path
    ''
    + optionalString (cfg.devPlugins != []) (
      strings.concatMapStringsSep
      "\n"
      (plugin: ''
        dev_plugin_path = dev_plugins_dir .. '/${plugin.name}'
        if vim.fn.empty(vim.fn.glob(dev_plugin_path)) > 0 then
          vim.notify('Bootstrapping dev plugin ${plugin.name} ...', vim.log.levels.INFO)
          vim.cmd('!${pkgs.git}/bin/git clone ${plugin.url} ' .. dev_plugin_path)
        end
        vim.cmd.packadd('${plugin.name}')
      '')
    )
    cfg.devPlugins
    + neovimConfig.neovimRcContent
    + optionalString (cfg.extraConfigLua != "") ''
      ${cfg.extraConfigLua}
    '';
in {
  options = with types; {
    programs.nvim = {
      enable = mkEnableOption "nvim";

      viAlias = mkOption {
        type = bool;
        default = false;
        description = ''
          Symlink <command>vi</command> to <command>nvim</command> binary.
        '';
      };

      vimAlias = mkOption {
        type = bool;
        default = false;
        description = ''
          Symlink <command>vim</command> to <command>nvim</command> binary.
        '';
      };

      vimdiffAlias = mkOption {
        type = bool;
        default = false;
        description = ''
          Alias <command>vimdiff</command> to <command>nvim -d</command>.
        '';
      };

      withNodeJs = mkOption {
        type = bool;
        default = false;
        description = ''
          Enable node provider. Set to <literal>true</literal> to
          use Node plugins.
        '';
      };

      withRuby = mkOption {
        type = nullOr bool;
        default = true;
        description = ''
          Enable ruby provider.
        '';
      };

      withPython3 = mkOption {
        type = bool;
        default = true;
        description = ''
          Enable Python 3 provider. Set to <literal>true</literal> to
          use Python 3 plugins.
        '';
      };

      extraPython3Packages = mkOption {
        type = functionTo (listOf package);
        default = _: [];
        defaultText = literalExpression "ps: [ ]";
        example =
          literalExpression "pyPkgs: with pyPkgs; [ python-language-server ]";
        description = ''
          Extra Python 3 packages.
          This option accepts a function that takes a Python 3 package set as an argument,
          and selects the required Python 3 packages from this package set.
          See the example for more info.
        '';
      };

      extraLuaPackages = mkOption {
        type = functionTo (listOf package);
        default = _: [];
        defaultText = literalExpression "ps: [ ]";
        example = literalExpression "luaPkgs: with luaPkgs; [ luautf8 ]";
        description = ''
          Extra lua packages.
          This option accepts a function that takes a Lua package set as an argument,
          and selects the required Lua packages from this package set.
          See the example for more info.
        '';
      };

      extraPackages = mkOption {
        type = listOf package;
        default = [];
        description = "Extra packages to be made available to neovim";
      };

      extraConfigLua = mkOption {
        type = lines;
        default = "";
        description = "Extra contents for init.lua";
      };

      wrapRc = mkOption {
        type = bool;
        description = "Should the config be included in the wrapper script";
        default = false;
      };

      package = mkOption {
        type = package;
        default = pkgs.neovim-unwrapped;
        defaultText = literalExpression "pkgs.neovim-unwrapped";
        description = "The package to use for the neovim binary.";
      };

      finalPackage = mkOption {
        type = package;
        visible = false;
        readOnly = true;
        description = "Resulting customized neovim package.";
      };

      defaultEditor = mkOption {
        type = bool;
        default = false;
        description = ''
          Whether to configure <command>nvim</command> as the default
          editor using the <envar>EDITOR</envar> environment variable.
        '';
      };

      initContent = mkOption {
        type = str;
        description = "The content of the init.lua file";
        readOnly = true;
        visible = false;
      };

      plugins = mkOption {
        type = listOf (either package pluginWithConfigType);
        default = [];
        example = literalExpression ''
          with pkgs.vimPlugins; [
            yankring
            vim-nix
            { plugin = vim-startify;
              config = "let g:startify_change_to_vcs_root = 0";
            }
          ]
        '';
        description = ''
          List of neovim plugins to install optionally associated with
          configuration to be placed in init.lua.
        '';
      };

      devPlugins = mkOption {
        type = listOf devPluginWithConfigType;
        default = [];
        example = literalExpression ''
          [
              { name = "haskell-tools.nvim";
                url = "git@github.com:mrcjkb/haskell-tools.nvim.git";
              }
          ];
        '';
      };
    };
  };

  config = mkIf cfg.enable (mkMerge [
    {
      environment = {
        systemPackages = [cfg.finalPackage];
        sessionVariables = mkIf cfg.defaultEditor {EDITOR = "nvim";};
      };

      programs = {
        bash.shellAliases = mkIf cfg.vimdiffAlias {vimdiff = "nvim -d";};
        fish.shellAliases = mkIf cfg.vimdiffAlias {vimdiff = "nvim -d";};
        zsh.shellAliases = mkIf cfg.vimdiffAlias {vimdiff = "nvim -d";};
        nvim = {
          finalPackage = wrappedNeovim;
          initContent = customRC;
        };
      };
    }
    (mkIf (!cfg.wrapRc) {
      home-manager.sharedModules = [
        {
          xdg.configFile."nvim/init.lua".text = cfg.initContent;
        }
      ];
    })
  ]);
}
