" ------------------------
" Enable vim-textobj-quote
" ------------------------
autocmd BufNewFile,BufEnter *.md call textobj#quote#init({'educate': 1})

" -----------------
" Setup auto-pairs
" -----------------
" Disable " and ' to avoid conflict with vim-textobj-quote
autocmd BufNewFile,BufEnter *.md let b:AutoPairs = {'(':')', '[':']', '{':'}', '`':'`'}

" ---------------------
" Build Markdown project
" ---------------------
" 1. Since BufRead doesn't seem to be triggered from within this ftplugin file, use BufEnter in the autocmds instead.
" 2. We use the :execute instead of calling :Term directly to allow expanding $HOME before calling the underlying :terminal command ($HOME or ~ are not understood if passed as arguments of :terminal).
autocmd BufNewFile,BufEnter *.md nnoremap <buffer> <silent> zb :w<CR>:execute "Term " . expand($HOME) . "/.vim/scripts/build-markdown.sh %:p:S"<CR>

" --------------------------------------------------------
" Insert image with Ranger selection and Ultisnips snippet
" --------------------------------------------------------
" autocmd BufNewFile,BufEnter *.md nnoremap gi ifig<c-r>=UltiSnips#ExpandSnippet()<CR><Esc>:call AppendRelativePathWithRanger()<CR>

" ----------------------------------------------
" Insert a numbered figure with Ranger selection
" ----------------------------------------------
" Uses the n register to store the figure timestamp and sets the n mark at the figure caption position
autocmd BufNewFile,BufEnter *.md nnoremap gi i<!-- begin numbered figure --><CR><CR>(@<c-r>=strftime("%Y%m%d%H%M%S")<CR>)<Esc>F@w"nyiwo<CR>![Fig. @<c-r>n: <Esc>mna](<Esc>:call AppendRelativePathWithRanger()<CR>a){width=500px}<CR><CR><!-- end numbered figure --><Esc>`na

" ------------------------------------------------------------
" Append bibliography reference with fzf and UltiSnips snippet
" ------------------------------------------------------------
" Call from anywhere within a word (we use he to move to the end of the word in any case)
" Use fzf#wrap to take into account default fzf options. See: https://github.com/junegunn/fzf/blob/fc1b119159f24136e64a85a8ea3dd51f19161602/README-VIM.md#fzfwrap
autocmd BufNewFile,BufEnter *.md nnoremap <silent> gq hea[@<Esc>:call fzf#run(fzf#wrap('', {'source': '~/.dotfiles/.vim/scripts/fzf-from-bib.sh ~/src/Markdown/Projets/Article\ Livre\ Active\ Materials\ 2018-10', 'sink': function('<SID>AppendBibliographicReferenceFromFzf'), 'options': ['--exact']}, 0))<CR>a]()
" Helper function: insert a bibliographic reference from a string generated through the fzf-from-bib.sh script
function! <SID>AppendBibliographicReferenceFromFzf(l)
    let ref = split(a:l, ":")[0]
    " Insert the extracted reference at cursor location
    execute "normal! a" . ref
endfun

" ---------------
" Insert footnote
" ---------------
" Uses the n register to store the note timestamp and sets the n mark at the end of the footnote call command
autocmd BufNewFile,BufEnter *.md nnoremap <silent> gn hea[^<c-r>=strftime("%Y%m%d%H%M%S")<CR>]<Esc>mnF^w"nyiwGo[^<c-r>n]: |
