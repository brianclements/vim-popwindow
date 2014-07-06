" popwindow.vim
" Author:   Brian Clements <brian@brianclements.net>
" Version:  1.1.0

function! PopWindow()
    let curwin = winnr()
    let newest_win = winnr('$')
    let next_win = newest_win
    let buffound = 0
    let closed_fugitive = 0
    let buftypes = ['help', 'quickfix', 'nofile', 'nowrite' ]

    " Check for NERDTree
    let ntree_buf = winbufnr(1)
    let ntree_status = 0
    if getbufvar(ntree_buf, 'NERDTreeType') ==# 'primary'
        let ntree_status = 1
    endif

    " Approximate fugitive window location
    if ntree_status == 1
        let fugitive_win = 2
    else
        let fugitive_win = 1
    endif

    " Confirm it's Fugitive
    let fugitive_buf = winbufnr(fugitive_win)
    if bufname(fugitive_buf) =~# '.git/index'
        if getbufvar(fugitive_buf, '&readonly') == 1
            let do_close_fugitive = 1
        endif
    endif

    for type in buftypes
        while 1
            let nbuf = winbufnr(next_win)
            " Omit NERDTree from search if present
            if next_win == 1 && ntree_status == 1
                let nbuf = -1
            endif
            " After all windows processed, reset loop for next buftype
            if nbuf == -1
                let next_win = newest_win
                let buffound = 0
                break
            endif

            " Mark window for closure if it's of a certain buftype
            if getbufvar(nbuf, '&buftype') ==# type
                let buffound = 1
            endif
            
            if buffound == 1
                break
            else
                let next_win = next_win - 1
                exec next_win.'wincmd w'
            endif
        endwhile

        if buffound == 1
            break
        endif
    endfor

    if buffound == 1
        " Correct saved window number if younger window will be closed
        if curwin > next_win
            let curwin = curwin - 1

            exec next_win . 'wincmd w'
            exec 'bdelete'
            exec curwin . 'wincmd w'
        " Correct current window if it is the one to be closed
        elseif curwin == next_win
            if curwin == winnr('$')
                let curwin = curwin - 1
            else
                let curwin = curwin + 1
            endif

            exec next_win . 'wincmd w'
            exec 'bdelete'
            exec curwin . 'wincmd w'
        " Window to close is somewhere else
        else
            exec next_win . 'wincmd w'
            exec 'bdelete'
            exec curwin . 'wincmd w'
        endif
    endif
    " If no specialty buffers found, then close:
    " - fugitive GStatus window
    " - the top-most window.
    if buffound == 0
        " Don't close window 1 or 2 if NERDTree is open
        if newest_win == 2 && ntree_status == 1
            echo "Can't close last normal buffer"
        " Don't close anything if only one window left
        elseif newest_win == 1 && ntree_status == 0
            echo "Can't close last normal buffer"
        " Close fugitive first before popping regular windows
        elseif do_close_fugitive == 1
            exec 'bd' . fugitive_buf
        else
            " pop normal windows
            exec winnr('$') . 'wincmd w'
            close!
            exec curwin . 'wincmd w'
        endif
    endif
endfunction

command! -nargs=0 PopWindow call PopWindow()
