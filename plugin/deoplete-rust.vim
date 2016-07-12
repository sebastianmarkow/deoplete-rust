if exists('g:loaded_deoplete_rust')
    finish
endif
let g:loaded_deoplete_rust=1

let g:deoplete#sources#rust#racer_binary=
    \ get(g:, 'deoplete#sources#rust#racer_binary', '')

let g:deoplete#sources#rust#rust_source_path=
    \ get(g:, 'deoplete#sources#rust#rust_source_path', '')

let g:deoplete#sources#rust#cargo_path=
    \ get(g:, 'deoplete#sources#rust#cargo_path', '')

function! s:DeopleteRustShowDocumentation()
    call s:warn('yo!')
endfunction

function! s:DeopleteRustGoToDefinition()
    if s:check_env()
        return
    endif

    let line_nr = line('.')
    let column_nr = col('.')-1
    let filename = expand('%:p')
    let buf = tempname()

    call writefile(getline(1, '$'), buf)

    let cmd = g:deoplete#sources#rust#racer_binary.' find-definition '.
        \ line_nr.' '.column_nr.' '.filename.' '.buf
    let result = system(cmd)
    let lines = split(result, '\\n')

    for line in lines
        if result =~# ' error: ' && line !=# 'end'
            echom 'error'
        elseif line =~? '^MATCH'
            let info = split(line[6:], ',')
            let line_nr = info[1]
            let column_nr = info[2]
            let filename = info[3]

            echom 'go to: '.line_nr.' '.column_nr.' '.filename
            break
        endif
    endfor
    delete(buf)
endfunction

function! s:warn(message)
    echohl WarningMsg | echomsg a:message | echohl NONE
endfunction

function! s:check_env()
    if !executable(g:deoplete#sources#rust#racer_binary)
        call s:warn('racer binary not found')
        return 1
    endif

    if !isdirectory($RUST_SRC_PATH)
        if !exists('g:deoplete#sources#rust#rust_source_path')
            call s:warn('rust source not found')
            return 1
        else
            let $RUST_SRC_PATH=g:deoplete#sources#rust#rust_source_path
            return 0
        endif
    endif
endfunction

function! s:DeopleteRustInit()
    nnoremap <silent><buffer> <plug>DeopleteRustGoToDefinition
        \ :call <sid>DeopleteRustGoToDefintion()<cr>
    nnoremap <silent><buffer> <plug>DeopleteRustShowDocumentation
        \ :call <sid>DeopleteRustShowDocumentation()<cr>

    if !exists('g:deoplete#sources#rust#disable_keymap')
        nmap <buffer> gd <plug>DeopleteRustGoToDefinition
        nmap <buffer> K  <plug>DeopleteRustShowDocumentation
    endif
endfunction

augroup deoplete-rust
autocmd!
autocmd filetype rust call s:DeopleteRustInit()
augroup end
