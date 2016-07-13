# deoplete-rust

[![Build Status](http://img.shields.io/travis/sebastianmarkow/deoplete-rust/master.svg?style=flat-square)](https://travis-ci.org/sebastianmarkow/deoplete-rust)

[Neovim][neovim]/[Deoplete][deoplete] auto-completion source for [Rust][rust].


## Requirements

* [Rust][rust] source
* [Racer][racer]
* [Deoplete][deoplete]

#### Install [Racer][racer]
##### with `cargo`
    cargo install racer

Be sure that your cargo directory (e.g. `~/.cargo/bin`) is in your `PATH`.
##### from source
    git clone https://github.com/phildawes/racer.git
    cd racer
    cargo build --release

Then add racer to your `PATH`.
e.g. copy `./target/release/racer` to `/usr/local/bin`

#### Get [Rust][rust] source
    mkdir -p choose/a/path
    git clone https://github.com/rust-lang/rust.git

## Install
Add [Deoplete][deoplete] to `init.vim`
See [installation guide](https://github.com/Shougo/deoplete.nvim#installation)

#### with `Vundle`
    Plugin 'sebastianmarkow/deoplete-rust'

#### with `vim-plug`
    Plug 'sebastianmarkow/deoplete-rust'

#### with `NeoBundle`
    NeoBundle 'sebastianmarkow/deoplete-rust'

## Configuration
#### Path
#### Keymap

## Usage
#### Keymap

##### `K` Show documentation

##### `gd` Go to definition

##### `:help deoplete-rust` Show help


[racer]: https://github.com/phildawes/racer
[neovim]: https://github.com/neovim/neovim
[deoplete]: https://github.com/Shougo/deoplete.nvim
[rust]: https://github.com/rust-lang/rust
