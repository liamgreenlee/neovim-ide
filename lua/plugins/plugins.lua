
-- This file can be loaded by calling `lua require('plugins')` from your init.vim

-- Only required if you have packer configured as `opt`
local lsp_config = require('lsp.config')

function load_plugins()
  require('packer').startup({function(use)
  -- Packer can manage itself
  use 'wbthomason/packer.nvim'

  use {
    'hrsh7th/nvim-cmp',
    requires = {
      'hrsh7th/cmp-nvim-lsp',
      'hrsh7th/cmp-path',
      'hrsh7th/cmp-buffer',
      'saadparwaiz1/cmp_luasnip',
    },

    config = lsp_config.nvim_cmp
  }

  use({"L3MON4D3/LuaSnip"})
  use {
    'nvim-treesitter/nvim-treesitter',
    run = function() require('nvim-treesitter.install').update({ with_sync = true }) end,
  }
  use {
    'nvim-telescope/telescope.nvim', branch = '0.1.x',
  -- or                            , branch = '0.1.x',
    requires = { {'nvim-lua/plenary.nvim'} }
  }

  use {
    'nvim-tree/nvim-tree.lua',
    requires = {
      'nvim-tree/nvim-web-devicons', -- optional, for file icons
    },
    tag = 'nightly' -- optional, updated every week. (see issue #1193)
  }

  use {
    'romgrk/barbar.nvim',
    requires = {'kyazdani42/nvim-web-devicons'}
  }
  
  use { "ellisonleao/gruvbox.nvim" }

  use {"akinsho/toggleterm.nvim", tag = '*', config = function()
  	require("toggleterm").setup{
	  shell = "/bin/bash",
	  open_mapping = [[<c-\>]],
	}
  end}

  use {'lewis6991/gitsigns.nvim'}

  use {'Mofiqul/vscode.nvim'}

  -- using packer.nvim
  use {'akinsho/bufferline.nvim', tag = "v2.*", requires = 'kyazdani42/nvim-web-devicons'}

  use {"lukas-reineke/indent-blankline.nvim"}

  use {
    "williamboman/mason.nvim",
    "williamboman/mason-lspconfig.nvim",
    "neovim/nvim-lspconfig"
  }

  use { 'sindrets/diffview.nvim', requires = 'nvim-lua/plenary.nvim' }


  end,
  config = {
    display = {
      open_fn = require('packer.util').float,
    }
  }})

end

function load_config()
  local keymaps = require('core.keymaps')
  keymaps.load_telescope()
  keymaps.load_nvimtree()
  keymaps.load_barbar()
  keymaps.load_ui()
  keymaps.load_gitsigns()
  lsp_config.load_cmp()
end

local ensure_packer = function()
  local install_path = vim.fn.stdpath('data')..'/site/pack/packer/start/packer.nvim'
  if vim.fn.empty(vim.fn.glob(install_path)) > 0 then
    vim.fn.system({'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim', install_path})
    vim.cmd [[packadd packer.nvim]]
    load_plugins()
    require('packer').sync()
    local packer_group = vim.api.nvim_create_augroup('Packer', { clear = true })
    vim.api.nvim_create_autocmd(
      'User',
      { pattern = 'PackerComplete', callback = load_config, group = packer_group, once = true }
    )
  else
    load_plugins()
    require('packer').sync()
    load_config()
  end
end

ensure_packer()
