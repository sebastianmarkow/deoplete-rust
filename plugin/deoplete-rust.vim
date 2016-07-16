if exists('g:loaded_deoplete_rust')
    finish
endif
let g:loaded_deoplete_rust=1

let s:save_cpoptions = &cpoptions
set cpoptions&vim

let g:deoplete#sources#rust#racer_binary=
    \ get(g:, 'deoplete#sources#rust#racer_binary', '')

let g:deoplete#sources#rust#rust_source_path=
    \ get(g:, 'deoplete#sources#rust#rust_source_path', '')

function! s:jumpTo(mode, filename, line_nr, column_nr)
    if a:mode ==# 'tab'
        if bufloaded(a:filename) == 0
            tab split
        endif
    elseif a:mode ==# 'split'
        split
    elseif a:mode ==# 'vsplit'
        vsplit
    elseif bufloaded(a:filename) != 0 && bufwinnr(a:filename) != -1
        execute bufwinnr(a:filename) . 'wincmd w'
    endif

    exec 'edit '.a:filename
    call cursor(a:line_nr, a:column_nr)

    normal! zz
endfunction

function! s:DeopleteRustShowDocumentation()
    call s:warn('show: documentation')
endfunction

function! s:DeopleteRustGoToDefinition(mode)
    if s:checkEnv()
        return
    endif
    let l:line_nr = line('.')
    let l:column_nr = col('.')
    let l:filename = expand('%:p')
    let l:buf = tempname()

    call writefile(getline(1, '$'), l:buf)

    let l:cmd = g:deoplete#sources#rust#racer_binary.' find-definition '.l:line_nr.' '.l:column_nr.' '.l:filename.' '.l:buf
    let l:result = system(l:cmd)

    for l:line in split(l:result, '\\n')
        if l:result =~# ' error: ' && l:line !=? 'end'
            call s:warn(l:line)
            break
        elseif l:line =~? '^MATCH'
            let l:info = split(l:line[6:], ',')
            let l:line_nr = l:info[1]
            let l:column_nr = l:info[2]
            let l:filename = l:info[3]

            call s:jumpTo(a:mode, l:filename, l:line_nr, l:column_nr+1)
            break
        endif
    endfor
    call delete(l:buf)
endfunction

function! s:warn(message)
    echohl WarningMsg | echomsg a:message | echohl NONE
endfunction

function! s:checkEnv()
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
        \ :call <sid>DeopleteRustGoToDefinition('')<cr>
    nnoremap <silent><buffer> <plug>DeopleteRustGoToDefinitionSplit
        \ :call <sid>DeopleteRustGoToDefinition('split')<cr>
    nnoremap <silent><buffer> <plug>DeopleteRustGoToDefinitionVSplit
        \ :call <sid>DeopleteRustGoToDefinition('vsplit')<cr>
    nnoremap <silent><buffer> <plug>DeopleteRustGoToDefinitionTab
        \ :call <sid>DeopleteRustGoToDefinition('tab')<cr>
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

let &cpoptions = s:save_cpoptions
unlet s:save_cpoptions
