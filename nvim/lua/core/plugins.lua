local ensure_packer = function()
    local fn = vim.fn
    local install_path = fn.stdpath('data')..'/site/pack/packer/start/packer.nvim'
    if fn.empty(fn.glob(install_path)) > 0 then
      fn.system({'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim', install_path})
      vim.cmd [[packadd packer.nvim]]
      return true
    end
    return false
  end
  
  
  local packer_bootstrap = ensure_packer()
  
  return require('packer').startup(function(use)
    use 'wbthomason/packer.nvim'
    use 'ellisonleao/gruvbox.nvim'
    use 'nvim-tree/nvim-tree.lua'
    use 'nvim-tree/nvim-web-devicons'
    use 'nvim-lualine/lualine.nvim'
    use 'nvim-treesitter/nvim-treesitter'
    use 'hrsh7th/nvim-cmp'
    use 'hrsh7th/cmp-nvim-lsp'
    use 'L3MON4D3/LuaSnip'
    use 'saadparwaiz1/cmp_luasnip'
    use 'rafamadriz/friendly-snippets'
    use 'hrsh7th/nvim-compe' -- Autocompletion plugin
    use 'jiangmiao/auto-pairs' -- Automate pairings of parentheses and quotes
    use 'akinsho/flutter-tools.nvim' -- Tools to help create flutter apps. (Flutter SDK needs to be in your PATH)
    use 'dart-lang/dart-vim-plugin' -- Dart syntax and indentation support
    use({
    "kylechui/nvim-surround",
    tag = "*", -- Use for stability; omit to use `main` branch for the latest features
    config = function()
        require("nvim-surround").setup({
            -- Configuration here, or leave empty to use defaults
        })
    end
})
    use {'nvim-telescope/telescope.nvim',
    tag='0.1.0',
    requires= {{'nvim-lua/plenary.nvim'}}
  }
   use "yamatsum/nvim-cursorline"
    use {
  "williamboman/mason.nvim", 
  "williamboman/mason-lspconfig.nvim",
  "neovim/nvim-lspconfig",

    }
    -- Put this at the end after all plugins
    if packer_bootstrap then
      require('packer').sync()
    end
  end)
