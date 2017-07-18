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

let g:deoplete#sources#rust#documentation_max_height=
    \ get(g:, 'deoplete#sources#rust#documentation_max_height', 20)

let g:deoplete#sources#rust#show_duplicates=
    \ get(g:, 'deoplete#sources#rust#show_duplicates', 1)

let s:buffer_nr=-1

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

    " FIXME(SK): Throws error if buffer has been modified but changes
    " have not been written to disk yet
    exec 'edit '.a:filename
    call cursor(a:line_nr, a:column_nr)

    normal! zz
endfunction

function! s:formatDoc(text)
    let l:placeholder = '{LITERALSEMICOLON}'
    let l:line = substitute(a:text, '\\;', l:placeholder, 'g')
    let l:tokens = split(l:line, ';')
    let l:desc = substitute(substitute(substitute(substitute(get(l:tokens, 7, ''), '^\"\(.*\)\"$', '\1', ''), '\\\"', '\"', 'g'), '\\''', '''', 'g'), '\\n', '\n', 'g')
    let l:tokens = add(l:tokens[:6], l:desc)
    let l:tokens = map(copy(l:tokens), 'substitute(v:val, '''.l:placeholder.''', '';'', ''g'')')

    let l:doc = '# '.l:tokens[0].' ['.l:tokens[5].']: `'.l:tokens[6].'`'

    if l:tokens[7] !=# ''
        let l:doc = l:doc."\n\n".l:tokens[7]
    endif

    return l:doc
endfunction

function! s:openView(mode, position, content)
    if !bufexists(s:buffer_nr)
        execute a:mode
        sil file `='[RustDoc]'`
        let s:buffer_nr = bufnr('%')
    elseif bufwinnr(s:buffer_nr) == -1
        execute a:position
        execute s:buffer_nr . 'buffer'
    elseif bufwinnr(s:buffer_nr) != bufwinnr('%')
        execute bufwinnr(s:buffer_nr) . 'wincmd w'
    endif

    let l:max_height = g:deoplete#sources#rust#documentation_max_height
    let l:content_height = len(split(a:content, '\n'))

    if l:content_height > l:max_height
        execute 'resize '.l:max_height
    else
        execute 'resize '.l:content_height
    endif

    setlocal filetype=rustdoc
    setlocal bufhidden=delete
    setlocal buftype=nofile
    setlocal noswapfile
    setlocal nobuflisted
    setlocal nocursorline
    setlocal nocursorcolumn
    setlocal iskeyword+=:
    setlocal iskeyword-=-
    setlocal conceallevel=2
    setlocal concealcursor=nvic

    setlocal modifiable
    %delete _
    call append(0, split(a:content, '\n'))
    sil $delete _
    setlocal nomodifiable
    sil normal! gg

    noremap <buffer><silent>q :<c-u>close<cr>
    noremap <buffer><silent><cr> :<c-u>close<cr>
    noremap <buffer><silent><esc> :<c-u>close<cr>
endfunction

function! s:DeopleteRustShowDocumentation()
    if !s:validEnv()
        return
    endif

    let l:view = winsaveview()

    normal! he

    let l:line_nr = line('.')
    let l:column_nr = col('.')
    let l:path = expand('%:p')
    let l:buf = tempname()

    call writefile(getline(1, '$'), l:buf)

    let l:cmd = g:deoplete#sources#rust#racer_binary.' complete-with-snippet '.l:line_nr.' '.l:column_nr.' '.l:path.' '.l:buf
    let l:result = system(l:cmd)

    if v:shell_error
        echoerr l:result
        return
    endif

    call delete(l:buf)
    call winrestview(l:view)

    for l:line in split(l:result, "\\n")
        if l:result =~# 'ERROR:'
            call s:warn(l:line)
            break
        elseif l:line =~? '^MATCH'
            let l:content = s:formatDoc(l:line[6:])

            if l:content !=# ''
                call s:openView('new', 'split', l:content)
            endif
            break
       endif
    endfor
endfunction

function! s:DeopleteRustGoToDefinition(mode)
    if !s:validEnv()
        return
    endif

    let l:line_nr = line('.')
    let l:column_nr = col('.')
    let l:path = expand('%:p')
    let l:buf = tempname()

    call writefile(getline(1, '$'), l:buf)

    let l:cmd = g:deoplete#sources#rust#racer_binary.' find-definition '.l:line_nr.' '.l:column_nr.' '.l:path.' '.l:buf
    let l:result = system(l:cmd)

    if v:shell_error
        echoerr l:result
        return
    endif

    call delete(l:buf)

    for l:line in split(l:result, '\\n')
        if l:result =~# 'ERROR:'
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
endfunction

function! s:warn(message)
    echohl WarningMsg | echomsg a:message | echohl NONE
endfunction

function! s:validEnv()
    if !executable(g:deoplete#sources#rust#racer_binary)
        call s:warn('racer binary path not set (:help deoplete-rust)')
        return 0
    endif

    if !isdirectory($RUST_SRC_PATH)
        if !exists('g:deoplete#sources#rust#rust_source_path')
            call s:warn('rust source path not set (:help deoplete-rust)')
            return 0
        elseif !isdirectory(g:deoplete#sources#rust#rust_source_path)
            call s:warn('rust source path not set (:help deoplete-rust)')
            return 0
        else
            let $RUST_SRC_PATH=g:deoplete#sources#rust#rust_source_path
        endif
    endif

    return 1
endfunction

function! s:DeopleteRustInit()
    nnoremap <silent><buffer> <plug>DeopleteRustGoToDefinitionDefault
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
        nmap <buffer> gd <plug>DeopleteRustGoToDefinitionDefault
        nmap <buffer> K  <plug>DeopleteRustShowDocumentation
    endif
endfunction

augroup deoplete-rust
autocmd!
autocmd filetype rust call s:DeopleteRustInit()
augroup end

let &cpoptions = s:save_cpoptions
unlet s:save_cpoptions
