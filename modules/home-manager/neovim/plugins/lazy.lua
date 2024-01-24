require("lazy").setup({
	"tpope/vim-ragtag",
	"neovim/nvim-lspconfig",
	{
		"numToStr/Comment.nvim",
		lazy = false,
	},
	"ellisonleao/gruvbox.nvim",
	"folke/neodev.nvim",
	{
	    "hrsh7th/nvim-cmp",
	    lazy = false,
	},
	{
		"nvim-telescope/telescope.nvim",
		dependencies = { 'nvim-lua/plenary.nvim' }
	},
	{ 
		'nvim-telescope/telescope-fzf-native.nvim', 
		build = 'cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release && cmake --install build --prefix build' 
	},
	"saadparwaiz1/cmp_luasnip",
	"hrsh7th/cmp-nvim-lsp",
	"L3MON4D3/LuaSnip",
	{ 
		"rafamadriz/friendly-snippets"
	},
	'nvim-lualine/lualine.nvim',
	'nvim-tree/nvim-web-devicons',
	'LnL7/vim-nix',
	'nvim-tree/nvim-tree.lua',
	'folke/which-key.nvim',
	'NvChad/nvim-colorizer.lua',
	'lewis6991/gitsigns.nvim',
	'windwp/nvim-autopairs',
	"williamboman/mason.nvim",
	"williamboman/mason-lspconfig.nvim",
	{'VonHeikemen/lsp-zero.nvim', branch = 'v3.x'},
	"luukvbaal/statuscol.nvim",
	{
		"github/copilot.vim",
	},
	{
		"iamcco/markdown-preview.nvim",
		cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
		ft = { "markdown" },
		build = function() vim.fn["mkdp#util#install"]() end,
	},
})

-- Gruvbox (Colorscheme)
require("gruvbox").setup({
	terminal_colors = true,
	undercurl = true,
	underline = true,
	bold = true,
	italic = {
		strings = true,
		emphasis = true,
		comments = true,
		operators = false,
		folds = true,
	},
})
vim.cmd("colorscheme gruvbox")

-- Comment (fold comment shortcuts)
require("Comment").setup({
	padding = true,
})
-- gcc (toggles current line using linewise comment)
-- gbc (toggles current line using blockwise comment)
-- [count]gcc
-- [count]gbc

-- nvim-tree (file tree explorer)
require("nvim-tree").setup()

-- CMP (autocomplete/hints)
local cmp = require('cmp')
cmp.setup({
    snippet = {
	-- REQUIRED - you must specify a snippet engine
	expand = function(args)
	    -- vim.fn["vsnip#anonymous"](args.body) -- For `vsnip` users.
	    require('cmp_luasnip').lsp_expand(args.body) -- For `luasnip` users.
	    -- require('snippy').expand_snippet(args.body) -- For `snippy` users.
	    -- vim.fn["UltiSnips#Anon"](args.body) -- For `ultisnips` users.
	end,
    },
    window = {
      completion = cmp.config.window.bordered(),
      documentation = cmp.config.window.bordered(),
    },
	mapping = cmp.mapping.preset.insert({
      ['<C-b>'] = cmp.mapping.scroll_docs(-4),
      ['<C-f>'] = cmp.mapping.scroll_docs(4),
      ['<C-Space>'] = cmp.mapping.complete(),
      ['<C-e>'] = cmp.mapping.abort(),
      ['<CR>'] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
    ['<C-Bslash>'] = cmp.mapping(function(fallback)
      vim.api.nvim_feedkeys(vim.fn['copilot#Accept'](vim.api.nvim_replace_termcodes('<Tab>', true, true, true)), 'n', true)
    end)
    }),
    sources = cmp.config.sources({
      { name = 'nvim_lsp' },
      -- { name = 'vsnip' }, -- For vsnip users.
      { name = 'luasnip' }, -- For luasnip users.
      -- { name = 'ultisnips' }, -- For ultisnips users.
      -- { name = 'snippy' }, -- For snippy users.
    }, 
    {
      { 
		  name = 'buffer' 
	  },
    })
})

-- Language Servers
-- local lspconfig = require('lspconfig')
-- lspconfig.pyright.setup {}
-- lspconfig.tsserver.setup {}
-- lspconfig.rust_analyzer.setup {
--   -- Server-specific settings. See `:help lspconfig-setup`
--   settings = {
--     ['rust-analyzer'] = {},
--   },
-- }
-- Global mappings.
-- See `:help vim.diagnostic.*` for documentation on any of the below functions
vim.keymap.set('n', '<space>e', vim.diagnostic.open_float)
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev)
vim.keymap.set('n', ']d', vim.diagnostic.goto_next)
vim.keymap.set('n', '<space>q', vim.diagnostic.setloclist)
-- Use LspAttach autocommand to only map the following keys
-- after the language server attaches to the current buffer
-- vim.api.nvim_create_autocmd('LspAttach', {
--   group = vim.api.nvim_create_augroup('UserLspConfig', {}),
--   callback = function(ev)
--     -- Enable completion triggered by <c-x><c-o>
--     vim.bo[ev.buf].omnifunc = 'v:lua.vim.lsp.omnifunc'
-- ripgrep
--     -- Buffer local mappings.
--     -- See `:help vim.lsp.*` for documentation on any of the below functions
--     local opts = { buffer = ev.buf }
--     vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, opts)
--     vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
--     vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
--     vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, opts)
--     vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, opts)
--     vim.keymap.set('n', '<space>wa', vim.lsp.buf.add_workspace_folder, opts)
--     vim.keymap.set('n', '<space>wr', vim.lsp.buf.remove_workspace_folder, opts)
--     vim.keymap.set('n', '<space>wl', function()
--       print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
--     end, opts)
--     vim.keymap.set('n', '<space>D', vim.lsp.buf.type_definition, opts)
--     vim.keymap.set('n', '<space>rn', vim.lsp.buf.rename, opts)
--     vim.keymap.set({ 'n', 'v' }, '<space>ca', vim.lsp.buf.code_action, opts)
--     vim.keymap.set('n', 'gr', vim.lsp.buf.references, opts)
--     vim.keymap.set('n', '<space>f', function()
--       vim.lsp.buf.format { async = true }
--     end, opts)
--   end,
-- })


-- lsp-zero
local lsp_zero = require('lsp-zero')
-- Set up default keybindings.
lsp_zero.on_attach(function(client, bufnr)
  -- see :help lsp-zero-keybindings
  -- to learn the available actions
  lsp_zero.default_keymaps({buffer = bufnr})
end)

--require'lspconfig'.marksman.setup{}

-- Mason
require("mason").setup()
require("mason-lspconfig").setup({
	PATH = "prepend",
    ensure_installed = {
        "lua_ls", 
        "clangd",
        "marksman",
        "nil_ls",
        "jedi_language_server",
        "svelte",
        "taplo",
        "yamlls",
        "bashls",
		"tsserver",
		"pyright",
    },
	handlers = {
		lsp_zero.default_setup,
	},
	automatic_installation = {
		exclude = {
			"r_language_server",
			"marksman",
		}
	}, 
})

-- Telescope
local builtin = require('telescope.builtin')
vim.keymap.set('n', '<leader>ff', builtin.find_files, {})
vim.keymap.set('n', '<leader>fg', builtin.live_grep, {})
vim.keymap.set('n', '<leader>fb', builtin.buffers, {})
vim.keymap.set('n', '<leader>fh', builtin.help_tags, {})

-- Copilot
-- Accept the current suggestion with ctrl backslash
-- vim.keymap.set('i', '<C-Bslash>', 'copilot#Accept()', {expr = true, noremap = true})
vim.g.copilot_no_tab_map = true
vim.keymap.set(
    "i",
    "<Plug>(vimrc:copilot-dummy-map)",
    'copilot#Accept("")',
    { silent = true, expr = true, desc = "Copilot dummy accept" }
)
