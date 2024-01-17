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
	}
	"nvim-telescope/telescope.nvim",
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
})

-- Gruvbox
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

-- Comment
require("Comment").setup({
	padding = true,
})
-- gcc (toggles current line using linewise comment)
-- gbc (toggles current line using blockwise comment)
-- [count]gcc
-- [count]gbc

-- CMP
require('nvim-cmp').setup({
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
    }),
    sources = cmp.config.sources({
      { name = 'nvim_lsp' },
      -- { name = 'vsnip' }, -- For vsnip users.
      --{ name = 'luasnip' }, -- For luasnip users.
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
local lspconfig = require('lspconfig')
-- Mason
require("mason").setup()
require("mason-lspconfig").setup({
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
    },
})
