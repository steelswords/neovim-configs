" Setup instructions:
" Decide if you're using coc or YouCompleteMe
" Land on Coc instead for one 
" For Coc:
" Run curl -sL install-node.vercel.app/lts | bash
" Coc: Run CocInstall coc-pyright coc-word
" Install 'silversearcher-ag'
" Install https://github.com/BurntSushi/ripgrep


set nocompatible              " be iMproved, required
filetype off                  " required

" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
call plug#begin()
" alternatively, pass a path where Vundle should install plugins
"call vundle#begin('~/some/path/here')

" let Vundle manage Vundle, required
Plug 'VundleVim/Vundle.vim'
" YouCompleteMe
" Plugin 'https://github.com/ycm-core/YouCompleteMe.git'
" For PlantUML previewer
"Plugin 'https://github.com/aklt/plantuml-syntax.git'
Plug 'https://github.com/weirongxu/plantuml-previewer.vim.git'
Plug 'tomasiser/vim-code-dark'
Plug 'derekwyatt/vim-fswitch'
" For quick comments
Plug 'https://github.com/tpope/vim-commentary'

" Telescope is only for neovim, unfortunately.
if has('nvim')
  Plug 'nvim-lua/plenary.nvim'
  Plug 'nvim-telescope/telescope.nvim'
endif

" UltiSnips
Plug 'https://github.com/sirver/UltiSnips'
Plug 'majutsushi/tagbar'
Plug 'iamcco/markdown-preview.nvim'
"Plugin 'https://github.com/peterhoeg/vim-qml.git'
" Run this after installing markdown preview:
" :source %
" :PluginInstall
" :call mkdp#util#install()

" Python stuff
" Plugin 'neovim/nvim-lspconfig'
"Plugin 'neoclide/coc.nvim'

" More fun plugins
Plug 'kyazdani42/nvim-web-devicons' " optional, for file icons
Plug 'kyazdani42/nvim-tree.lua'

Plug 'crucerucalin/qml.vim'
"Plug 'neoclide/coc.nvim.git'
Plug 'neoclide/coc.nvim', {'branch': 'release'}


" All of your Plugins must be added before the following line
call plug#end()              " required
filetype plugin indent on    " required
" To ignore plugin indent changes, instead use:
"filetype plugin on
" Put your non-Plugin stuff after this line

nmap <Leader>n <ESC>:NvimTreeToggle<cr>

let g:ycm_show_diagnostics_ui = 0
set colorcolumn=81
highlight ColorColumn ctermbg=0

set runtimepath^=~/.vim/plugins/swap_lines.vim

" Vivint and others like to have the headers and source files in separate
" directories. Do I care for this system? No. But it's driving me nuts that I
" can't seem to switch easily. So this configuration is for fswitch.
au! BufEnter *.cpp let b:fswitchdst = 'hpp,h' | let b:fswitchlocs = '../inc'
au! BufEnter *.h*  let b:fswitchdst = 'cpp,c' | let b:fswitchlocs = '../src'

" Enable hybrid numbers
set nu rnu
set smarttab

syntax on
"Original tab behavior:
"set tabstop=2
"set softtabstop=0 expandtab smarttab
"set shiftwidth=2
"Fixed tab behavior:
set tabstop=4
set softtabstop=0 noexpandtab 

set autoindent

"Set tabs=2spaces for Cpp files
"
filetype plugin indent on
"autocmd FileType cpp setlocal shiftwidth=2 softtabstop=2 expandtab
"autocmd FileType c   setlocal shiftwidth=2 softtabstop=2 expandtab

"Shiftwidth is the size of an 'indent', measured in spaces.
set shiftwidth=4
set expandtab
"set listchars=eol:⏎,tab:␉·,trail:␠,nbsp:⎵,extends:→,precedes:←
set listchars=tab:>·,trail:␠,nbsp:⎵,extends:→,precedes:←
set list

set statusline+=%F

"Forces vim to use tags files from parent directories too.
"<rant> Should be the default, but ok. </rant>
set tags=tags;

filetype plugin on

"Enable * to highlight search word and define F11 to turn it off
set hls
nnoremap <S-F11> <ESC>:set hls! hls?<cr>
inoremap <S-F11> <C-o>:set hls! hls?<cr>
vnoremap <S-F11> <ESC>:set hls! hls?<cr> <bar> gv

"Enable sudo-on-the-fly
command IamtheKING w !sudo tee %

"cmap w!! w !sudo tee %

set t_Co=256
set t_ut=
colorscheme codedark

autocmd FileType xml        setlocal tabstop=4 shiftwidth=4 softtabstop=4

"Press \g to see a git blame of something selected in visual mode
vmap <Leader>g :<C-U>!git blame <C-R>=expand("%:p") <CR> \| sed -n <C-R>=line("'<") <CR>,<C-R>=line("'>") <CR>p <CR>

" YouCompleteMe options
let g:ycm_auto_hover = ''

" PlantUML Previewer options
"let g:plantuml_previewer#plantuml_jar_path = '/home/tandrus/Applications/plantuml.jar'

" Enable this to enable mouse scrolling and selecting in tmux
" Spoiler: Not worth it
" set mouse=a

" To use: install silversearcher's ag
" The Silver Searcher
if executable('ag')
  " Use ag over grep
  set grepprg=ag\ --nogroup\ --nocolor

  " Use ag in CtrlP for listing files. Lightning fast and respects .gitignore
  let g:ctrlp_user_command = 'ag %s -l --nocolor -g ""'

  " ag is fast enough that CtrlP doesn't need to cache
  let g:ctrlp_use_caching = 0
endif

" bind K to grep word under cursor
"nnoremap K :grep! "\b<C-R><C-W>\b"<CR>:cw<CR>

" Bind Ctrl-H to switch between header and cpp
nnoremap <silent> <C-h> :FSHere<CR>

" Bind Ctrl-R to replace the highlighted text in visual mode
vnoremap <C-r> "hy:%s/<C-r>h//gc<left><left><left>

" NeoVim-specific bindings.
" Telescope bindings
if has('nvim')
  nnoremap <leader>ff <cmd>Telescope find_files<cr>
  nnoremap <leader>fg <cmd>Telescope live_grep<cr>
  nnoremap <leader>fb <cmd>Telescope buffers<cr>
  nnoremap <leader>fh <cmd>Telescope help_tags<cr>
  nnoremap <leader>vg <cmd>Telescope grep_string<cr>
endif

"UltiSnips bind to c-j
"let g:UltiSnipsExpandTrigger = "<M-x>"
let g:UltiSnipsExpandTrigger = "<C-j>"
"let g:UltiSnipsJumpForwardTrigger = "<M-j>"
"let g:UltiSnipsJumpBackwardTrigger = "<M-k>"

" Coc settings
let g:coc_global_extensions = ['coc-json', 'coc-sh', 'coc-git', 'coc-cmake', 'coc-docker', 'coc-go', 'coc-jedi', 'coc-rust-analyzer']
set signcolumn=yes
" Use tab for trigger completion with characters ahead and 
" Use tab for trigger completion with characters ahead and navigate.
" NOTE: Use command ':verbose imap <tab>' to make sure tab is not mapped by
" NOTE: There's always complete item selected by default, you may want to enable
" no select by `"suggest.noselect": true` in your configuration file.
" other plugin before putting this into your config.
inoremap <silent><expr> <TAB>
      \ coc#pum#visible() ? coc#pum#next(1):
      \ CheckBackspace() ? "\<Tab>" :
      \ coc#refresh()
inoremap <expr><S-TAB> coc#pum#visible() ? coc#pum#prev(1) : "\<C-h>"

" Make <CR> to accept selected completion item or notify coc.nvim to format
" <C-g>u breaks current undo, please make your own choice.
inoremap <silent><expr> <CR> coc#pum#visible() ? coc#pum#confirm()
                              \: "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"

function! CheckBackspace() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

" Use <c-space> to trigger completion.
if has('nvim')
  inoremap <silent><expr> <c-space> coc#refresh()
else
  inoremap <silent><expr> <c-@> coc#refresh()
endif

" Use `[g` and `]g` to navigate diagnostics
" Use `:CocDiagnostics` to get all diagnostics of current buffer in location list.
nmap <silent> [g <Plug>(coc-diagnostic-prev)
nmap <silent> ]g <Plug>(coc-diagnostic-next)

" GoTo code navigation.
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)

" Use K to show documentation in preview window.
nnoremap <silent> K :call ShowDocumentation()<CR>

function! ShowDocumentation()
  if CocAction('hasProvider', 'hover')
    call CocActionAsync('doHover')
  else
    call feedkeys('K', 'in')
  endif
endfunction

" Highlight the symbol and its references when holding the cursor.
autocmd CursorHold * silent call CocActionAsync('highlight')

" Symbol renaming.
nmap <leader>rn <Plug>(coc-rename)

" Formatting selected code.
xmap <leader>f  <Plug>(coc-format-selected)
nmap <leader>f  <Plug>(coc-format-selected)

augroup mygroup
  autocmd!
  " Setup formatexpr specified filetype(s).
  autocmd FileType typescript,json setl formatexpr=CocAction('formatSelected')
  " Update signature help on jump placeholder.
  autocmd User CocJumpPlaceholder call CocActionAsync('showSignatureHelp')
augroup end

" Applying codeAction to the selected region.
" Example: `<leader>aap` for current paragraph
xmap <leader>a  <Plug>(coc-codeaction-selected)
nmap <leader>a  <Plug>(coc-codeaction-selected)

" Remap keys for applying codeAction to the current buffer.
nmap <leader>ac  <Plug>(coc-codeaction)
" Apply AutoFix to problem on the current line.
nmap <leader>qf  <Plug>(coc-fix-current)

" Run the Code Lens action on the current line.
nmap <leader>cl  <Plug>(coc-codelens-action)

" Map function and class text objects
" NOTE: Requires 'textDocument.documentSymbol' support from the language server.
xmap if <Plug>(coc-funcobj-i)
omap if <Plug>(coc-funcobj-i)
xmap af <Plug>(coc-funcobj-a)
omap af <Plug>(coc-funcobj-a)
xmap ic <Plug>(coc-classobj-i)
omap ic <Plug>(coc-classobj-i)
xmap ac <Plug>(coc-classobj-a)
omap ac <Plug>(coc-classobj-a)

" Remap <C-f> and <C-b> for scroll float windows/popups.
if has('nvim-0.4.0') || has('patch-8.2.0750')
  nnoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? coc#float#scroll(1) : "\<C-f>"
  nnoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? coc#float#scroll(0) : "\<C-b>"
  inoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(1)\<cr>" : "\<Right>"
  inoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(0)\<cr>" : "\<Left>"
  vnoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? coc#float#scroll(1) : "\<C-f>"
  vnoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? coc#float#scroll(0) : "\<C-b>"
endif

" Use CTRL-S for selections ranges.
" Requires 'textDocument/selectionRange' support of language server.
nmap <silent> <C-s> <Plug>(coc-range-select)
xmap <silent> <C-s> <Plug>(coc-range-select)

" Add `:Format` command to format current buffer.
command! -nargs=0 Format :call CocActionAsync('format')

" Add `:Fold` command to fold current buffer.
command! -nargs=? Fold :call     CocAction('fold', <f-args>)

" Add `:OR` command for organize imports of the current buffer.
command! -nargs=0 OR   :call     CocActionAsync('runCommand', 'editor.action.organizeImport')

" Add (Neo)Vim's native statusline support.
" NOTE: Please see `:h coc-status` for integrations with external plugins that
" provide custom statusline: lightline.vim, vim-airline.
set statusline^=%{coc#status()}%{get(b:,'coc_current_function','')}

" Mappings for CoCList
" Show all diagnostics.
nnoremap <silent><nowait> <space>a  :<C-u>CocList diagnostics<cr>
" Manage extensions.
nnoremap <silent><nowait> <space>e  :<C-u>CocList extensions<cr>
" Show commands.
nnoremap <silent><nowait> <space>c  :<C-u>CocList commands<cr>
" Find symbol of current document.
nnoremap <silent><nowait> <space>o  :<C-u>CocList outline<cr>
" Search workspace symbols.
nnoremap <silent><nowait> <space>s  :<C-u>CocList -I symbols<cr>
" Do default action for next item.
nnoremap <silent><nowait> <space>j  :<C-u>CocNext<CR>
" Do default action for previous item.
nnoremap <silent><nowait> <space>k  :<C-u>CocPrev<CR>
" Resume latest coc list.
nnoremap <silent><nowait> <space>p  :<C-u>CocListResume<CR>

"""""""""""""" MarkdownPreview configs
let g:mkdp_auto_close = 1
let g:mkdp_preview_options = {
    \ 'mkit': {},
    \ 'katex': {},
    \ 'uml': {},
    \ 'maid': {},
    \ 'disable_sync_scroll': 0,
    \ 'sync_scroll_type': 'middle',
    \ 'hide_yaml_meta': 1,
    \ 'sequence_diagrams': {},
    \ 'flowchart_diagrams': {},
    \ 'content_editable': v:false,
    \ 'disable_filename': 0
    \ }
let g:mkdp_filetypes = ['markdown']

"Make the current tab more visible
highlight TabLineSel ctermfg=Blue

let g:coc_node_log_file = expand('~/.config/nvim/coc-clangd.log')
let g:coc_node_log_level = 'debug'

" Map F8 to open Tagbar, function menu on the side
nmap <F8> :TagbarToggle<CR>

" Vivint-specific: Various functions for deploying to panel
" Map Ctrl-p to update python file on panel
nmap <C-p> :w<CR>:DeployPythonToPanel<CR>

