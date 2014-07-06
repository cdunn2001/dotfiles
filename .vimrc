set modelines=1
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

autocmd FileType gitconfig setl noexpandtab ts=4 sw=4 autocmd FileType ruby setl expandtab ts=2 sw=2 tw=80 autocmd FileType python setl expandtab ts=4 sts=4 sw=4 tw=80 autocmd FileType cpp setl expandtab ts=2 sts=2 sw=2 tw=0 autocmd FileType java setl expandtab ts=4 sw=4 tw=80 autocmd FileType makefile setl noexpandtab

:au BufWinEnter * checktime
" http://stackoverflow.com/questions/923737/detect-file-change-offer-to-reload-file

"filetype plugin on

" automatic reload .vimrc on change
autocmd! bufwritepost .vimrc source %

"colorscheme pablo

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
