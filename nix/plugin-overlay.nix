{inputs}: final: prev: let
  mkNvimPlugin = src: pname:
    prev.pkgs.vimUtils.buildVimPlugin {
      inherit pname src;
      version = src.lastModifiedDate;
    };
in {
  nvimPlugins = {
    plenary = mkNvimPlugin inputs.plenary "plenary.nvim";
    sqlite = mkNvimPlugin inputs.sqlite "sqlite.nvim";
    nvim-web-devicons = mkNvimPlugin inputs.nvim-web-devicons "nvim-web-devicons";
    diffview = mkNvimPlugin inputs.diffview "diffview.nvim";
    vim-wordmotion = mkNvimPlugin inputs.vim-wordmotion "vim-wordmotion";
    nvim-highlight-colors = mkNvimPlugin inputs.nvim-highlight-colors "nvim-highlight-colors";
    # leap = mkNvimPlugin inputs.leap "leap.nvim";
    flash-nvim = mkNvimPlugin inputs.flash-nvim "flash.nvim";
    eyeliner-nvim = mkNvimPlugin inputs.eyeliner-nvim "eyeliner.nvim";
    neogit = mkNvimPlugin inputs.neogit "neogit";
    gitlinker = mkNvimPlugin inputs.gitlinker "gitlinker.nvim";
    repeat = mkNvimPlugin inputs.repeat "vim-repeat";
    unimpaired = mkNvimPlugin inputs.unimpaired "vim-unimpaired";
    surround = mkNvimPlugin inputs.surround "nvim-surround";
    substitute = mkNvimPlugin inputs.substitute "substitute.nvim";
    persistence = mkNvimPlugin inputs.persistence "persistence.nvim";
    nvim-lastplace = mkNvimPlugin inputs.nvim-lastplace "nvim-lastplace";
    comment = mkNvimPlugin inputs.comment "comment.nvim";
    material-theme = mkNvimPlugin inputs.material-theme "material.nvim";
    crates-nvim = mkNvimPlugin inputs.crates-nvim "crates-nvim";
    neotest = mkNvimPlugin inputs.neotest "neotest";
    nio = mkNvimPlugin inputs.nio "nvim-nio";
    neotest-java = mkNvimPlugin inputs.neotest-java "neotest-java";
    neotest-busted = mkNvimPlugin inputs.neotest-busted "neotest-busted";
    schemastore-nvim = mkNvimPlugin inputs.schemastore-nvim "SchemaStore.nvim";
    jdtls = mkNvimPlugin inputs.jdtls "nvim-jdtls";
    nvim-metals = mkNvimPlugin inputs.nvim-metals "nvim-metals";
    nvim-dap = mkNvimPlugin inputs.nvim-dap "nvim-dap";
    nvim-dap-ui = mkNvimPlugin inputs.nvim-dap-ui "nvim-dap-ui";
    live-rename-nvim = mkNvimPlugin inputs.live-rename-nvim "live-rename.nvim";
    lsp-status = mkNvimPlugin inputs.lsp-status "lsp-status.nvim";
    fidget = mkNvimPlugin inputs.fidget "fidget.nvim";
    illuminate = mkNvimPlugin inputs.illuminate "vim-illuminate";
    actions-preview-nvim = mkNvimPlugin inputs.actions-preview-nvim "actions-preview.nvim";
    nvim-treesitter = prev.vimPlugins.nvim-treesitter.withAllGrammars.overrideAttrs (_: _: {
      # TODO: re-enable when sql highlights are fixed
      # src = inputs.nvim-treesitter;
    });
    treesitter-textobjects = mkNvimPlugin inputs.treesitter-textobjects "treesitter-textobjects";
    treesitter-context = mkNvimPlugin inputs.treesitter-context "treesitter-context";
    nvim-ts-context-commentstring = mkNvimPlugin inputs.nvim-ts-context-commentstring "nvim-ts-context-commentstring";
    wildfire-nvim = mkNvimPlugin inputs.wildfire-nvim "wildfire.nvim";
    rainbow-delimiters-nvim = mkNvimPlugin inputs.rainbow-delimiters-nvim "rainbow-delimiters.nvim";
    vim-matchup = mkNvimPlugin inputs.vim-matchup "vim-matchup";
    iswap-nvim = mkNvimPlugin inputs.iswap-nvim "iswap.nvim";
    nvim-lint = mkNvimPlugin inputs.nvim-lint "nvim-lint";
    telescope = mkNvimPlugin inputs.telescope "telescope.nvim";
    telescope_hoogle = mkNvimPlugin inputs.telescope_hoogle "telescope_hoogle";
    telescope-smart-history = mkNvimPlugin inputs.telescope-smart-history "telescope-smart-history.nvim";
    telescope-zf-native = mkNvimPlugin inputs.telescope-zf-native "telescope-zf-native.nvim";
    todo-comments = mkNvimPlugin inputs.todo-comments "todo-comments.nvim";
    fzf-lua = mkNvimPlugin inputs.fzf-lua "fzf-lua";
    lualine = mkNvimPlugin inputs.lualine "lualine";
    nvim-navic = mkNvimPlugin inputs.nvim-navic "nvim-navic";
    oil-nvim = mkNvimPlugin inputs.oil-nvim "oil.nvim";
    toggleterm = mkNvimPlugin inputs.toggleterm "toggleterm.nvim";
    harpoon = mkNvimPlugin inputs.harpoon "harpoon";
    gitsigns = mkNvimPlugin inputs.gitsigns "gitsigns.nvim";
    nvim-bqf = mkNvimPlugin inputs.nvim-bqf "nvim-bqf";
    quicker-nvim = mkNvimPlugin inputs.quicker-nvim "quicker.nvim";
    formatter = mkNvimPlugin inputs.formatter "formatter.nvim";
    yanky = mkNvimPlugin inputs.yanky "yanky.nvim";
    promise-async = mkNvimPlugin inputs.promise-async "promise-async";
    nvim-ufo = mkNvimPlugin inputs.nvim-ufo "nvim-ufo";
    statuscol = mkNvimPlugin inputs.statuscol "statuscol";
    nvim-unception = mkNvimPlugin inputs.nvim-unception "nvim-unception";
    tmux-nvim = mkNvimPlugin inputs.tmux-nvim "tmux.nvim";
    hardtime-nvim = mkNvimPlugin inputs.hardtime-nvim "hardtime.nvim";
    term-edit-nvim = mkNvimPlugin inputs.term-edit-nvim "term-edit.nvim";
    other-nvim = mkNvimPlugin inputs.other-nvim "other.nvim";
    which-key-nvim = mkNvimPlugin inputs.which-key-nvim "which-key.nvim";
  };
}
