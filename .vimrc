" vim: foldmethod=marker

" Plugins {{{1
" ============
set nocompatible
filetype off
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
Plugin 'VundleVim/Vundle.vim' " Required
Plugin 'altercation/vim-colors-solarized'
Plugin 'tpope/vim-surround'
Plugin 'SirVer/ultisnips'
Bundle 'ervandew/supertab'
Plugin 'tpope/vim-commentary'
Plugin 'osyo-manga/vim-anzu'
Plugin 'Valloric/YouCompleteMe'
Plugin 'junegunn/fzf'
Plugin 'junegunn/fzf.vim'
Plugin 'jiangmiao/auto-pairs'
Plugin 'lilydjwg/colorizer'
Plugin 'junegunn/goyo.vim'
Plugin 'pangloss/vim-javascript'
Plugin 'tpope/vim-repeat'
Plugin 'joshdick/onedark.vim'
" TODO install
" osyo-manga/vim-over
" wincent/replay
call vundle#end() " Required
filetype plugin indent on " Required

" Preferences {{{1
" ================
" ------------------
" Suppress Esc delay
" ------------------
set timeoutlen=1000 ttimeoutlen=0
" ------------------------
" Enable syntax hilighting
" ------------------------
syntax on
" ---------------
" Set lazy redraw
" ---------------
set lazyredraw
" --------------------
" Set default encoding
" --------------------
set encoding=utf-8
" -------------
" Scroll offset
" -------------
set scrolloff=1
" -----------------------------
" Increase default history size
" -----------------------------
set history=1000
" -------------------------
" Set relative line numbers
" -------------------------
set relativenumber
set number
" ------
" Search
" ------
set ignorecase
set smartcase
set incsearch
" -----------------------------------------------------
" Delete comment character when joining commented lines
" -----------------------------------------------------
set formatoptions+=j
" ----------------------
" Location of new splits
" ----------------------
set splitbelow
set splitright
" -------------------
" Tabulation settings
" -------------------
" smartindent should not be turned on if using filetype indentation
set tabstop=4
set softtabstop=4
set shiftwidth=4
set expandtab
set autoindent
" ---------
" Soft wrap
" ---------
set wrap
" Don't split in the middle of words
set linebreak
" Fix indent for soft wrap
set breakindent
" Disable autowrap
set textwidth=0
" -----------------------------
" Allow creating hidden buffers
" -----------------------------
set hidden
" -------------------------
" Auto-monitor file changes
" -------------------------
set autoread
" -------------------------------------
" Fix potential problems with backspace
" -------------------------------------
set backspace=indent,eol,start
" --------------------
" Automatic formatting
" --------------------
augroup custom_automatic_formatting
    autocmd!
    " Disable auto-comment insertion
    autocmd FileType * setlocal formatoptions-=c formatoptions-=r formatoptions-=o
    " Strip trailing spaces on save
    autocmd BufWritePre * :call <SID>StripTrailingWhitespaces()
augroup END
" -------------------------
" Auto-completion (default)
" -------------------------
" Disable for include files
set complete-=i
" Command-line auto-completion options
set wildmode=longest:full,full
set wildmenu
" Disable omnifunc (shows too much stuff on YCM)
set omnifunc=
" Disable preview window
set completeopt-=preview
" -------------------------------
" Auto-completion (YouCompleteMe)
" -------------------------------
let g:ycm_complete_in_comments = 1
let g:ycm_use_ultisnips_completer = 1
" Make YouCompleteMe compatible with UltiSnips (using Supertab)
let g:ycm_key_list_select_completion = ['<c-n>', '<Down>']
let g:ycm_key_list_previous_completion = ['<c-p>', '<Up>']
let g:SuperTabDefaultCompletionType = '<c-n>'
" --------------------------
" Pair matching (Auto Pairs)
" --------------------------
" disable screen centering after pairing a character
let g:AutoPairsCenterLine = 0
let g:AutoPairsShortcutToggle = ''
let g:AutoPairsShortcutFastWrap = ''
let g:AutoPairsShortcutJump = ''
let g:AutoPairsShortcutBackInsert = ''
" --------------------
" Snippets (UltiSnips)
" --------------------
" Location of custom snippets edition
" Warning: this is just to indicate which file should be edited when calling the UltiSnipsEdit command. The folder defined here may differ from the actual 'custom snippet' folder read by Ultisnips (defined below)
let g:UltiSnipsSnippetsDir = "~/.dotfiles/.vim/ultisnips/custom"
" Search path for all snippets (including custom ones)
" Warning: those paths are relative to ~/.vim (there seem to be no way to set up ultisnips properly while using another path, eg the ~/.dotfiles/.vim folder)
let g:UltiSnipsSnippetDirectories = ["ultisnips/vendor", "ultisnips/custom"]
let g:UltiSnipsEditSplit = "vertical"
" Use c-e as an expand trigger. While inside the YouCompleteMe menu, tab and s-tab will cycle through the autocompletion options and available snippets. After expanding a snippet, tab and s-tab will cycle through the snippet's placeholders.
let g:UltiSnipsExpandTrigger = "<c-e>"
let g:UltiSnipsJumpForwardTrigger = "<tab>"
let g:UltiSnipsJumpBackwardTrigger = "<s-tab>"
" Custom filetypes for UltiSnips
augroup custom_ultisnips_filetypes
    autocmd!
    autocmd FileType php UltiSnipsAddFiletypes html
augroup END

" Functions {{{1
" ==============
" -----------------------------------
" Set cursor to its normal mode value
" -----------------------------------
function! <SID>SetCursorNormal()
    silent! execute "!echo -ne '\033[2 q'"
endfunction
" -----------------------------
" Strip trailing spaces on save
" -----------------------------
function! <SID>StripTrailingWhitespaces() " Preserves cursor position when saving
    let l = line(".")
    let c = col(".")
    keeppatterns %s/\s\+$//e
    call cursor(l, c)
endfun
" ------------------------------------------------------------
" Execute shell command and show results in new vertical split
" ------------------------------------------------------------
command! -complete=shellcmd -nargs=+ Shell call s:ExecuteInShell(<q-args>)
function! s:ExecuteInShell(command)
  let command = join(map(split(a:command), 'expand(v:val)'))
  let winnr = bufwinnr('^' . command . '$')
  silent! execute  winnr < 0 ? 'botright vnew ' . fnameescape(command) : winnr . 'wincmd w'
  setlocal buftype=nowrite bufhidden=wipe nobuflisted noswapfile nowrap number
  echo 'Execute ' . command . '...'
  silent! execute 'silent %!'. command
  silent! execute 'resize '
  silent! redraw
  silent! execute 'au BufUnload <buffer> execute bufwinnr(' . bufnr('#') . ') . ''wincmd w'''
  silent! execute 'nnoremap <silent> <buffer> <LocalLeader>r :call <SID>ExecuteInShell(''' . command . ''')<CR>'
  echo 'Shell command ' . command . ' executed.'
endfunction
" ----------------------------------------------------
" Switch seamlessly between vim windows and tmux panes
" ----------------------------------------------------
" Except when Tmux is zoomed. In this case, stay within Vim
function! <SID>GoToNextWindowOrTmuxPane()
    if winnr() == winnr('$')
        " In all cases, go back to the first Vim split
        execute "normal \<c-w>\<c-t>"
        let g:isTmuxZoomed = system('if tmux list-panes -F "#F" | grep -q Z; then echo 1; else echo 0; fi')
        if g:isTmuxZoomed == 0
            " If Tmux is not zoomed, select next pane
            silent call system('tmux select-pane -t :.+')
        endif
    else
        execute "normal \<c-w>\<c-w>"
    endif
endfun

" Cursor appearance {{{1
" ======================
" ----------------------------------------------
" Change cursor shape in standard and edit modes
" ----------------------------------------------
let &t_SI = "\<Esc>[6 q"
let &t_EI = "\<Esc>[2 q"
" Fix cursor at startup if called from the prompt in insert mode
augroup custom_cursor
    autocmd!
    autocmd VimEnter * :call <SID>SetCursorNormal()
augroup END
" ---------------------------------------------------------------
" remap c-z so the cursor is brought back to normal when using fg
" ---------------------------------------------------------------
nnoremap <silent> <C-z> :suspend<bar>:call <SID>SetCursorNormal()<CR>
" --------------------------------------
" Cursor shape (vim-togglecursor plugin)
" --------------------------------------
" TODO not used anymore
" let g:togglecursor_default='block'
" let g:togglecursor_insert='line'

" UI {{{1
" =======
" -----------------------------------------------------------
" Tell vim the background is dark (define before tweaking UI)
" -----------------------------------------------------------
set background=dark
" --------------------------
" Set Solarized color scheme
" --------------------------
" let g:solarized_termcolors=16
" colorscheme solarized
" --------------------------
" Set Onedark color scheme
" --------------------------
let g:onedark_termcolors=256
colorscheme onedark
" ---------------------
" Set editor background
" ---------------------
" needed to remove the ~ at the end of Vim's buffer
hi Normal ctermbg=235
hi NonText ctermbg=235
" ---------------------------
" Hide ~ at the end of buffer
" ---------------------------
hi EndOfBuffer ctermfg=233
" ---------------
" Warning message
" ---------------
hi WarningMsg ctermfg=247 ctermbg=NONE
" ----------------
" Split delimiters
" ----------------
" Replace the split chars
set fillchars+=vert:│
" Split char bg and fg
hi VertSplit ctermbg=NONE ctermfg=235
" ----------------------------------
" Change style of delimiter matching
" ----------------------------------
hi MatchParen term=bold cterm=bold ctermfg=1 ctermbg=NONE guibg=NONE
" ------------------------------
" Line and cursor line number background
" ------------------------------
hi LineNr ctermfg=240 ctermbg=NONE
hi CursorLineNr ctermfg=243 ctermbg=NONE
" ----------------------------
" Search result display (Anzu)
" ----------------------------
let g:anzu_status_format='%i/%l'
" -------------------
" Autocompletion menu
" -------------------
hi Pmenu ctermfg=245 ctermbg=235
hi PmenuSel ctermfg=234 ctermbg=244
" --------------------
" Statusline (default)
" --------------------
set noshowmode
set showcmd
set laststatus=2
set statusline=\ %F%m%r\ %{anzu#search_status()}\ %=\ %{&filetype}\ %L\ |
hi StatusLine ctermfg=234 ctermbg=247
hi StatusLineNC ctermfg=234 ctermbg=240
hi WildMenu ctermfg=244 ctermbg=234
" -----------------
" Tabline (default)
" -----------------
set showtabline=0
" -------------------
" Writing mode (Goyo)
" -------------------
let g:goyo_width=70
let g:goyo_height="100%"
" Reload vimrc on Goyo leave to restore UI tweaks
" Check if the function already exists to allow sourcing vimrc
if !exists("*GoyoLeave")
    function! GoyoLeave()
        source ~/.dotfiles/.vimrc
        quit
    endfunction
endif
augroup goyo_leave
    autocmd! User GoyoLeave nested call GoyoLeave()
augroup END

" Key bindings {{{1
" =================
" -------------------------
" Silent up/down movements
" -------------------------
" With right positioning when using ranges on soft wrapped lines
nnoremap <silent> <expr> j (v:count == 0 ? ":exe 'normal gj'<CR>" : "j")
nnoremap <silent> <expr> k (v:count == 0 ? ":exe 'normal gk'<CR>" : "k")
" -----------------------------------------------------
" More consistent operations with relative line numbers
" -----------------------------------------------------
noremap <silent> <expr> dd (v:count > 0 ? ":<c-u>exe ':d<c-r>=v:count + 1<CR>'<CR>" : "dd")
" -----------------------------
" Increase and decrease numbers
" -----------------------------
noremap <Left> <c-x>
noremap <Right> <c-a>
" ------------------
" Easier command key
" ------------------
noremap = :
noremap + =
" ------------------------------------------------------
" Easier search, more consistent location of back-search
" ------------------------------------------------------
noremap : /
noremap / ?
" --------------------------------------
" Easier, more consistent prev/next char
" --------------------------------------
noremap , ;
noremap ? ,
" --------------------
" More consistent redo
" --------------------
noremap U <c-r>
" ---------------------
" Switch between splits
" ---------------------
" noremap é <c-w>w
" ---------
" jj to Esc
" ---------
inoremap jj <Esc>
" --------------------------------------
" Easier enter into linewise visual mode
" --------------------------------------
vnoremap v V
" --------------------------------------------------------
" Save (use ¶ instead of § to avoid a bug with Auto Pairs)
" --------------------------------------------------------
noremap <silent> ¶ :silent w<CR>
inoremap <silent> ¶ <Esc>:silent w<CR>
" ---------------------
" System copy and paste
" ---------------------
" TODO disabled because tmux uses the same mapping
" noremap ù "+y
" noremap ¥ "+p
" -----------------------
" Swap lines with A-j A-k
" -----------------------
nnoremap Ï :m .+1<CR>==
nnoremap È :m .-2<CR>==
inoremap Ï <Esc>:m .+1<CR>==gi
inoremap È <Esc>:m .-2<CR>==gi
vnoremap Ï :m '>+1<CR>gv=gv
vnoremap È :m '<-2<CR>gv=gv
" -------------------------------------------
" Go back to beginning of first non-char
" --------------------------------------
noremap à ^
" --------------
" fzf navigation
" --------------
noremap zd :Buffers<CR>
noremap ze :Files<CR>
" ------------------------
" Clear anzu search status
" ------------------------
" nmap <Esc><Esc> <Plug>(anzu-clear-search-status)
" ---------------------------
" TODO temp disable space key
" ---------------------------
noremap <Space> <NOP>
" --------------------
" Enable anzu mappings
" --------------------
" Necessary to make the search count visible and updated in the statusline
nmap n <Plug>(anzu-n)
nmap N <Plug>(anzu-N)
nmap * <Plug>(anzu-star)
nmap # <Plug>(anzu-sharp)
" -----------------------------------------
" Switch between vim windows and tmux panes
" -----------------------------------------
nnoremap <silent> é :call <SID>GoToNextWindowOrTmuxPane()<CR>
" ------------------------------------------
" Reveal the current file's folder in Finder
" ------------------------------------------
noremap <c-@> :!open $(dirname %)<CR><CR>
" ----------------
" Prev/Next search
" ----------------
noremap ) #
noremap - *

" Build systems {{{1
" ==================
augroup custom_build_systems
    autocmd!
    " Processing
    autocmd BufNewFile,BufRead *.pde nnoremap zb :Shell gulp start-processing<CR>
augroup END

" File types {{{1
" ==============
augroup custom_filetypes
    autocmd!
    autocmd BufNewFile,BufRead *.pde set ft=java
    autocmd BufNewFile,BufRead *.md Goyo
augroup END
