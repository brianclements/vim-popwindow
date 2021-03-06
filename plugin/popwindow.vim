" popwindow.vim
" Author:   Brian Clements <brian@brianclements.net>
" Version:  2.2.1
" ----------------------------------------------
" Default Settings 
" ----------------------------------------------

" Pre-defined types to close; they are closed in this order.
if !exists("g:popwindow_close_types")
    let g:popwindow_close_types = [
        \'fugitive-diff', 'fugitive', 'help', 'quickfix',
        \'temp', 'permissive_temp', 'nerdtree']
endif

" Possible values
"   buffer: close buffer
"   window: leave buffer open, close window
if !exists("g:popwindow_close_method")
    let g:popwindow_close_method = 'buffer'
endif

" Close all matches for a given type if 1, or just the first if 0
if !exists("g:popwindow_zealous_close")
    let g:popwindow_zealous_close = 0
endif

" After looping through types, should we start popping off the top-most window?
if !exists("g:popwindow_pop_normal")
    let g:popwindow_pop_normal = 1
endif

" Ignore or force closure of modified buffers?
if !exists("g:popwindow_ignore_modified_buffers")
    let g:popwindow_ignore_modified_buffers = 1
endif


" ----------------------------------------------
" Core Functionality 
" ----------------------------------------------

function! GenerateList()
    let s:winlist = []
    windo call add(s:winlist, [winnr(), bufname('%'), bufnr('%'), &buftype, &ft, &readonly, &diff])
endfunction

function! Close(window_entry)
    if g:popwindow_close_method == 'buffer'
        if g:popwindow_ignore_modified_buffers == 1
            exec 'silent! bd! ' . s:winlist[a:window_entry][2]
        else
            exec 'silent! bd ' . s:winlist[a:window_entry][2]
        endif
    elseif g:popwindow_close_method == 'window'
        exec s:winlist[a:window_entry][0] . ' wincmd w'
        close!
    endif
endfunction

function! TrackCursor(window_entry)
    if g:popwindow_zealous_close == 1
        if a:window_entry <= s:current_win
            let s:current_win -= 1
        endif
    else
        if a:window_entry < s:current_win
            let s:current_win -= 1
        endif
    endif
endfunction

function! PostClose(window_entry)
    call TrackCursor(a:window_entry)
    call GenerateList()
    let s:special_types_found = 1
    let s:type_continue = 0
    if g:popwindow_zealous_close == 0
        let s:z_continue = 0
    endif
endfunction

function! PopWindow()
    let s:current_win = winnr() - 1
    let s:special_types_found = 0

    call GenerateList()

    let s:z_continue = 1
    let s:type_continue = 1
    for type in g:popwindow_close_types
        if s:type_continue == 0
            break
        endif
        for window in reverse(range(len(s:winlist)))
            if s:z_continue == 0
                break
            endif
            if type ==? 'help'
                call PluginHelp(window)
            elseif type ==? 'fugitive'
                call PluginFugitive(window)
            elseif type ==? 'explorer'
                call PluginExplorer(window)
            elseif type ==? 'nerdtree'
                call PluginNERDTree(window)
            elseif type ==? 'temp'
                call PluginTemp(window)
            elseif type ==? 'permissive_temp'
                call PluginPermissiveTemp(window)
            elseif type ==? 'quickfix'
                call PluginQuickfix(window)
            elseif type ==? 'fugitive-diff'
                call PluginFugitiveDiff(window)
            endif
        endfor
    endfor

    if g:popwindow_pop_normal == 1 &&
        \s:special_types_found == 0
        let s:z_continue = 1
        let s:reached_cursor = 0
        for window in reverse(range(len(s:winlist)))
            if s:z_continue == 0 || s:reached_cursor == 1
                break
            endif
            call PopNormalWindow(window)
        endfor
    endif

    exec s:current_win + 1 . 'wincmd w'
endfunction

command! -nargs=0 PopWindow call PopWindow()


" ----------------------------------------------
" Window Type Plugin Definitions
" ----------------------------------------------

function! PopNormalWindow(window_entry)
    if g:popwindow_zealous_close == 1
        if a:window_entry == s:current_win
            call PluginPermissiveTemp(a:window_entry)
        else
            call Close(-1)
            call PostClose(a:window_entry)
        endif
    else
        call Close(-1)
        call PostClose(a:window_entry)
    endif
endfunction

function! PluginFugitive(window_entry)
    if s:winlist[a:window_entry][1] =~# '.git/index' ||
        \s:winlist[a:window_entry][1] =~# 'index' &&
        \s:winlist[a:window_entry][4] =~# 'gitcommit' &&
        \s:winlist[a:window_entry][5] == 1
            call Close(a:window_entry)
            call PostClose(a:window_entry)
    endif
endfunction

function! PluginNERDTree(window_entry)
    if s:winlist[a:window_entry][1] =~# 'NERD_tree_'
        exec 'NERDTreeClose'
        call PostClose(a:window_entry)
    endif
endfunction

function! PluginHelp(window_entry)
    if s:winlist[a:window_entry][3] =~# 'help' &&
        \s:winlist[a:window_entry][5] == 1
            call Close(a:window_entry)
            call PostClose(a:window_entry)
    endif
endfunction

function! PluginTemp(window_entry)
    if s:winlist[a:window_entry][4] != 'nerdtree'
        if s:winlist[a:window_entry][3] =~# 'nowrite' ||
            \s:winlist[a:window_entry][3] =~# 'nofile' &&
            \s:winlist[a:window_entry][5] == 1 &&
            \s:winlist[a:window_entry][1] == '' &&
            \s:winlist[a:window_entry][4] == ''
                call Close(a:window_entry)
                call PostClose(a:window_entry)
        endif
    endif
endfunction

function! PluginPermissiveTemp(window_entry)
    if s:winlist[a:window_entry][4] != 'nerdtree'
        if s:winlist[a:window_entry][3] =~# 'nowrite' ||
            \s:winlist[a:window_entry][3] =~# 'nofile' ||
            \s:winlist[a:window_entry][3] == '' &&
            \s:winlist[a:window_entry][1] == ''
                call Close(a:window_entry)
                call PostClose(a:window_entry)
        endif
    else
        let s:reached_cursor = 1
    endif
endfunction

function! PluginQuickfix(window_entry)
    if s:winlist[a:window_entry][3] =~# 'quickfix' &&
        \s:winlist[a:window_entry][4] =~# 'qf'
            exec 'cclose'
            call PostClose(a:window_entry)
    endif
endfunction

function! PluginFugitiveDiff(window_entry)
    if s:winlist[a:window_entry][1] =~# '^fugitive:' &&
        \s:winlist[a:window_entry][6] == 1
            let diff_file = s:winlist[a:window_entry][1]
            let regular_file = split(
                \s:winlist[a:window_entry][1], 'git\/\/0\/\zs')[1]
            for window in range(winnr('$'))
                if s:winlist[window][1] == diff_file
                    let window += 1
                    exec window . 'wincmd w'
                    exec 'diffoff'
                    call Close(a:window_entry)
                    call PostClose(a:window_entry)
                    break
                endif
            endfor
            for window in range(winnr('$'))
                if s:winlist[window][1] == regular_file
                    exec s:winlist[window][0] . 'wincmd w'
                    exec 'diffoff'
                    break
                endif
            endfor
    endif
endfunction

function! PluginExplorer(window_entry)
    if s:winlist[a:window_entry][1] =~# 'NetrwTreeListing' &&
        \s:winlist[a:window_entry][4] == 'netrw'
            call Close(a:window_entry)
            call PostClose(a:window_entry)
    endif
endfunction
