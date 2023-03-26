-- Overrides to disable deprecation warnings
vim.treesitter.query.get_query_files = vim.treesitter.query.get_files
vim.treesitter.query.get_query = vim.treesitter.query.get
vim.treesitter.query.parse_query = vim.treesitter.query.parse
vim.treesitter.query.set_query = vim.treesitter.query.set
vim.treesitter.query.get_range = vim.treesitter.get_range
vim.treesitter.query.get_node_text = vim.treesitter.get_node_text
