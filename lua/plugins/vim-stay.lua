return {
  "zhimsel/vim-stay",
  event = "BufReadPost",
  config = function()
    -- Basic fold settings
    vim.opt.foldmethod = "manual"
    vim.opt.foldlevel = 99

    -- Enable vim-stay fold persistence
    vim.g.stay_save_folds = 1
  end,
}
