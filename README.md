# popwindow.vim

PopWindow will quickly close what seems to be the newest window that just popped
up. Closing just one window upon invocation, it first finds windows with
non-normal buffers (nofile, nowrite, etc.,) to close, then it closes help
windows second.

If only normal buffers exist, PopWindow will close the window with the highest
ID number (i.e. the bottom-most window).

This is helpful for plugins that pop-up docs or other temporary buffer/read-in
windows.  Mapping it to `nnoremap <C-w><BS> :PopWindow<CR>` seemed very
intuitive to me.

## Installation

I personally use [Vundle](https://github.com/gmarik/vundle) for my plugin
management, but PopWindow should work just fine with
[Pathogen](https://github.com/tpope/vim-pathogen) and other plugin managers or
even dropping it directly into your `vim/plugin` folder.

## Contribution
I'm very new to Vim script. Contributions and suggestions are very welcome.
Feel free to post them in the [wiki][1].

[1]: https://github.com/brianclements/vim-popwindow/wiki

## License
The MIT License. See the [License][2] file for details.

[2]: https://github.com/brianclements/vim-popwindow/blob/master/LICENSE "LICENSE"

## Credits
PopWindow borrows from [helpclose.vim][3] by Muraoka Taro.

[3]: http://www.vim.org/scripts/script.php?script_id=595
