alias rm='rm -i'
alias cp='cp -i'
alias mv='mv -i'

# 'u 5' to go up 5 dirs
u() {
	set -A ud
	ud[1+${1-1}] =
	cd ${(j:../:)ud}
}

function git_current_branch() {
	git symbolic-ref HEAD 2> /dev/null | sed -e 's/refs\/heads\///'
}
function parse_git_branch() {
	git branch --no-color 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/\1/'
}
