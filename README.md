# vim-filefinder

Quickly find and manage files based on the system's find command.

## Installation

[vim-plug](https://github.com/junegunn/vim-plug)
```vim
Plug 'quanhengzhuang/vim-filefinder'
```

[Vundle](https://github.com/VundleVim/Vundle.vim)
```vim
Plugin 'quanhengzhuang/vim-filefinder'
```

## Features

* File find: Quickly display all files in the pwd directory.
* File management: Quickly copy, move, and delete files.

## Usage

The following shortcuts are recommended.

```vim
map <leader>e :call FindInTaglistHere()<CR>
map E :call FindInTaglistInsightHere()<CR>
```
