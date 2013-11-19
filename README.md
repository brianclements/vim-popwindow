# popwindow.vim

PopWindow will quickly close what seems to be the newest window that
just popped up. It first finds help windows and closes them. If none are
found, then it closes other windows with non-normal buffers that have not been
edited. Lastly, it closes the window with the highest ID number (i.e. the 
bottom-most window).

Helpful for plugins that pop-up docs or other temporary buffer/read-in windows. 
Mapping it to `nnoremap <C-w><BS> :PopWindow<CR>` seemed very intuitive to me.

## Installation

## Contribution
I'm very new to Vim script. Contributions and suggestions are very welcome.
Feel free to post them in the [wiki][1].

[1]: https://github.com/brianclements/vim-popwindow/wiki

## License
The MIT License. See the [License][2] file for details.

[2]: https://github.com/brianclements/vim-popwindow/blob/master/LICENSE "LICENSE"

## Credits
PopWindow borrows heavily from [helpclose.vim][3] by Muraoka Taro.

[3]: http://www.vim.org/scripts/script.php?script_id=595
