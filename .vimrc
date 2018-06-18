" vim: foldmethod=marker

" Plugins {{{1
" ============
set nocompatible
filetype off
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
Plugin 'VundleVim/Vundle.vim' " Required
Plugin 'tpope/vim-surround'
Plugin 'SirVer/ultisnips'
Bundle 'ervandew/supertab'
Plugin 'tpope/vim-commentary'
Plugin 'osyo-manga/vim-anzu'
Plugin 'Valloric/YouCompleteMe'
Plugin 'junegunn/fzf'
Plugin 'junegunn/fzf.vim'
Plugin 'jiangmiao/auto-pairs'
Plugin 'junegunn/goyo.vim'
Plugin 'ctrlpvim/ctrlp.vim'
Plugin 'tacahiroy/ctrlp-funky'
Plugin 'tikhomirov/vim-glsl'
Plugin 'tpope/vim-repeat'
Plugin 'joshdick/onedark.vim'
Plugin 'francoiscabrol/ranger.vim'
Plugin 'junegunn/vim-easy-align'
" Plugin 'lilydjwg/colorizer'
" TODO install?
" osyo-manga/vim-over
" wincent/replay
" w0rp/ale
" vim-syntastic/syntastic
" xojs/vim-xo
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
" ------------------------
" Always add - to keywords
" ------------------------
set iskeyword+=-
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
" -----------------------------------------------
" Enable line numbers (hack to get a left margin)
" -----------------------------------------------
" set norelativenumber
set number
" ------------------------------
" Allow displaying partial lines
" ------------------------------
set display=lastline
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
" Custom comment formatting
augroup custom_comment_formatting
    autocmd!
    autocmd FileType markdown setlocal commentstring=<!--\ %s\ -->
    autocmd FileType php setlocal commentstring=//\ %s
augroup END
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
au CursorHold,CursorHoldI * checktime
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
let g:UltiSnipsExpandTrigger = "<c-j>"
let g:UltiSnipsJumpForwardTrigger = "<tab>"
let g:UltiSnipsJumpBackwardTrigger = "<s-tab>"
" " Custom filetypes for UltiSnips
" augroup custom_ultisnips_filetypes
"     autocmd!
"     autocmd FileType php UltiSnipsAddFiletypes html
" augroup END
" ------------
" CtrlP prompt
" ------------
let g:ctrlp_prompt_mappings = {
    \ 'PrtSelectMove("j")':   ['j', '<down>'],
    \ 'PrtSelectMove("k")':   ['k', '<up>'],
    \ }
let g:ctrlp_match_window = 'order:ttb,min:1,max:12,results:0'
" -------------------
" Writing mode (Goyo)
" -------------------
let g:goyo_width=70
let g:goyo_height="100%"
" Callbacks allowing to avoid quitting twice to effectively close Vim when in Goyo mode
" Show commands and statusline
function! g:GoyoBefore()
    " Show commands and statusline
    set showcmd
    set laststatus=2
    " Statusline hack: enabling the statusline with Goyo cause strange \ characters to appear in place of spaces in the statusline. A workaround is to rely on a left-only alilgned statusline (thus we drop all items that would be aligned right after the justification), leave the StatusLine hilight to the same color as the background (which is done by Goyo and hides the \ characters) and temporarily enable a user hilight group to display the left part of the statusline
    hi User1 ctermfg=241 ctermbg=235
    setlocal statusline=%#User1#%3l\ ›\ %f%m%r\ %{anzu#search_status()}%#StatusLine#\ |
    " Fix some UI tweaks TODO necessary?
    hi Normal ctermbg=235
    hi NonText ctermbg=235
    " Prepare the quitting fix
    let b:quitting = 0
    let b:quitting_bang = 0
    autocmd QuitPre <buffer> let b:quitting = 1
    cabbrev <buffer> q! let b:quitting_bang = 1 <bar> q!
endfunction
function! g:GoyoAfter()
    " Quit Vim if this is the only remaining buffer
    if b:quitting && len(filter(range(1, bufnr('$')), 'buflisted(v:val)')) == 1
        if b:quitting_bang
            qa!
        else
            qa
        endif
    else
        " Reload settings. Add silent otherwise vim will complain it can't redefine GoyoAfter (because it is currently using it)
        silent! source ~/.vimrc
    endif
endfunction
let g:goyo_callbacks = [function('g:GoyoBefore'), function('g:GoyoAfter')]
" ---
" fzf
" ---
" Split mappings
let g:fzf_action = {
  \ 'ctrl-t': 'tab split',
  \ 'ctrl-s': 'split',
  \ 'ctrl-v': 'vsplit' }
" Accept with , in commands
command! -bar -bang -nargs=? -complete=buffer Buffers call fzf#vim#buffers(<q-args>, {'options': '--bind ",:accept"'}, <bang>0)
command! -bang -nargs=? -complete=dir Files call fzf#vim#files(<q-args>, {'options': '--bind ",:accept"'}, <bang>0)
command! -bang -nargs=* Ag call fzf#vim#ag(<q-args>, {'options': '--bind ",:accept"'}, <bang>0)
" Customize fzf colors to match your color scheme
let g:fzf_colors =
\ { 'fg':      ['fg', 'Normal'],
  \ 'bg':      ['bg', 'Normal'],
  \ 'hl':      ['fg', 'Comment'],
  \ 'fg+':     ['fg', 'CursorLine', 'CursorColumn', 'Normal'],
  \ 'bg+':     ['bg', 'CursorLine', 'CursorColumn'],
  \ 'hl+':     ['fg', 'Statement'],
  \ 'info':    ['fg', 'PreProc'],
  \ 'border':  ['fg', 'Ignore'],
  \ 'prompt':  ['fg', 'Conditional'],
  \ 'pointer': ['fg', 'Exception'],
  \ 'marker':  ['fg', 'Keyword'],
  \ 'spinner': ['fg', 'Label'],
  \ 'header':  ['fg', 'Comment'] }

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
    " Don't strip on mails (allows using text_flowed in mutt)
    if &ft =~ 'mail'
        return
    endif
    let l = line(".")
    let c = col(".")
    keeppatterns %s/\s\+$//e
    call cursor(l, c)
endfun
" ----------------------------------------------------------
" Process selection through some selected languagetool rules
" ----------------------------------------------------------
" TODO deprecated
function! FixWithLanguageTool() range
  let fix = system('languagetool -adl -a -e FRENCH_WHITESPACE,UPPERCASE_SENTENCE_START,COMMA_PARENTHESIS_WHITESPACE <(echo ' . shellescape(join(getline(a:firstline, a:lastline), "\n")) . ') 2> /dev/null')
  call setline(a:firstline, split(fix, "\n"))
endfunction
" -------------------------------------------------------------------
" Auto-format selection or current line with basic typographic checks
" -------------------------------------------------------------------
" Don't define range after the function to allow calling it on the current line if no range is given
" TODO when a keybinding is created for this function, add SID before function name
function! AutoFormatProse()
  " Capitalize the first word in a sentence
  let f = system('echo ' . shellescape(join(getline(a:firstline, a:lastline), "\n")) . ' | sed "s/\(^\(.\)\|\(\.\|?\|!\|…\) \(.\)\)/\U\1/g"')
  " TODO other rules
  call setline(a:firstline, split(f, "\n"))
endfunction
" ------------------------------------------------------------
" Execute shell command and show results in new vertical split
" ------------------------------------------------------------
" Source: http://vim.wikia.com/wiki/Display_output_of_shell_commands_in_new_window
command! -complete=shellcmd -nargs=+ Shell call s:ExecuteInShell(<q-args>)
function! s:ExecuteInShell(command)
  let command = join(map(split(a:command), 'expand(v:val)'))
  let winnr = bufwinnr('^' . command . '$')
  silent! execute  winnr < 0 ? 'botright new ' . fnameescape(command) : winnr . 'wincmd w'
  setlocal buftype=nowrite bufhidden=wipe nobuflisted noswapfile nowrap number
  echo 'Executing ' . command . '...'
  silent! execute 'silent %!'. command
  " Set the height of the split here
  silent! execute 'resize 15'
  silent! redraw
  silent! execute 'au BufUnload <buffer> execute bufwinnr(' . bufnr('#') . ') . ''wincmd w'''
  silent! execute 'nnoremap <silent> <buffer> <LocalLeader>r :call <SID>ExecuteInShell(''' . command . ''')<CR>'
  " echo 'Shell command ' . command . ' executed.'
endfunction
" ----------------------------------------------------
" Switch seamlessly between vim windows and tmux panes
" ----------------------------------------------------
" When Tmux is zoomed, always stay within Vim
" When using Goyo, always switch to next tmux pane
function! <SID>GoToNextWindowOrTmuxPane()
    if exists('#goyo')
        silent call system('tmux select-pane -t :.+')
    else
        if winnr() == winnr('$')
            " In all cases, go back to the first Vim split
            execute "normal \<c-w>\<c-t>"
            " Check if tmux is zoomed
            let g:isTmuxZoomed = system('if tmux list-panes -F "#F" | grep -q Z; then echo 1; else echo 0; fi')
            if g:isTmuxZoomed == 0
                " If Tmux is not zoomed, select next pane
                silent call system('tmux select-pane -t :.+')
            endif
        else
            execute "normal \<c-w>\<c-w>"
        endif
    endif
endfun

" Commands {{{1
" =============
" ---------------------------------------------------------
" Set the working directory according to the current buffer
" ---------------------------------------------------------
command! UpdateWorkingDirectory cd %:p:h
" -------------
" Source .vimrc
" -------------
command! SourceVimrc source ~/.vimrc

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
hi Normal ctermbg=235
" -------------------------------------------
" Hide enabled listchars except when selected
" -------------------------------------------
" Also hides the ~ at the end of Vim's buffer
" Will hide eol chars but they will still be visible when selected
hi NonText ctermbg=235 ctermfg=235
hi SpecialKey ctermbg=235 ctermfg=235
" ---------------------------
" Hide ~ at the end of buffer
" ---------------------------
hi EndOfBuffer ctermfg=235
" ---------------
" Warning message
" ---------------
hi WarningMsg ctermfg=247 ctermbg=NONE
" --------------
" Show eol chars
" --------------
set list
set lcs=eol:¬,space:•
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
hi LineNr ctermfg=235 ctermbg=NONE
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
set statusline=%3l\ ›\ %f%m%r\ %{anzu#search_status()}\ %=\ %{&filetype}\ %L\ |
hi StatusLine ctermfg=241 ctermbg=235
hi StatusLineNC ctermfg=239 ctermbg=235
hi WildMenu ctermfg=244 ctermbg=234
" -----------------
" Tabline (default)
" -----------------
set showtabline=0

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
" noremap <silent> <expr> dd (v:count > 0 ? ":<c-u>exe ':d<c-r>=v:count + 1<CR>'<CR>" : "dd")
" -----------------------------
" Increase and decrease numbers
" -----------------------------
noremap <Left> <c-x>
noremap <Right> <c-a>
" ----------------------------
" Easier use of backtick marks
" ----------------------------
noremap ' `
" ---------------------------------
" Enter with , in command-line mode
" ---------------------------------
cnoremap , <CR>
" -------------------------------
" Enter with , in quickfix buffer
" -------------------------------
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
" Easier, more consistent prev/next char with , / ?
" --------------------------------------
noremap ? ,
" This also allows using , as enter in the quickfix window
" Inspired from: https://vi.stackexchange.com/questions/3127/how-to-map-enter-to-custom-command-except-in-quick-fix
noremap <expr> , &buftype ==# 'quickfix' ? "\<CR>" : ';'
" --------------------
" More consistent redo
" --------------------
noremap U <c-r>
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
noremap ù "+y
noremap ¥ "+p
" Paste in insert mode
inoremap ¥ <c-o>"+p
" Copy current line in insert mode
" inoremap ù <c-o>"+yy
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
" ---------------------------------------------------------------
" Search for word under cursor or selection with fzf's Ag command
" ---------------------------------------------------------------
" Search the word under the cursor without using a register
nnoremap gd :Ag <c-r><c-w><CR>
nnoremap gD :Ag <c-r><c-a><CR>
" For visual mode, it seems we have no other way than using a register (here, g)
vnoremap gd "gy:Ag <c-r>g<CR>
" ----------
" CtrlPFunky
" ----------
noremap zf :CtrlPFunky<CR>
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
" ------------------------------
" Map Ctrl+G to Escape in prompt
" ------------------------------
" Used to make escape-cancellation of prompt work when vim is launched from within mutt
cnoremap <c-g> <Esc>
" ----------------------
" Open files with Ranger
" ----------------------
noremap gr :Ranger<CR>
" -----------------------
" Select just pasted text
" -----------------------
" Source: http://vim.wikia.com/wiki/Selecting_your_pasted_text
nnoremap <expr> gp '`[' . strpart(getregtype(), 0, 1) . '`]'
" ------------------
" EasyAlign mappings
" ------------------
" Start interactive EasyAlign in visual mode (e.g. vipga)
xmap ga <Plug>(EasyAlign)
" Start interactive EasyAlign for a motion/text object (e.g. gaip)
" nmap ga <Plug>(EasyAlign)

" Abbreviations {{{1
" ==================
iabbrev todo TODO

" Build systems {{{1
" ==================
augroup custom_build_systems
    autocmd!
    " Processing
    " autocmd BufNewFile,BufRead *.pde nnoremap zb :Shell gulp start-processing<CR>
    " See :h filename-modifiers
    autocmd BufNewFile,BufRead *.pde nnoremap zb :Shell ~/.vim/scripts/build-processing.sh %:p:S<CR>
augroup END

" Filetype actions {{{1
" =====================
augroup custom_filetype_actions
    autocmd!
    autocmd BufNewFile,BufRead *.pde set ft=java
    autocmd BufNewFile,BufRead *.md Goyo
augroup END
