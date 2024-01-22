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


# Plots with GNUPLOT
# Example use: >> iplot 'sin(x*3)*exp(x*.2)'

function iplot {
    cat <<EOF | gnuplot
    set terminal pngcairo enhanced font 'Fira Sans,10'
    set autoscale
    set samples 1000
    set output '|kitty +kitten icat --stdin yes'
    set object 1 rectangle from screen 0,0 to screen 1,1 fillcolor rgb"#fdf6e3" behind
    plot $@
    set output '/dev/null'
EOF
}

# Unzip my_file.zip into my_file directory
unzd() {
    if [[ $# != 1 ]]; then echo I need a single argument, the name of the archive to extract; return 1; fi
    target="${1%.zip}"
    unzip "$1" -d "${target##*/}"
}

# Starship prompt
eval "$(starship init bash)"

# Use bat as default formatter for man pages
export MANPAGER="sh -c 'col -bx | bat -l man -p'"
export MANROFFOPT="-c"

# Load FZF keybindings (CTRL-T, CTRL-R, ALT-C)
[ -f /usr/share/fzf/shell/key-bindings.bash ] && source /usr/share/fzf/shell/key-bindings.bash

# FZF DEFAULT COMMANDS
# It's better to use fd than ripgrep to search for files!
#export FZF_DEFAULT_COMMAND='rg --files --no-ignore --hidden --follow --glob "!{.git,node_modules,.venv,venv}/*"'
FD_OPTIONS="--hidden --follow --exclude .git --exclude node_modules --exclude venv --exclude .venv"

# Preview options
#PREVIEW_OPTIONS="--preview 'bat --color=always --style=numbers --line-range=:200 {}'"

# IMPORTANT: dont use "bat" in FZF_DEFAULT_OPTS or FZF won't work when searching anything other than files!
export FZF_DEFAULT_OPTS="--height 50% -1 --layout=reverse-list --multi --preview='[[ \$(file --mime {}) =~ binary ]] && echo {} is a binary file || (bat --style=numbers --color=always -style=numbers --line-range=:200 {} || cat {}) 2> /dev/null'"
#export FZF_DEFAULT_OPTS="--no-mouse --height 50% -1 --reverse --multi --inline-info --preview='[[ \$(file --mime {}) =~ binary ]] && echo {} is a binary file || (bat --style=numbers --color=always {} || cat {}) 2> /dev/null | head -300' --preview-window='right:hidden:wrap' --bind='f3:execute(bat --style=numbers {} || less -f {}),f2:toggle-preview,ctrl-d:half-page-down,ctrl-u:half-page-up,ctrl-a:select-all+accept,ctrl-y:execute-silent(echo {+} | pbcopy),ctrl-x:execute(rm -i {+})+abort'"
#
# Use git-ls-files inside git repo, otherwise fd
export FZF_DEFAULT_COMMAND="git ls-files --cached --others --exclude-standard || fd --type f --type l $FD_OPTIONS"
export FZF_CTRL_T_COMMAND="fd $FD_OPTIONS"
export FZF_ALT_C_COMMAND="fd --type d $FD_OPTIONS"


# Configure fzf, command line fuzzyf finder
#export FZF_DEFAULT_OPTS="--no-mouse --height 50% -1 --reverse --multi --inline-info --preview='[[ \$(file --mime {}) =~ binary ]] && echo {} is a binary file || (bat --style=numbers --color=always {} || cat {}) 2> /dev/null | head -300' --preview-window='right:hidden:wrap' --bind='f3:execute(bat --style=numbers {} || less -f {}),f2:toggle-preview,ctrl-d:half-page-down,ctrl-u:half-page-up,ctrl-a:select-all+accept,ctrl-y:execute-silent(echo {+} | pbcopy),ctrl-x:execute(rm -i {+})+abort'"

# If lsd is installed use it instead of builtin ls
# command -v lsd > /dev/null 2>&1 && alias ls='lsd'

# Alias
alias ls="lsd --group-directories-first"
alias ll="lsd -l --group-directories-first"
alias la="lsd -a --group-directories-first"
alias lla="lsd -la --group-directories-first"
alias lt="lsd --tree --group-directories-first"
alias cat="bat"
alias av="source venv/bin/activate"


# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    #alias dir='dir --color=auto'
    #alias vdir='vdir --color=auto'

    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

# Open Wezterm configuration
alias wezconfig="nvim ~/.config/wezterm/wezterm.lua"

# Function to perform math operations
# NOTE: you need to scape all parenthesis \( , so it is better to just pass the expression as a string
m() {
  python3 -c "from math import *; print($*)"
}

# Source scripts with git+fzf integration
#git_fzf_script=~/Scripts/git_fzf.sh
git_sanix=~/Scripts/git_sanix.sh
if [[ -f $git_sanix && -x $git_sanix ]]; then
	# echo "Sourcing $git_sanix"
	. $git_sanix
fi

### ARCHIVE EXTRACTION
# usage: ex <file>
ex ()
{
  if [ -f "$1" ] ; then
    case $1 in
      *.tar.bz2)   tar xjf $1   ;;
      *.tar.gz)    tar xzf $1   ;;
      *.bz2)       bunzip2 $1   ;;
      *.rar)       unrar x $1   ;;
      *.gz)        gunzip $1    ;;
      *.tar)       tar xf $1    ;;
      *.tbz2)      tar xjf $1   ;;
      *.tgz)       tar xzf $1   ;;
      *.zip)       unzip $1     ;;
      *.Z)         uncompress $1;;
      *.7z)        7z x $1      ;;
      *.deb)       ar x $1      ;;
      *.tar.xz)    tar xf $1    ;;
      *.tar.zst)   unzstd $1    ;;
      *)           echo "'$1' cannot be extracted via ex()" ;;
    esac
  else
    echo "'$1' is not a valid file"
  fi
}

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

## PYENV
export PYENV_ROOT="$HOME/.pyenv"
[[ -d $PYENV_ROOT/bin ]] && export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init -)"


### DOTFILES MANAGEMENT:
alias dotfiles="/usr/bin/git --git-dir=$HOME/.dotfiles --work-tree=$HOME"
