scriptencoding utf-8

if exists("b:current_syntax")
    finish
endif

if !exists('main_syntax')
    let main_syntax = 'rustdoc'
endif

runtime! syntax/html.vim
unlet! b:current_syntax

syntax sync minlines=10
syntax case ignore

syntax match markdownLineStart "^[<@]\@!" nextgroup=@markdownBlock

syntax cluster markdownBlock contains=markdownH1,markdownH2,markdownH3,markdownH4,markdownH5,markdownH6,markdownBlockquote,markdownListMarker,markdownOrderedListMarker,markdownCodeBlock,markdownRule
syntax cluster markdownInline contains=markdownLineBreak,markdownLinkText,markdownItalic,markdownBold,markdownCode,markdownEscape,markdownError

syntax match markdownH1 "^.\+\n=\+$" contained contains=@markdownInline,markdownHeadingRule,markdownAutomaticLink
syntax match markdownH2 "^.\+\n-\+$" contained contains=@markdownInline,markdownHeadingRule,markdownAutomaticLink

syntax match markdownHeadingRule "^[=-]\+$" contained

syntax region markdownH1 matchgroup=markdownHeadingDelimiter start="##\@!"      end="#*\s*$" keepend oneline contains=@markdownInline,markdownAutomaticLink contained
syntax region markdownH2 matchgroup=markdownHeadingDelimiter start="###\@!"     end="#*\s*$" keepend oneline contains=@markdownInline,markdownAutomaticLink contained
syntax region markdownH3 matchgroup=markdownHeadingDelimiter start="####\@!"    end="#*\s*$" keepend oneline contains=@markdownInline,markdownAutomaticLink contained
syntax region markdownH4 matchgroup=markdownHeadingDelimiter start="#####\@!"   end="#*\s*$" keepend oneline contains=@markdownInline,markdownAutomaticLink contained
syntax region markdownH5 matchgroup=markdownHeadingDelimiter start="######\@!"  end="#*\s*$" keepend oneline contains=@markdownInline,markdownAutomaticLink contained
syntax region markdownH6 matchgroup=markdownHeadingDelimiter start="#######\@!" end="#*\s*$" keepend oneline contains=@markdownInline,markdownAutomaticLink contained

syntax match markdownBlockquote ">\%(\s\|$\)" contained nextgroup=@markdownBlock

syntax region markdownCodeBlock start="    \|\t" end="$" contained

syntax match markdownListMarker "\%(\t\| \{0,4\}\)[-*+]\%(\s\+\S\)\@=" contained
syntax match markdownOrderedListMarker "\%(\t\| \{0,4}\)\<\d\+\.\%(\s\+\S\)\@=" contained

syntax match markdownRule "\* *\* *\*[ *]*$" contained
syntax match markdownRule "- *- *-[ -]*$" contained

syntax match markdownLineBreak " \{2,\}$"

syntax region markdownIdDeclaration matchgroup=markdownLinkDelimiter start="^ \{0,3\}!\=\[" end="\]:" oneline keepend nextgroup=markdownUrl skipwhite
syntax match markdownUrl "\S\+" nextgroup=markdownUrlTitle skipwhite contained
syntax region markdownUrl matchgroup=markdownUrlDelimiter start="<" end=">" oneline keepend nextgroup=markdownUrlTitle skipwhite contained
syntax region markdownUrlTitle matchgroup=markdownUrlTitleDelimiter start=+"+ end=+"+ keepend contained
syntax region markdownUrlTitle matchgroup=markdownUrlTitleDelimiter start=+'+ end=+'+ keepend contained
syntax region markdownUrlTitle matchgroup=markdownUrlTitleDelimiter start=+(+ end=+)+ keepend contained

syntax region markdownLinkText matchgroup=markdownLinkTextDelimiter start="!\=\[\%(\_[^]]*]\%( \=[[(]\)\)\@=" end="\]\%( \=[[(]\)\@=" nextgroup=markdownLink,markdownId skipwhite contains=@markdownInline,markdownLineStart
syntax region markdownLink matchgroup=markdownLinkDelimiter start="(" end=")" contains=markdownUrl keepend contained
syntax region markdownId matchgroup=markdownIdDelimiter start="\[" end="\]" keepend contained
syntax region markdownAutomaticLink matchgroup=markdownUrlDelimiter start="<\%(\w\+:\|[[:alnum:]_+-]\+@\)\@=" end=">" keepend oneline

execute 'syntax region markdownItalic matchgroup=markdownItalicDelimiter start="\S\@<=\*\|\*\S\@=" end="\S\@<=\*\|\*\S\@=" keepend contains=markdownLineStart concealends'
execute 'syntax region markdownItalic matchgroup=markdownItalicDelimiter start="\S\@<=_\|_\S\@=" end="\S\@<=_\|_\S\@=" keepend contains=markdownLineStart concealends'
execute 'syntax region markdownBold matchgroup=markdownBoldDelimiter start="\S\@<=\*\*\|\*\*\S\@=" end="\S\@<=\*\*\|\*\*\S\@=" keepend contains=markdownLineStart,markdownItalic concealends'
execute 'syntax region markdownBold matchgroup=markdownBoldDelimiter start="\S\@<=__\|__\S\@=" end="\S\@<=__\|__\S\@=" keepend contains=markdownLineStart,markdownItalic concealends'
execute 'syntax region markdownBoldItalic matchgroup=markdownBoldItalicDelimiter start="\S\@<=\*\*\*\|\*\*\*\S\@=" end="\S\@<=\*\*\*\|\*\*\*\S\@=" keepend contains=markdownLineStart concealends'
execute 'syntax region markdownBoldItalic matchgroup=markdownBoldItalicDelimiter start="\S\@<=___\|___\S\@=" end="\S\@<=___\|___\S\@=" keepend contains=markdownLineStart concealends'

syntax region markdownCode matchgroup=markdownCodeDelimiter start="`" end="`" keepend contains=markdownLineStart
syntax region markdownCode matchgroup=markdownCodeDelimiter start="`` \=" end=" \=``" keepend contains=markdownLineStart
syntax region markdownCode matchgroup=markdownCodeDelimiter start="^\s*```*.*$" end="^\s*```*\ze\s*$" keepend

syntax match markdownFootnote "\[^[^\]]\+\]"
syntax match markdownFootnoteDefinition "^\[^[^\]]\+\]:"

syntax match markdownEscape "\\[][\\`*_{}()<>#+.!-]"
syntax match markdownError "\w\@<=_\w\@="

highlight def link markdownH1                    htmlH1
highlight def link markdownH2                    htmlH2
highlight def link markdownH3                    htmlH3
highlight def link markdownH4                    htmlH4
highlight def link markdownH5                    htmlH5
highlight def link markdownH6                    htmlH6
highlight def link markdownHeadingRule           markdownRule
highlight def link markdownHeadingDelimiter      Delimiter
highlight def link markdownOrderedListMarker     markdownListMarker
highlight def link markdownListMarker            htmlTagName
highlight def link markdownBlockquote            Comment
highlight def link markdownRule                  PreProc

highlight def link markdownFootnote              Typedef
highlight def link markdownFootnoteDefinition    Typedef

highlight def link markdownLinkText              htmlLink
highlight def link markdownIdDeclaration         Typedef
highlight def link markdownId                    Type
highlight def link markdownAutomaticLink         markdownUrl
highlight def link markdownUrl                   Float
highlight def link markdownUrlTitle              String
highlight def link markdownIdDelimiter           markdownLinkDelimiter
highlight def link markdownUrlDelimiter          htmlTag
highlight def link markdownUrlTitleDelimiter     Delimiter

highlight def link markdownItalic                htmlItalic
highlight def link markdownItalicDelimiter       markdownItalic
highlight def link markdownBold                  htmlBold
highlight def link markdownBoldDelimiter         markdownBold
highlight def link markdownBoldItalic            htmlBoldItalic
highlight def link markdownBoldItalicDelimiter   markdownBoldItalic
highlight def link markdownCodeDelimiter         Delimiter

highlight def link markdownEscape                Special
highlight def link markdownError                 Error

let b:current_syntax = 'rustdoc'
if main_syntax ==# 'rustdoc'
    unlet main_syntax
endif
