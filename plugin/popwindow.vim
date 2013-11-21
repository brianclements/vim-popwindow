" popwindow.vim
" Author:   Brian Clements <brian@brianclements.net>
" Version:  1.0.0

function! PopWindow()
    let curwin = winnr()
    let newest_win = winnr('$')
    let next_win = 1
    let buffound = 0
    let buftypes = ['quickfix', 'nofile', 'nowrite', 'help']
    for type in buftypes
        while 1
            let nbuf = winbufnr(next_win)
            " After all windows processed, reset loop for next buftype
            if nbuf == -1
                let next_win = 1
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
                let next_win = next_win + 1
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
    " If no specialty buffers found, then close the top most window.
    if buffound == 0
        " Don't close anything if only one window left
        if newest_win == 1
            echo "Can't close last normal buffer"
        " close window
        else
            exec winnr('$') . 'wincmd w'
            close!
            exec curwin . 'wincmd w'
        endif
    endif
endfunction

command! -nargs=0 PopWindow call PopWindow()
