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
    vim-wordmotion = mkNvimPlugin inputs.vim-wordmotion "vim-wordmotion";
    nvim-highlight-colors = mkNvimPlugin inputs.nvim-highlight-colors "nvim-highlight-colors";
    # leap = mkNvimPlugin inputs.leap "leap.nvim";
    flash-nvim = mkNvimPlugin inputs.flash-nvim "flash.nvim";
    eyeliner-nvim = mkNvimPlugin inputs.eyeliner-nvim "eyeliner.nvim";
    gitlinker = mkNvimPlugin inputs.gitlinker "gitlinker.nvim";
    repeat = mkNvimPlugin inputs.repeat "vim-repeat";
    unimpaired = mkNvimPlugin inputs.unimpaired "vim-unimpaired";
    surround = mkNvimPlugin inputs.surround "nvim-surround";
    substitute = mkNvimPlugin inputs.substitute "substitute.nvim";
    persistence = mkNvimPlugin inputs.persistence "persistence.nvim";
    nvim-lastplace = mkNvimPlugin inputs.nvim-lastplace "nvim-lastplace";
    comment = mkNvimPlugin inputs.comment "comment.nvim";
    crates-nvim = mkNvimPlugin inputs.crates-nvim "crates-nvim";
    neotest = mkNvimPlugin inputs.neotest "neotest";
    nio = mkNvimPlugin inputs.nio "nvim-nio";
    neotest-java = mkNvimPlugin inputs.neotest-java "neotest-java";
    neotest-busted = mkNvimPlugin inputs.neotest-busted "neotest-busted";
    schemastore-nvim = mkNvimPlugin inputs.schemastore-nvim "SchemaStore.nvim";
    jdtls = mkNvimPlugin inputs.jdtls "nvim-jdtls";
    live-rename-nvim = mkNvimPlugin inputs.live-rename-nvim "live-rename.nvim";
    fidget = mkNvimPlugin inputs.fidget "fidget.nvim";
    illuminate = mkNvimPlugin inputs.illuminate "vim-illuminate";
    actions-preview-nvim = mkNvimPlugin inputs.actions-preview-nvim "actions-preview.nvim";
    treesitter-textobjects = mkNvimPlugin inputs.treesitter-textobjects "treesitter-textobjects";
    treesitter-context = mkNvimPlugin inputs.treesitter-context "treesitter-context";
    nvim-ts-context-commentstring = mkNvimPlugin inputs.nvim-ts-context-commentstring "nvim-ts-context-commentstring";
    rainbow-delimiters-nvim = mkNvimPlugin inputs.rainbow-delimiters-nvim "rainbow-delimiters.nvim";
    vim-matchup = mkNvimPlugin inputs.vim-matchup "vim-matchup";
    nvim-lint = mkNvimPlugin inputs.nvim-lint "nvim-lint";
    telescope = mkNvimPlugin inputs.telescope "telescope.nvim";
    telescope_hoogle = mkNvimPlugin inputs.telescope_hoogle "telescope_hoogle";
    telescope-smart-history = mkNvimPlugin inputs.telescope-smart-history "telescope-smart-history.nvim";
    telescope-zf-native = mkNvimPlugin inputs.telescope-zf-native "telescope-zf-native.nvim";
    todo-comments = mkNvimPlugin inputs.todo-comments "todo-comments.nvim";
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
    statuscol = mkNvimPlugin inputs.statuscol "statuscol";
    nvim-unception = mkNvimPlugin inputs.nvim-unception "nvim-unception";
    tmux-nvim = mkNvimPlugin inputs.tmux-nvim "tmux.nvim";
    term-edit-nvim = mkNvimPlugin inputs.term-edit-nvim "term-edit.nvim";
    other-nvim = mkNvimPlugin inputs.other-nvim "other.nvim";
    which-key-nvim = mkNvimPlugin inputs.which-key-nvim "which-key.nvim";
  };
}
