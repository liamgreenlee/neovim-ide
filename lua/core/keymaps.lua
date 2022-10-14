local keymaps = {}

function keymaps.load_gitsigns()
  require('gitsigns').setup {
    signcolumn = true,  -- Toggle with `:Gitsigns toggle_signs`
    numhl      = true, -- Toggle with `:Gitsigns toggle_numhl`
    current_line_blame = true, -- Toggle with `:Gitsigns toggle_current_line_blame`
    current_line_blame_opts = {
      delay = 100,
    },
  }
end

function keymaps.load_ui()
  vim.o.number = true
  vim.o.background = "dark" -- or "light" for light mode
  local c = require('vscode.colors')
  require('vscode').setup({
    -- Enable transparent background

    -- Enable italic comment
    italic_comments = true,

    -- Disable nvim-tree background color
    disable_nvimtree_bg = true,

    -- Override colors (see ./lua/vscode/colors.lua)
 --   color_overrides = {
 --       vscLineNumber = '#FFFFFF',
 --   },

    -- Override highlight groups (see ./lua/vscode/theme.lua)
    group_overrides = {
        -- this supports the same val table as vim.api.nvim_set_hl
        -- use colors from this colorscheme by requiring vscode.colors!
        Cursor = { fg=c.vscDarkBlue, bg=c.vscLightGreen, bold=true },
    }
  })

  vim.opt.list = true
  vim.opt.listchars:append "space:⋅"
  require('indent_blankline').setup{
    space_char_blankline = " "
  }

end

function keymaps.load_telescope()
    local builtin = require('telescope.builtin')
    vim.keymap.set('n', 'ff', builtin.find_files, {})
    vim.keymap.set('n', 'fg', builtin.live_grep, {})
    vim.keymap.set('n', 'fb', builtin.buffers, {})
    vim.keymap.set('n', 'fh', builtin.help_tags, {})
end

function keymaps.load_nvimtree()
    -- examples for your init.lua

    -- disable netrw at the very start of your init.lua (strongly advised)
    vim.g.loaded = 1
    vim.g.loaded_netrwPlugin = 1

    -- OR setup with some options
    require("nvim-tree").setup({
    sort_by = "case_sensitive",
    open_on_setup = true,
    open_on_tab = true,
    view = {
        adaptive_size = true,
        mappings = {
        list = {
          { key = "u", action = "dir_up" },
        },
        },
    },
    renderer = {
        group_empty = true,
    },
    filters = {
        dotfiles = true,
    },
    })
end

function keymaps.load_barbar()
    local map = vim.api.nvim_set_keymap
    local opts = { noremap = true, silent = true }
    
    -- Move to previous/next
    map('n', '<A-,>', '<Cmd>BufferPrevious<CR>', opts)
    map('n', '<A-.>', '<Cmd>BufferNext<CR>', opts)
    -- Re-order to previous/next
    map('n', '<A-<>', '<Cmd>BufferMovePrevious<CR>', opts)
    map('n', '<A->>', '<Cmd>BufferMoveNext<CR>', opts)
    -- Goto buffer in position...
    map('n', '<A-1>', '<Cmd>BufferGoto 1<CR>', opts)
    map('n', '<A-2>', '<Cmd>BufferGoto 2<CR>', opts)
    map('n', '<A-3>', '<Cmd>BufferGoto 3<CR>', opts)
    map('n', '<A-4>', '<Cmd>BufferGoto 4<CR>', opts)
    map('n', '<A-5>', '<Cmd>BufferGoto 5<CR>', opts)
    map('n', '<A-6>', '<Cmd>BufferGoto 6<CR>', opts)
    map('n', '<A-7>', '<Cmd>BufferGoto 7<CR>', opts)
    map('n', '<A-8>', '<Cmd>BufferGoto 8<CR>', opts)
    map('n', '<A-9>', '<Cmd>BufferGoto 9<CR>', opts)
    map('n', '<A-0>', '<Cmd>BufferLast<CR>', opts)
    -- Pin/unpin buffer
    map('n', '<A-p>', '<Cmd>BufferPin<CR>', opts)
    -- Close buffer
    map('n', '<A-c>', '<Cmd>BufferClose<CR>', opts)
    -- Wipeout buffer
    --                 :BufferWipeout
    -- Close commands
    --                 :BufferCloseAllButCurrent
    --                 :BufferCloseAllButPinned
    --                 :BufferCloseAllButCurrentOrPinned
    --                 :BufferCloseBuffersLeft
    --                 :BufferCloseBuffersRight
    -- Magic buffer-picking mode
    map('n', '<C-p>', '<Cmd>BufferPick<CR>', opts)
    -- Sort automatically by...
    map('n', '<Space>bb', '<Cmd>BufferOrderByBufferNumber<CR>', opts)
    map('n', '<Space>bd', '<Cmd>BufferOrderByDirectory<CR>', opts)
    map('n', '<Space>bl', '<Cmd>BufferOrderByLanguage<CR>', opts)
    map('n', '<Space>bw', '<Cmd>BufferOrderByWindowNumber<CR>', opts)
    
    -- Other:
    -- :BarbarEnable - enables barbar (enabled by default)
    -- :BarbarDisable - very bad command, should never be used
    local nvim_tree_events = require('nvim-tree.events')
    local bufferline_api = require('bufferline.api')
    
    local function get_tree_size()
      return require'nvim-tree.view'.View.width
    end
    
    nvim_tree_events.subscribe('TreeOpen', function()
      bufferline_api.set_offset(get_tree_size())
    end)
    
    nvim_tree_events.subscribe('Resize', function()
      bufferline_api.set_offset(get_tree_size())
    end)
    
    nvim_tree_events.subscribe('TreeClose', function()
      bufferline_api.set_offset(0)
    end)
end

return keymaps
