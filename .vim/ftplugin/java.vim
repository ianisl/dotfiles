" ------------------------
" Build Processing project
" ------------------------
" 1. Since BufRead doesn't seem to be triggered from within this ftplugin file, use BufEnter in the autocmds instead.
" 2. We use the :execute instead of calling :Term directly to allow expanding $HOME before calling the underlying :terminal command ($HOME or ~ are not understood if passed as arguments of :terminal).
" 3. We can't use %:p:S (see :h filename-modifiers) for escaping the special characters in the filepath passed to the build-kotlin.sh script, as the file path would be passed with enclosing quotes. Instead, a working hack is to escape every single character in the filepath. See: https://unix.stackexchange.com/questions/319423/vim-how-to-escape-filename-containing-single-and-double-quotes-mix.
autocmd BufNewFile,BufEnter *.pde nnoremap <buffer> <silent> zb :execute 'Term ' . expand($HOME) . '/.vim/scripts/build-processing.sh %:p:gs/./\\&/'<CR>
