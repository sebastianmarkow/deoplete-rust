# deoplete-rust [![Gitter](https://img.shields.io/badge/chat-on%20gitter-11C19C.svg?style=flat-square)](https://gitter.im/sebastianmarkow/deoplete-rust?utm_source=badge&utm_medium=badge&utm_campaign=pr-badge)

[Neovim][neovim]/[Deoplete][deoplete] auto-completion source for [Rust][rust]
via [Racer][racer].

Auto-completion:
![Screenshot auto-completion](https://s31.postimg.org/yilwwkz5n/Bildschirmfoto_2016_07_22_um_21_56_36.png)

Documentation:
![Screenshot documentation](https://s31.postimg.org/aeezddlm3/Bildschirmfoto_2016_07_22_um_23_54_10.png)

## Requirements
* [Rust][rust] source code
* [Racer][racer] (>=2.0.0)
* [Deoplete][deoplete]

### Install Racer
#### with `cargo`
~~~
cargo install racer
~~~

#### from source
~~~
git clone https://github.com/phildawes/racer.git; cd racer
cargo build --release
~~~

Copy binary to `./target/release/racer` to a location of your choice.
(e.g. to `/usr/local/bin`)

### Get Rust source code
#### with `rustup`
~~~
rustup component add rust-src
~~~

#### from Git
~~~
mkdir -p choose/a/path
git clone --depth=1 https://github.com/rust-lang/rust.git
~~~

### Install Deoplete
For details see the [installation guide][installdeoplete]

## Installation
### with `vim-plug`
~~~
Plug 'sebastianmarkow/deoplete-rust'
~~~

### with `Vundle`
~~~
Plugin 'sebastianmarkow/deoplete-rust'
~~~

### with `NeoBundle`
~~~
NeoBundle 'sebastianmarkow/deoplete-rust'
~~~

### with `Pathogen`
~~~
git clone --depth=1 https://github.com/sebastianmarkow/deoplete-rust.git path/to/vim/bundle/deoplete-rust
~~~

## Configuration (`init.vim`)
Set fully qualified path to `racer` binary. If it is in your `PATH` already use
`which racer`. (__required__)
~~~
let g:deoplete#sources#rust#racer_binary='/path/to/racer'
~~~

Set Rust source code path (when cloning from Github usually ending on `/src`).
(__required__)
~~~
let g:deoplete#sources#rust#rust_source_path='/path/to/rust/src'
~~~

Show duplicate matches.
~~~
let g:deoplete#sources#rust#show_duplicates=1
~~~

To disable default key mappings (`gd` & `K`) add the following
~~~
let g:deoplete#sources#rust#disable_keymap=1
~~~

Set max height of documentation split.
~~~
let g:deoplete#sources#rust#documentation_max_height=20
~~~

## Usage
### Default key mappings
These are the default key mappings
~~~
nmap <buffer> gd <plug>DeopleteRustGoToDefinitionDefault
nmap <buffer> K  <plug>DeopleteRustShowDocumentation
~~~

Additional methods to bind

Method                             | Action
---                                | ---
`DeopleteRustGoToDefinitionSplit`  | Open definition in horizontal split
`DeopleteRustGoToDefinitionVSplit` | Open definition in vertical split
`DeopleteRustGoToDefinitionTab`    | Open definition in new tab

#### `gd` Go to definition
Jump to definition of the current element under the cursor.

#### `K` Show documentation
Show brief description of the current element under the cursor.
To close press either `q`, `cr` or `esc`.

#### Show help
You don't have to remember it all. Run `:help deoplete-rust`.

## License
deoplete-rust is licensed under MIT License.
For additional information, see `LICENSE` file.

[installdeoplete]: https://github.com/Shougo/deoplete.nvim#installation
[racer]: https://github.com/phildawes/racer
[neovim]: https://github.com/neovim/neovim
[deoplete]: https://github.com/Shougo/deoplete.nvim
[rust]: https://github.com/rust-lang/rust
