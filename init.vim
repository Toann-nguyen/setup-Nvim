" Competitive Programming Neovim Configuration

" Disable compatibility with vi
set nocompatible
set clipboard=unnamedplus
set cursorline
set termguicolors   
" Disable compatibility with vi
set nocompatible

" Enhanced Clipboard Configuration
set clipboard=unnamedplus

" Alternative clipboard settings for better compatibility
if has('unnamedplus')
  set clipboard=unnamed,unnamedplus
else
  set clipboard=unnamed
endif
" Plugins (using vim-plug)
call plug#begin('~/.config/nvim/plugged')
" Ensure proper clipboard functionality
if has('nvim')
  let g:clipboard = {
    \   'name': 'system',
    \   'copy': {
    \      '+': 'xclip -selection clipboard',
    \      '*': 'xclip -selection primary',
    \    },
    \   'paste': {
    \      '+': 'xclip -selection clipboard -o',
    \      '*': 'xclip -selection primary -o',
    \   },
    \   'cache_enabled': 1,
    \ }
endif
" Plugins (using vim-plug)
call plug#begin('~/.config/nvim/plugged')

" Competitive Programming Plugins
Plug 'xeluxee/competitest.nvim'
Plug 'MunifTanjim/nui.nvim'

" LSP and Completion
Plug 'neovim/nvim-lspconfig'
Plug 'hrsh7th/nvim-cmp'
Plug 'hrsh7th/cmp-nvim-lsp'
Plug 'hrsh7th/cmp-buffer'
Plug 'williamboman/mason.nvim'
Plug 'williamboman/mason-lspconfig.nvim'

" Snippet Support
Plug 'L3MON4D3/LuaSnip'
Plug 'saadparwaiz1/cmp_luasnip'

" Syntax Highlighting
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}

" Fuzzy Finder
Plug 'nvim-telescope/telescope.nvim'
Plug 'nvim-lua/plenary.nvim'

" Colorscheme
Plug 'folke/tokyonight.nvim', { 'as': 'tokyonight' }

call plug#end()

" Basic Configuration
set number
set relativenumber
set tabstop=2
set shiftwidth=2
set expandtab
set smartindent

" Leader Key
let mapleader = " "

" Enhanced Clipboard Keymaps
" Copy to system clipboard
vnoremap <C-c> "+y
nnoremap <C-c> "+yy
" Paste from system clipboard
nnoremap <C-v> "+p
vnoremap <C-v> "+p
inoremap <C-v> <C-r>+

" Copy entire buffer to clipboard
nnoremap <leader>ca ggVG"+y

" Competitive Programming Keymaps
nnoremap <leader>rr :w<CR>:CompetitestRunNormal<CR>
nnoremap <leader>rt :CompetitestRunTest<CR>
nnoremap <leader>rc :CompetitestConfig<CR>

" Color Scheme (with fallback)
try
  colorscheme tokyonight
catch
  colorscheme default
endtry
" Competitive Programming Template Command
command! CPTemplate call SetCPTemplate()

function! SetCPTemplate()
 let template = [
  \ "#include <bits/stdc++.h>",
  \ "using namespace std;",
  \ "",
  \ "#define int long long",
  \ "#define MOD 1000000007",
  \ "#define MAX 1e6",
  \ "#define pb push_back",
   \ "#define mp make_pair",
    \ "#define fi first",
    \ "#define se second",
    \ "#define all(x) (x).begin(), (x).end()",
    \ "#define rall(x) (x).rbegin(), (x).rend()",
  \ "",
  \ "void solve() {",
  \ "  ",
  \ "}",
  \ "",
  \ "int32_t main() {",
  \ "    ios_base::sync_with_stdio(false);",
   \ "    cin.tie(NULL);",
  \ "   int t = 1;",
  \ "   cin >> t;",
  \ "   while (t--) {",
  \ "     solve();",
  \ "   }",
  \ "  return 0;",
  \ "}
  \"]
  " Insert the template at the beginning of the file (line 0)
  call append(0, template)
endfunction
" Keymap to trigger the template insertion
nmap <leader>cc :call InsertCppTemplate()<CR>
" Set C++ file type
autocmd BufNewFile,BufRead *.cpp set filetype=cpp
 
" Compile and run C++ program in subshell
function! CompileAndRun()
  let fileName = expand('%')
  if fileName =~ '\.cpp$'
    let exeName = substitute(fileName, '\.cpp$', '', '')
    execute 'w | !g++ -std=c++11 -Wall -Wextra -Wpedantic -O2 -o ' . exeName . ' ' . fileName
    if v:shell_error == 0
      let cmd = "x-terminal-emulator -e bash -c './" . exeName . "; read -p \"Press enter to exit...\"'"
      call system(cmd)
      redraw!
    endif
  else
    echo 'Not a C++ file'
  endif
endfunction
 
" Map keys to compile and run current file
map <F5> :call CompileAndRun()<CR>
map <F9> :w<CR>:!clear<CR>:call CompileAndRun()<CR>

" Auto-command to insert the template into new .cpp files
augroup CPPTemplate
    autocmd!
    autocmd BufNewFile *.cpp call SetCPTemplate()
augroup END

" Advanced C++ Specific Settings
augroup cpp_settings
  autocmd!
  " Auto-format on save using clang-format
  autocmd BufWritePre *.cpp,*.h silent! execute '!clang-format -i ' . expand('%')
augroup END

" Ensure the Lua environment is ready for other setups (LSP, Completion, etc.)
lua << EOF
-- Protect against errors
pcall(function()
  -- LSP Configuration
  local lspconfig = require('lspconfig')
  local mason = require('mason')
  local mason_lspconfig = require('mason-lspconfig')

  -- Configure Mason
  mason.setup()
  mason_lspconfig.setup {
    ensure_installed = { 'clangd' }
  }

  -- Setup LSP for C++
  lspconfig.clangd.setup{}

  -- Completion Setup
  local cmp = require('cmp')
  local luasnip = require('luasnip')

  cmp.setup({
    snippet = {
      expand = function(args)
        luasnip.lsp_expand(args.body)
      end,
    },
    mapping = cmp.mapping.preset.insert({
      ['<C-b>'] = cmp.mapping.scroll_docs(-4),
      ['<C-f>'] = cmp.mapping.scroll_docs(4),
      ['<C-Space>'] = cmp.mapping.complete(),
      ['<C-e>'] = cmp.mapping.abort(),
      ['<CR>'] = cmp.mapping.confirm({ select = true }),
    }),
    sources = cmp.config.sources({
      { name = 'nvim_lsp' },
      { name = 'luasnip' },
    }, {
      { name = 'buffer' },
    })
  })

  -- Competitive Test Configuration
  require('competitest').setup({
    runner_runs_as_module = true,
    runner_compiler = "g++",
    runner_compiler_args = {
      "-std=c++17",
      "-O2",
      "-Wall"
    }
  })
end)
EOF
