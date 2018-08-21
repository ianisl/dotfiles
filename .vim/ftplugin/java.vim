" ------------------------
" Build Processing project
" ------------------------
" 1. Since BufRead doesn't seem to be triggered from within this ftplugin file, use BufEnter in the autocmds instead.
" 2. We use the :execute instead of calling :Term directly to allow expanding $HOME before calling the underlying :terminal command ($HOME or ~ are not understood if passed as arguments of :terminal).
autocmd BufNewFile,BufEnter *.pde nnoremap <buffer> <silent> zb :w<CR>:execute "Term " . expand($HOME) . "/.vim/scripts/build-processing.sh %:p:S"<CR>
