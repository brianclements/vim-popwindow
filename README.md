# popwindow.vim

PopWindow is a workflow plugin that allows one to easily close windows based on
pre-defined criteria, in the order they please, and wherever that window might
be located on their current tab so that they don't have to futz with getting
their cursor in the correct window before closing it. This criteria is based on
things like filename, buftype, filetype, and readonly status.

This plugin was made for plugins and helper functions that frequently pop-up
docs, command output, or other temporary windows. Now they can be closed just as
easily as they arrived.

Built-in types include:

* fugitive
    * `:Gstatus` window showing the contents of `.git/index`
* fugitive-diff
    * The simple `:Gdiff` window showing the difference between the current file and the
      staged changes. This does not work in compounded `:Gdiff` situations where
      you start to diff against multiple versions of the history. 
* help
    * The standard vim help window
* quickfix
* temp
    * a more general category that includes the 'nofile' and 'nowrite' buftypes,
      and files with no filename and no filetype
* permissive_temp
    * a more leniant version of temp that allows for more "or" situations for 
      the 'temp' conditions instead of 'and'.
* nerdtree

## Configuration
You can enable/disable certain types and set the closure order in your vimrc
(this is the default setting):

```
let g:popwindow_close_types = [
    \'fugitive-diff', 'fugitive', 'help',
    \'quickfix', 'temp', 'permissive_temp', 'nerdtree']
```

On invocation of the plugin, the setting above will close 'fugitive-diff'
windows first. On next invocation, it will close the 'fugitive' windows next,
and so on. One closure will occur upon each invocation.

Include the types you want in this setting, omit the ones you don't, and set the
order you desire. If applicable, each type has it's own criteria and special
instructions for matching and closing the window of that type so that they are
handled properly; 'nerdtree' is closed with `NERDTreeClose`, 
'quickfix' is closed with `ccl`, and 'fugitive-diff' will `diffoff` the windows
before closing for example.


You can select whether to close the buffer itself or just the window by setting 
either 'buffer' or 'window' here (default value is 'buffer'):

`let g:popwindow_close_method = 'buffer'` 

For extreme cases of window proliferation, you can tell PopWindow to close all
instances of each window type upon invocation, not just one at a time (default
value is '0', disabled):

`let g:popwindow_zealous_close = 1`

Since all but the 'temp' window type typically produces only one window anyway,
you will only really notice this for 'temp' types.

When these pre-defined types no longer exist on your tab, PopWindow will start
to close the window with the highest ID number (i.e. the bottom-most-right
window). The default value is '1', enabled:

`let g:popwindow_pop_normal = 1`

Lastly, we can tell PopWindow to ignore buffers that have been modified and
close them anyway. This setting is relatively safe because modifying buffers
doesn't change the criteria upon with we decide to close a window, but caution
should still be used when using with "Zealous Close". This option is enabled by
default:

`let g:popwindow_ignore_modified_buffers = 1`

## Key-Mapping

Mapping it to `nnoremap <C-w><BS> :PopWindow<CR>` seemed very intuitive to me.

## Installation

I personally use [Vundle](https://github.com/gmarik/vundle) for my plugin
management, but PopWindow should work just fine with
[Pathogen](https://github.com/tpope/vim-pathogen) and other plugin managers or
even dropping it directly into your `vim/plugin` folder.

## Contribution

Contributions and suggestions are very welcome. PopWindow has a plugin system
for defining the window types, so it is very easy to extend it. Feel free to
request new types or suggest better criteria for discerning any existing type.

## License
The MIT License. See the [License](LICENSE) file for details.
