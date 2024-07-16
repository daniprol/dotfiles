### DOTFILES MANAGEMENT:
alias dotfiles="/usr/bin/git --git-dir=$HOME/.dotfiles --work-tree=$HOME"
# NOTE: this alias is overwritting the "dot" utility from graphviz
alias dot="dotfiles"

# Apparently using a function instead of alias, will get you bash-completion.
function dotadd {
	/usr/bin/git --git-dir=$HOME/.dotfiles --work-tree=$HOME add $@
}

# NOTE: using --cached will remove the file from the repository but not from the filesystem
function dotrm {
	/usr/bin/git --git-dir=$HOME/.dotfiles --work-tree=$HOME rm --cached $@
}
