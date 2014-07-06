# emacs keyboard mode
#bindkey -e
#bindkey "\e[3~" delete-char
#bindeky '^?' backward-delete-char

# type -S in less to toggle line-truncation
export LESS=-eiRSXM
export RI="--format ansi"
export PYTHONRC=~/.pythonrc
export EDITOR=vim
export HISTCONTROL=ignoredups

source ~/.alias.sh
#PS1="\w\033[32m\]:\$(git_current_branch)\033[0m\]\n$ "
PS1="\W:\$(git_current_branch)$ "
PS1="\W\[\033[32m\]:\$(git_current_branch)\[\033[0m\]$ "

source ~/scripts/git-completion.bash
