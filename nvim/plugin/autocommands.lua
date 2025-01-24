local api = vim.api
local keymap = vim.keymap
local methods = vim.lsp.protocol.Methods

local tempdirgroup = api.nvim_create_augroup('tempdir', { clear = true })
-- Do not set undofile for files in /tmp
api.nvim_create_autocmd('BufWritePre', {
  pattern = '/tmp/*',
  group = tempdirgroup,
  callback = function()
    vim.cmd.setlocal('noundofile')
  end,
})

local numbertoggle = api.nvim_create_augroup('numbertoggle', { clear = true })
-- Toggle between relative/absolute line numbers
api.nvim_create_autocmd({ 'BufEnter', 'FocusGained', 'InsertLeave', 'CmdlineLeave', 'WinEnter' }, {
  pattern = '*',
  group = numbertoggle,
  callback = function()
    if vim.o.nu and api.nvim_get_mode().mode ~= 'i' then
      vim.opt.relativenumber = true
    end
  end,
})

api.nvim_create_autocmd({ 'BufLeave', 'FocusLost', 'InsertEnter', 'CmdlineEnter', 'WinLeave' }, {
  pattern = '*',
  group = numbertoggle,
  callback = function()
    if vim.o.nu then
      vim.opt.relativenumber = false
      vim.cmd.redraw()
    end
  end,
})

local nospell_group = api.nvim_create_augroup('nospell', { clear = true })

api.nvim_create_autocmd('TermOpen', {
  group = nospell_group,
  callback = function()
    vim.wo[0].spell = false
  end,
})

local highlight_cur_n_group = api.nvim_create_augroup('highlight-current-n', { clear = true })
api.nvim_create_autocmd('ColorScheme', {
  callback = function()
    local search = api.nvim_get_hl(0, { name = 'Search' })
    ---@diagnostic disable-next-line: cast-type-mismatch
    ---@cast search vim.api.keyset.highlight
    api.nvim_set_hl(0, 'CurSearch', { link = 'IncSearch' })
    api.nvim_set_hl(0, 'SearchCurrentN', search)
    return api.nvim_set_hl(0, 'Search', { link = 'SearchCurrentN' })
  end,
  group = highlight_cur_n_group,
})
api.nvim_create_autocmd('CmdlineEnter', {
  pattern = '/,\\?',
  callback = function()
    vim.opt.hlsearch = true
    vim.opt.incsearch = true
    return api.nvim_set_hl(0, 'Search', { link = 'SearchCurrentN' })
  end,
  group = highlight_cur_n_group,
})
api.nvim_create_autocmd('CmdlineLeave', {
  pattern = '/,\\?',
  callback = function()
    api.nvim_set_hl(0, 'Search', {})
    local function _4_()
      vim.opt.hlsearch = true
      return nil
    end
    return vim.defer_fn(_4_, 5) ~= nil
  end,
  group = highlight_cur_n_group,
})
api.nvim_create_autocmd({ 'InsertEnter', 'CursorMoved' }, {
  callback = vim.schedule_wrap(function()
    vim.cmd.nohlsearch()
  end),
  group = highlight_cur_n_group,
})
local function handle_n_N(key)
  do
    local function other(mode)
      if mode == 'n' then
        return 'N'
      elseif mode == 'N' then
        return 'n'
      else
        return nil
      end
    end
    local function feed(keys)
      return api.nvim_feedkeys(keys, 'n', true)
    end
    if vim.v.searchforward == 0 then
      feed(other(key))
    elseif vim.v.searchforward == 1 then
      feed(key)
    end
  end
  return vim.defer_fn(function()
    vim.opt.hlsearch = true
    return nil
  end, 5)
end
keymap.set({ 'n' }, 'n', function()
  return handle_n_N('n')
end)
keymap.set({ 'n' }, 'N', function()
  return handle_n_N('N')
end)

---@param filter 'Function' | 'Module' | 'Struct'
local function filtered_document_symbol(filter)
  vim.lsp.buf.document_symbol()
  vim.cmd.Cfilter(('[[%s]]'):format(filter))
end

local function preview_location_callback(_, result)
  if result == nil or vim.tbl_isempty(result) then
    return nil
  end
  local buf, _ = vim.lsp.util.preview_location(result[1], {})
  if buf then
    local cur_buf = vim.api.nvim_get_current_buf()
    vim.bo[buf].filetype = vim.bo[cur_buf].filetype
  end
end

local function peek_definition()
  local params = vim.lsp.util.make_position_params(0, 'utf-8')
  return vim.lsp.buf_request(0, methods.textDocument_definition, params, preview_location_callback)
end

local function peek_type_definition()
  local params = vim.lsp.util.make_position_params(0, 'utf-8')
  return vim.lsp.buf_request(0, methods.textDocument_typeDefinition, params, preview_location_callback)
end

local function document_functions()
  filtered_document_symbol('Function')
end

local function document_modules()
  filtered_document_symbol('Module')
end

local function document_structs()
  filtered_document_symbol('Struct')
end

local function code_action()
  return require('actions-preview').code_actions()
  -- return vim.lsp.buf.code_action()
end

local function go_to_first_import()
  vim.lsp.buf.document_symbol {
    on_list = function(lst)
      for _, results in pairs(lst) do
        if type(results) ~= 'table' then
          goto Skip
        end
        for _, result in ipairs(results) do
          if result.kind == 'Module' then
            local lnum = result.lnum
            vim.api.nvim_input("m'")
            vim.api.nvim_win_set_cursor(0, { lnum, 0 })
            return
          end
        end
      end
      ::Skip::
      vim.notify('No imports found.', vim.log.levels.WARN)
    end,
  }
end

local lsp_augroup = vim.api.nvim_create_augroup('UserLspConfig', {})

vim.api.nvim_create_autocmd('LspProgress', {
  group = lsp_augroup,
  once = true,
  callback = function()
    require('fidget').setup {
      -- Options related to LSP progress subsystem
      progress = {
        ignore_done_already = true, -- Ignore new tasks that are already complete

        -- Options related to how LSP progress messages are displayed as notifications
        display = {
          render_limit = 3, -- How many LSP messages to show at once
        },
      },
      notification = {
        override_vim_notify = false,
      },
    }
  end,
})

vim.api.nvim_create_autocmd('LspAttach', {
  group = lsp_augroup,
  callback = function(ev)
    if not vim.g.initial_lsp_attach_done then
      local default_on_codelens = vim.lsp.codelens.on_codelens
      ---@diagnostic disable-next-line: duplicate-set-field
      vim.lsp.codelens.on_codelens = function(err, lenses, ctx, _)
        if err or not lenses or not next(lenses) then
          return default_on_codelens(err, lenses, ctx, _)
        end
        for _, lens in pairs(lenses) do
          if lens and lens.command and lens.command.title then
            lens.command.title = ' ' .. lens.command.title
          end
        end
        return default_on_codelens(err, lenses, ctx, _)
      end
      require('actions-preview').setup {
        backend = { 'telescope' },
      }
      vim.g.initial_lsp_attach_done = true
    end

    local bufnr = ev.buf
    local client = vim.lsp.get_client_by_id(ev.data.client_id)
    if not client then
      return
    end
    if client:supports_method(methods.textDocument_documentSymbol) then
      require('nvim-navic').attach(client, bufnr)
    end
    vim.cmd.setlocal('signcolumn=yes')

    local function buf_set_var(...)
      api.nvim_buf_set_var(bufnr, ...)
    end

    vim.bo[bufnr].bufhidden = 'hide'

    buf_set_var('lsp_client_id', client.id)

    local function desc(description)
      return { noremap = true, silent = true, buffer = bufnr, desc = description }
    end

    -- Mappings.
    keymap.set('n', 'gD', vim.lsp.buf.declaration, desc('lsp: go to [D]eclaration'))
    keymap.set('n', 'gd', vim.lsp.buf.definition, desc('lsp: go to [d]efinition'))
    keymap.set('n', '<space>gt', vim.lsp.buf.type_definition, desc('lsp: go to [t]ype definition'))
    keymap.set('n', '<space>pd', peek_definition, desc('lsp: [p]eek [d]efinition'))
    keymap.set('n', '<space>pt', peek_type_definition, desc('lsp: [p]eek [t]ype definition'))
    keymap.set('n', 'gi', vim.lsp.buf.implementation, desc('lsp: go to [i]mplementation'))
    keymap.set('n', '<space>gi', go_to_first_import, desc('lsp: [g]o to fist [i]mport'))
    keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, desc('lsp: signature help'))
    keymap.set('n', '<space>wa', vim.lsp.buf.add_workspace_folder, desc('lsp: [w]orkspace folder [a]dd'))
    keymap.set('n', '<space>wr', vim.lsp.buf.remove_workspace_folder, desc('lsp: [w]orkspace folder [r]emove'))
    keymap.set('n', '<space>wl', function()
      -- TODO: Replace this with a Telescope extension?
      vim.print(vim.lsp.buf.list_workspace_folders())
    end, desc('lsp: [w]orkspace folders [l]'))
    keymap.set('n', '<space>rn', function()
      -- vim.lsp.buf.rename()
      require('live-rename').rename()
    end, desc('lsp: [r]e[n]ame'))
    keymap.set('n', '<space>ri', function()
      require('live-rename').rename { text = '', insert = true }
    end, desc('lsp: [r]ename ([i]nsert mode)'))
    keymap.set('n', '<space>wq', vim.lsp.buf.workspace_symbol, desc('lsp: [w]orkspace symbol [q]uery'))
    keymap.set('n', '<space>dd', vim.lsp.buf.document_symbol, desc('lsp: [dd]ocument symbol'))
    keymap.set('n', '<space>df', document_functions, desc('lsp: [d]ocument [f]unctions'))
    keymap.set('n', '<space>ds', document_structs, desc('lsp: [d]ocument [s]tructs'))
    keymap.set('n', '<space>di', document_modules, desc('lsp: [d]ocument modules/[i]mports'))
    if client.name == 'rust-analyzer' then
      keymap.set('n', '<M-CR>', function()
        vim.cmd.RustLsp('codeAction')
      end, desc('rust: code action'))
    else
      keymap.set('n', '<M-CR>', code_action, desc('lsp: code action'))
    end
    keymap.set('n', '<M-l>', vim.lsp.codelens.run, desc('lsp: run code lens'))
    keymap.set('n', '<space>cr', vim.lsp.codelens.refresh, desc('lsp: refresh [c]ode [l]enses'))

    local codelens = require('mrcjk.lsp.codelens')
    keymap.set('n', '[l', codelens.goto_prev, desc('lsp: previous code[l]ens'))
    keymap.set('n', ']l', codelens.goto_next, desc('lsp: next code[l]ens'))
    keymap.set('n', 'gr', vim.lsp.buf.references, desc('lsp: [g]et [r]eferences'))
    keymap.set({ 'n', 'v' }, '<space>f', function()
      vim.lsp.buf.format { async = true }
    end, desc('lsp: [f]ormat buffer'))

    if client:supports_method(methods.textDocument_inlayHint) then
      keymap.set('n', '<space>h', function()
        local current_setting = vim.lsp.inlay_hint.is_enabled { bufnr = bufnr }
        vim.lsp.inlay_hint.enable(not current_setting, { bufnr = bufnr })
      end, desc('lsp: toggle inlay [h]ints'))
    end

    local group = api.nvim_create_augroup(string.format('lsp-%s-%s', bufnr, client.id), {})
    if client:supports_method(methods.codeLens_resolve) then
      vim.api.nvim_create_autocmd({ 'InsertLeave', 'BufEnter', 'CursorHold' }, {
        group = group,
        callback = function()
          vim.lsp.codelens.refresh { bufnr = bufnr }
        end,
        buffer = bufnr,
      })
      vim.lsp.codelens.refresh { bufnr = bufnr }
    end
    vim.api.nvim_create_autocmd('CompleteChanged', {
      buffer = bufnr,
      callback = function()
        local info = vim.fn.complete_info { 'selected' }
        local completionItem = vim.tbl_get(vim.v.completed_item, 'user_data', 'nvim', 'lsp', 'completion_item')
        if completionItem == nil then
          return
        end

        client:request(methods.completionItem_resolve, completionItem, function(err, result)
          if err ~= nil then
            vim.notify(vim.inspect(err), vim.log.levels.ERROR)
            return
          end
          local documentation = vim.tbl_get(result, 'documentation', 'value')
          if documentation == nil then
            vim.api.nvim__complete_set(info['selected'], { info = '' })
            return
          end
          local winData = vim.api.nvim__complete_set(info['selected'], { info = documentation })
          if winData.winid == nil then
            return
          end
          if not vim.api.nvim_win_is_valid(winData.winid) then
            return
          end
          vim.api.nvim_win_set_config(winData.winid, { border = 'rounded' })
          vim.bo[winData.bufnr].filetype = 'markdown'
          vim.treesitter.start(winData.bufnr, 'markdown')
          vim.wo[winData.winid].conceallevel = 3
        end, bufnr)
      end,
    })

    if client:supports_method(methods.textDocument_completion, bufnr) then
      vim.lsp.completion.enable(true, client.id, bufnr, { autotrigger = false })
    end
  end,
})

api.nvim_create_autocmd('LspDetach', {
  group = api.nvim_create_augroup('lsp-detach', {}),
  callback = function(args)
    local group = api.nvim_create_augroup(string.format('lsp-%s-%s', args.buf, args.data.client_id), {})
    pcall(api.nvim_del_augroup_by_name, group)
  end,
})

api.nvim_create_autocmd({ 'VimEnter', 'FocusGained', 'BufEnter' }, {
  group = api.nvim_create_augroup('ReloadFileOnChange', {}),
  command = 'checktime',
})
