return {
  'sindrets/diffview.nvim',
  cmd = { 'DiffviewOpen', 'DiffviewClose', 'DiffviewFileHistory' },
  keys = {
    { '<leader>gd', '<cmd>DiffviewOpen master...HEAD<cr>', desc = 'Diff branch vs master' },
    { '<leader>gq', '<cmd>DiffviewClose<cr>', desc = 'Close Diffview' },
  },
  opts = function()
    local actions = require 'diffview.actions'
    return {
      keymaps = {
        file_panel = {
          { 'n', '<leader>e', actions.focus_entry, { desc = 'Focus the file diff' } },
        },
        file_history_panel = {
          { 'n', '<leader>e', actions.focus_entry, { desc = 'Focus the file diff' } },
        },
      },
    }
  end,
}
