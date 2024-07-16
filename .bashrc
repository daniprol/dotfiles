# .bashrc

# Source global definitions
if [ -f /etc/bashrc ]; then
	. /etc/bashrc
fi

# User specific environment
if ! [[ "$PATH" =~ "$HOME/.local/bin:$HOME/bin:" ]]
then
    PATH="$HOME/.local/bin:$HOME/bin:$PATH"
fi
export PATH

export EDITOR="nvim"
export BROWSER="firefox"

# don't put duplicate lines or lines starting with space in the history.
# See bash(1) for more options
HISTCONTROL=ignoreboth

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=10000
HISTFILESIZE=20000


# Uncomment the following line if you don't like systemctl's auto-paging feature:
# export SYSTEMD_PAGER=

# User specific aliases and functions
if [ -d ~/.bashrc.d ]; then
	for rc in ~/.bashrc.d/*; do
		if [ -f "$rc" ]; then
			. "$rc"
		fi
	done
fi

unset rc

# Alias definitions.
# You may want to put all your additions into a separate file like
# ~/.bash_aliases, instead of adding them here directly.
# See /usr/share/doc/bash-doc/examples in the bash-doc package.

if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi

# Check if it is a login or non-login shell
# shopt -q login_shell && echo 'Login shell' || echo 'Not login shell'



# Starship prompt
eval "$(starship init bash)"

# Use bat as default formatter for man pages
export MANPAGER="sh -c 'col -bx | bat -l man -p'"
export MANROFFOPT="-c"


# Source scripts with git+fzf integration
#git_fzf_script=~/Scripts/git_fzf.sh
git_sanix=~/Scripts/git_sanix.sh
if [[ -f $git_sanix && -x $git_sanix ]]; then
	# echo "Sourcing $git_sanix"
	. $git_sanix
fi


export NVM_DIR="$HOME/.config/nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion


## NEOVIM CONFIG SWITCHER
function nvims() {
	items=("default" "vanilla" "kickstart" "LazyVim" "NvChad" "AstroNvim" "ThePrimeagen")
	config=$(printf "%s\n" ${items[@]} | fzf --prompt="Neovim config: " --height=20% --layout=reverse --border --exit-0)

	if [[ -z $config ]]; then
		echo "Nothing selected"
		return 0
	elif [[ $config == "vanilla" ]]; then
		nvim --clean $@
	elif [[ $config == "default" ]]; then
		config=""
		NVIM_APPNAME=$config nvim $@
	else
		NVIM_APPNAME=$config nvim $@
	fi

}

# bind -x '"\C-a":"nvims"'
# source ~/Scripts/tmux-sessionizer.sh
# bind -s ^f "tmux-sessionizer\n"
bind -x '"\C-a":"tmux-sessionizer"'


# To use with: openapi-python-client generate --path /localpath/to/openapi.json
# source /home/daniprol/.bash_completions/openapi-python-client.sh
