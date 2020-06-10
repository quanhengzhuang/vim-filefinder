# filefinder.vim

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
map <leader>a :FinderFind<CR>
```

The key bindings in the filefinder buffer.
* `Enter` - Open the file in current window.
* `t` - Open the file in a new tab.
* `c` - Copy the file.
* `m` - Move the file.
* `d` - Delete the file.
* `r` - Refresh the filefinder buffer.
* `R` - Run the file.
* `q` - Quit the filefinder.
