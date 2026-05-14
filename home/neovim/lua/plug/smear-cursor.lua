vim.pack.add({
  "https://github.com/sphamba/smear-cursor.nvim",
})

require('smear_cursor').setup({
  -- Your options
  opts = {                                -- Default  Range
    stiffness = 0.9,                      -- 0.6      [0, 1]
    trailing_stiffness = 0.7,             -- 0.45     [0, 1]
    stiffness_insert_mode = 0.8,          -- 0.5      [0, 1]
    trailing_stiffness_insert_mode = 0.8, -- 0.5      [0, 1]
    damping = 0.99,                       -- 0.85     [0, 1]
    damping_insert_mode = 0.99,           -- 0.9      [0, 1]
    distance_stop_animating = 0.9,        -- 0.1      > 0
    time_interval = 7, -- milliseconds
  },
})
