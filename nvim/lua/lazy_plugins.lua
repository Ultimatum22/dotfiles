return {
    -- Colorscheme - must load before everything else
    {
        'maxmx03/solarized.nvim',
        lazy = false,
        priority = 1000,
        config = function() require('colorscheme') end,
    },

    -- UI / editing
    {
        'folke/which-key.nvim',
        config = function() require('whichkey') end,
    },
    {
        'lukas-reineke/indent-blankline.nvim',
        main = 'ibl',
        opts = { indent = { char = "│" } },
    },
    { 'tummetott/reticle.nvim', config = true },
    { 'kylechui/nvim-surround', config = true },
    { 'romainl/vim-cool' },
    { 'tpope/vim-fugitive' },
    { 'towolf/vim-helm', ft = 'helm' },

    -- Git
    { 'lewis6991/gitsigns.nvim', config = true },

    -- File tree
    {
        'nvim-tree/nvim-tree.lua',
        config = function() require('tree') end,
    },

    -- Status bar
    {
        'nvim-lualine/lualine.nvim',
        dependencies = {
            -- yaml-companion is also a dep of the LSP spec below; lazy.nvim deduplicates
            { 'someone-stole-my-name/yaml-companion.nvim', dependencies = { 'nvim-lua/plenary.nvim' } },
        },
        config = function() require('statusbar') end,
    },

    -- Treesitter
    {
        'nvim-treesitter/nvim-treesitter',
        build = ':TSUpdate',
        dependencies = { 'nvim-treesitter/nvim-treesitter-textobjects' },
        config = function() require('treesitter') end,
    },

    -- Commit editor
    { 'rhysd/committia.vim', config = function() require('committia') end },

    -- LSP + completion
    {
        'VonHeikemen/lsp-zero.nvim',
        branch = 'v4.x',
        dependencies = {
            'neovim/nvim-lspconfig',
            'williamboman/mason.nvim',
            'williamboman/mason-lspconfig.nvim',
            'hrsh7th/nvim-cmp',
            'hrsh7th/cmp-nvim-lsp',
            'hrsh7th/cmp-buffer',
            'hrsh7th/cmp-path',
            { 'windwp/nvim-autopairs', config = true },
            'b0o/SchemaStore.nvim',
            { 'someone-stole-my-name/yaml-companion.nvim', dependencies = { 'nvim-lua/plenary.nvim' } },
            { 'DrKJeff16/project.nvim', config = function() require('project_nvim').setup({}) end },
        },
        config = function() require('lsp') end,
    },
}
