# deoplete-rust

[![Join the chat at https://gitter.im/sebastianmarkow/deoplete-rust](https://badges.gitter.im/sebastianmarkow/deoplete-rust.svg)](https://gitter.im/sebastianmarkow/deoplete-rust?utm_source=badge&utm_medium=badge&utm_campaign=pr-badge&utm_content=badge)

[Neovim][neovim]/[Deoplete][deoplete] auto-completion source for [Rust][rust]
via [Racer][racer].


## Requirements
* [Rust][rust] source code
* [Racer][racer]
* [Deoplete][deoplete]

### Install Racer
#### with `cargo`
~~~
cargo install racer
~~~

#### from source
~~~
git clone https://github.com/phildawes/racer.git
cd racer
cargo build --release
~~~

Copy binary to `./target/release/racer` to location of your choosing.
(e.g. to `/usr/local/bin`)

### Get Rust source code
~~~
mkdir -p choose/a/path
git clone https://github.com/rust-lang/rust.git
~~~

### Add Deoplete
Add [Deoplete][deoplete] to `init.vim`.
For further details see [installation guide](https://github.com/Shougo/deoplete.nvim#installation)


## Install
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


## Configuration
Set `racer` binary path (fully qualified path)
~~~
let g:deoplete#sources#rust#racer_binary='/path/to/racer'
~~~

Set Rust source code path (when cloning from Github usually ending on `/src`)
~~~
let g:deoplete#sources#rust#rust_source_path='/path/to/rust/src'
~~~

To disable default key mappings (`gd` & `K`) add the following
~~~
let g:deoplete#sources#rust#disable_keymap=1
~~~


## Usage
### Default key mappings
These are the default key mappings
~~~
nmap <buffer> gd <plug>DeopleteRustGoToDefinitionDefault
nmap <buffer> K  <plug>DeopleteRustShowDocumentation
~~~

Additional methods to bind
~~~
DeopleteRustGoToDefinitionSplit  " Open definition in horizontal split
DeopleteRustGoToDefinitionVSplit " Open definition in vertical split
DeopleteRustGoToDefinitionTab    " Open definition in new tab
~~~

#### `gd` Go to definition
Jump to definition of the current element under the cursor.

#### `K` Show documentation
Show brief description of the current element under the cursor.

#### Show help
You don't have to remember it all. Just run `:help deoplete-rust`.

## License
deoplete-rust is licensed under MIT License.
For additional information, see `LICENSE` file.

[racer]: https://github.com/phildawes/racer
[neovim]: https://github.com/neovim/neovim
[deoplete]: https://github.com/Shougo/deoplete.nvim
[rust]: https://github.com/rust-lang/rust
