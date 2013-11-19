" popwindow.vim
" Author:   Brian Clements <brian@brianclements.net>
" Version:  0.4.0

function! PopWindow()
    let curwin = winnr()
    let newest_win = winnr('$')
    let next_win = 1
    let buffound = 0
    while 1
        let nbuf = winbufnr(next_win)
        " After all windows processed, finish.
        if nbuf == -1
            break
        endif

        " Mark window for closure if it's of a certain buftype
        if getbufvar(nbuf, '&buftype') ==# 'help'
            let buffound = 1
        elseif getbufvar(nbuf, '&buftype') ==# 'quickfix'
            let buffound = 1
        elseif getbufvar(nbuf, '&buftype') ==# 'nowrite'
            let buffound = 1
        elseif getbufvar(nbuf, '&buftype') ==# 'nofile'
            let buffound = 1
        endif
        
        " If there is one window left, exit loop
        if next_win == 1 && winbufnr(2) == -1
            break
        elseif buffound == 1
            break
        elseif nbuf == newest_win
            break
        else
            let next_win = next_win + 1
            exec next_win.'wincmd w'
        endif
    endwhile

    if buffound == 1
        " Correct saved window number if younger window will be closed
        if curwin > nbuf
            let curwin = curwin - 1
        endif
        " Correct current window if it is the one to be closed
        if curwin == newest_win
            let curwin = curwin - 1
        endif
        close!
    else
    "If no specialty buffers found, then close the top most window.
        if newest_win == 1
            echo "Can't close last normal buffer"
        else
            exec newest_win.'wincmd w'
            close!
            exec curwin.'wincmd w'
        endif
    endif
endfunction

command! -nargs=0 PopWindow call PopWindow()
