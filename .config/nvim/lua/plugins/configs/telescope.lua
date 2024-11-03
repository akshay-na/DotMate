-- lua/plugins/configs/telescope.lua

-- Define a module table to hold the configuration
local M = {}

-- Telescope options
M.opts = {
  defaults = {
    -- Specify patterns to ignore during search
    file_ignore_patterns = {
      "node_modules", -- Ignore node_modules for JavaScript/TypeScript
      "%.git/",       -- Ignore .git folder
      "venv/",        -- Ignore Python virtual environments
      "target/",      -- Ignore Rust target folder
      "build/",       -- Ignore build folders
      "dist/",        -- Ignore distribution folders
      "out/",         -- Ignore output folders
      "__pycache__/", -- Ignore Python cache
      "%.lock",       -- Ignore lock files like yarn.lock
      "tmp/",         -- Ignore temporary folders
      "%.DS_Store",   -- Ignore macOS system files
      "%.log",        -- Ignore log files
    },
    -- Enable preview and set sorting strategy
    sorting_strategy = "ascending", -- Places most relevant results first
    layout_strategy = "horizontal", -- Organize telescope layout horizontally
    layout_config = {
      preview_width = 0.5,          -- Sets preview window width
      horizontal = { mirror = false },
      vertical = { mirror = false },
    },
    -- Mapping for common actions to improve accessibility
    mappings = {
      i = {                                                               -- Insert mode mappings
        ["<C-u>"] = false,                                                -- Clear the prompt with Ctrl+u
        ["<C-d>"] = require('telescope.actions').delete_buffer,           -- Close buffer with Ctrl+d
      },
      n = {                                                               -- Normal mode mappings
        ["<C-q>"] = require('telescope.actions').send_selected_to_qflist, -- Send selected items to quickfix list
        ["<C-x>"] = require('telescope.actions').select_horizontal,       -- Open selection in horizontal split
      },
    },
  },
  pickers = {
    -- Set up default options for file and text search
    find_files = {
      hidden = true, -- Show hidden files (e.g., .gitignore)
    },
    live_grep = {
      only_sort_text = true, -- Faster sorting when searching text
    },
  },
}

-- Setup function to configure Telescope with the defined options
M.setup = function()
  require("telescope").setup(M.opts)
end

-- Return the module table
return M