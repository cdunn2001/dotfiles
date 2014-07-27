"""
"filetype plugin on
" Better:
" https://github.com/tpope/vim-pathogen
execute pathogen#infect()
filetype off
syntax on
filetype plugin indent on
"""

set modeline
set autoindent

"set list                " Show invisible whitespace
" To see \r as ^M, re-open in unix mode via
"   :e ++ff=unix
" This does not seem to work:
"   set ff=unix
" but to see ^M for CR, start vim with '-b'.

autocmd BufWinLeave *.* mkview
autocmd BufWinEnter *.* silent loadview
autocmd BufWinLeave *akefile mkview
autocmd BufWinEnter *akefile silent loadview "autocmd BufWinLeave * mkview "autocmd BufWinEnter * silent loadview " recommended by restore_view.vim:
" set viewoptions=cursor,folds,slash,unix

" Ammar's idea. But if you use this, remember to hit 'fg' at the end:
"set shell=/bin/bash\ -i

" This does not work for me:
"set shell=/bin/bash\ --rcfile\ ${HOME}/.bashrc " Nor these:
"set shellcmdflag=-i
"set shellcmdflag=-ic

set noignorecase
set smartcase
set textwidth=0         " Don't wrap words by default (ninjas use 80)

highlight ExtraWhitespace ctermbg=red guibg=gray "autocmd ColorScheme * highlight ExtraWhitespace ctermbg=red guibg=red match ExtraWhitespace /\t/

" show last column
"set colorcolumn=80

" Q: word-wrap
vmap Q gq
nmap Q gqap

" Tell vim to remember certain things when we exit "  '10  :  marks will be remembered for up to 10 previously edited files "  "100 :  will save up to 100 lines for each register "  :20  :  up to 20 lines of command-line history will be remembered
"  %    :  saves and restores the buffer list
"  n... :  where to save the viminfo files set viminfo='20,\"100,:20,%,n~/.viminfo
set backupdir=~/vimbackup

" http://vim.wikia.com/wiki/Restore_cursor_to_file_position_in_previous_editing_session
function! ResCur()
  if line("'\"") <= line("$")
    normal! g`"
    return 1
  endif
endfunction

augroup resCur
  autocmd!
  autocmd BufWinEnter * call ResCur()
augroup END

set nu

autocmd FileType gitconfig setl noexpandtab ts=4 sw=4
autocmd FileType ruby setl expandtab ts=2 sw=2 tw=80
autocmd FileType python setl expandtab ts=4 sts=4 sw=4 tw=80
"autocmd FileType cpp setl expandtab ts=2 sts=2 sw=2 tw=0
autocmd FileType java setl expandtab ts=4 sw=4 tw=80
autocmd FileType makefile setl noexpandtab

" Go
autocmd FileType go compiler go
autocmd FileType go autocmd BufWritePre <buffer> Fmt

:au BufWinEnter * checktime
" http://stackoverflow.com/questions/923737/detect-file-change-offer-to-reload-file

" automatic reload .vimrc on change
autocmd! bufwritepost .vimrc source %

" allow changing buffer without saving
set hidden
set confirm

" Nice idea from Sky!
colorscheme pablo

" For tmux background color problems
" Unfortunately, it seems to wreck colors completely.
"set term=screen

" Let :%y+ copy to clipboard.
" To paste -- "+p
set clipboard=unnamed

" same as :set paste
set pastetoggle=<F2>

"set mouse=a  " on OSX press ALT and click "set bs=2  " make backspace behave like normal again?

" do not lose selection per indent
vnoremap < <gv
vnoremap > >gv
set shiftround
" To reindent, =% with cursor on a curly.
" Or ggVG= for whole file.
" To unfold file, zR

au BufNewFile,BufRead *.h set filetype=cpp
" Detect if the current file type is a C-like language.
au BufNewFile,BufRead c,cpp,objc,*.mm call SetupForCLang()


""" https://code.google.com/p/chromiumembedded/wiki/VimConfiguration
" Configuration for C-like languages.
function! SetupForCLang()
    " Highlight lines longer than 80 characters.
    au BufWinEnter * let w:m2=matchadd('ErrorMsg', '\%>80v.\+', -1)
    " Alternately, uncomment these lines to wrap at 80 characters.
    " setlocal textwidth=80
    " setlocal wrap

    " Use 2 spaces for indentation.
    setlocal shiftwidth=2
    setlocal tabstop=2
    setlocal softtabstop=2
    setlocal expandtab

    " Configure auto-indentation formatting.
    setlocal cindent
    setlocal cinoptions=h1,l1,g1,t0,i4,+4,(0,w1,W4
    setlocal indentexpr=GoogleCppIndent()
    let b:undo_indent = "setl sw< ts< sts< et< tw< wrap< cin< cino< inde<"

    " Uncomment these lines to map F5 to the CEF style checker. Change the path to match your system.
    " map! <F5> <Esc>:!python ~/code/chromium/src/cef/tools/check_style.py %:p 2> lint.out<CR>:cfile lint.out<CR>:silent !rm lint.out<CR>:redraw!<CR>:cc<CR>
    " map  <F5> <Esc>:!python ~/code/chromium/src/cef/tools/check_style.py %:p 2> lint.out<CR>:cfile lint.out<CR>:silent !rm lint.out<CR>:redraw!<CR>:cc<CR>
endfunction

" From https://github.com/vim-scripts/google.vim/blob/master/indent/google.vim
function! GoogleCppIndent()
    let l:cline_num = line('.')

    let l:orig_indent = cindent(l:cline_num)

    if l:orig_indent == 0 | return 0 | endif

    let l:pline_num = prevnonblank(l:cline_num - 1)
    let l:pline = getline(l:pline_num)
    if l:pline =~# '^\s*template' | return l:pline_indent | endif

    " TODO: I don't know to correct it:
    " namespace test {
    " void
    " ....<-- invalid cindent pos
    "
    " void test() {
    " }
    "
    " void
    " <-- cindent pos
    if l:orig_indent != &shiftwidth | return l:orig_indent | endif

    let l:in_comment = 0
    let l:pline_num = prevnonblank(l:cline_num - 1)
    while l:pline_num > -1
        let l:pline = getline(l:pline_num)
        let l:pline_indent = indent(l:pline_num)

        if l:in_comment == 0 && l:pline =~ '^.\{-}\(/\*.\{-}\)\@<!\*/'
            let l:in_comment = 1
        elseif l:in_comment == 1
            if l:pline =~ '/\*\(.\{-}\*/\)\@!'
                let l:in_comment = 0
            endif
        elseif l:pline_indent == 0
            if l:pline !~# '\(#define\)\|\(^\s*//\)\|\(^\s*{\)'
                if l:pline =~# '^\s*namespace.*'
                    return 0
                else
                    return l:orig_indent
                endif
            elseif l:pline =~# '\\$'
                return l:orig_indent
            endif
        else
            return l:orig_indent
        endif

        let l:pline_num = prevnonblank(l:pline_num - 1)
    endwhile

    return l:orig_indent
endfunction

" For logging,
" vim -V9log.txt ...
