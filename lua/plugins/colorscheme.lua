return {
    --    {
    --        "catppuccin/nvim",
    --    },
    --    {
    --        "vim-airline/vim-airline",
    --    },
    --    {
    --        "vim-airline/vim-airline-themes",
    --    },
    --    {
    --        "whatsthatsmell/codesmell_dark.vim",
    --    },
    {
        "rafi/awesome-vim-colorschemes",
    },
    {
        "nyoom-engineering/oxocarbon.nvim",
        -- config = function()
        --     vim.opt.background = "dark"
        --     vim.cmd("colorscheme oxocarbon")
        --     vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
        --     vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" })
        --     vim.api.nvim_set_hl(0, "NormalNC", { bg = "none" })
        -- end,
    },
    {
        "folke/tokyonight.nvim",
        lazy = false,
        priority = 1000,
        opts = {},
        config = function()
            vim.cmd([[colorscheme tokyonight-night]])
        end,
    },
    {
        'ryanoasis/vim-devicons',
        config = function()
        end
    }
}
