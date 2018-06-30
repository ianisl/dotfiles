" --------------------
" Build Kotlin project
" --------------------
" 1. Since BufRead doesn't seem to be triggered from within this ftplugin file, use BufEnter in the autocmds instead.
" 2. We use the :execute instead of calling :Term directly to allow expanding $HOME before calling the underlying :terminal command ($HOME or ~ are not understood if passed as arguments of :terminal).
autocmd BufNewFile,BufEnter *.kt nnoremap <buffer> <silent> zb :execute "Term " . expand($HOME) . "/.vim/scripts/build-kotlin.sh %:p:S"<CR>
