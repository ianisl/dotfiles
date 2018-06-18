" -----------------------
" Prepare input for reply
" -----------------------
" Source: http://www.mdlerch.com/emailing-mutt-and-vim-advanced-config.html
function! <SID>PrepareForReply()
    if &modifiable
        if search('From:', 'c', 1)
            " Go to first empty line
            let firstEmptyLine = search('^$', 'cW')
            execute firstEmptyLine
            " Detect if the next line is the quoted message, if so, no text has been written yet: add a new line and go to insert mode
        endif
        " Restore soft wrap
        setl tw=0
        " Enable spell check
        setl spell
        setl spelllang=fr
        " Start in insert mode TODO not always
        startinsert
        " start Goyo
        Goyo
    endif
endfunction
" -------------------------
" Buffer-local autocommands
" -------------------------
" See: https://vi.stackexchange.com/questions/8056/for-an-autocmd-in-a-ftplugin-should-i-use-pattern-matching-or-buffer
augroup ftplugin_mail
    autocmd! * <buffer>
    autocmd VimEnter <buffer> call <SID>PrepareForReply()
augroup END
