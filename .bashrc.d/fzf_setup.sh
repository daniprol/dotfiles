
# Load FZF keybindings (CTRL-T, CTRL-R, ALT-C)
[ -f /usr/share/fzf/shell/key-bindings.bash ] && source /usr/share/fzf/shell/key-bindings.bash

# FZF DEFAULT COMMANDS
#export FZF_DEFAULT_COMMAND='rg --files --no-ignore --hidden --follow --glob "!{.git,node_modules,.venv,venv}/*"'
FD_OPTIONS="--hidden --follow --exclude .git --exclude node_modules --exclude venv --exclude .venv"

# Preview options
#PREVIEW_OPTIONS="--preview 'bat --color=always --style=numbers --line-range=:200 {}'"
preview_options="[[ \$(file --mime {}) =~ binary ]] && echo {} is a binary file || (bat --style=numbers --color=always --line-range=:200 {} || cat {}) 2> /dev/null"

# IMPORTANT: dont use "bat" in FZF_DEFAULT_OPTS or FZF won't work when searching anything other than files!
export FZF_DEFAULT_OPTS="--height 50% -1 --layout=reverse-list --multi --preview=\"${preview_options}\""
#export FZF_DEFAULT_OPTS="--no-mouse --height 50% -1 --reverse --multi --inline-info --preview='[[ \$(file --mime {}) =~ binary ]] && echo {} is a binary file || (bat --style=numbers --color=always {} || cat {}) 2> /dev/null | head -300' --preview-window='right:hidden:wrap' --bind='f3:execute(bat --style=numbers {} || less -f {}),f2:toggle-preview,ctrl-d:half-page-down,ctrl-u:half-page-up,ctrl-a:select-all+accept,ctrl-y:execute-silent(echo {+} | pbcopy),ctrl-x:execute(rm -i {+})+abort'"
#
# Use git-ls-files inside git repo, otherwise fd
export FZF_DEFAULT_COMMAND="git ls-files --cached --others --exclude-standard || fd --type f --type l $FD_OPTIONS"
export FZF_CTRL_T_COMMAND="fd $FD_OPTIONS"
export FZF_ALT_C_COMMAND="fd --type d $FD_OPTIONS"


# Configure fzf, command line fuzzyf finder
#export FZF_DEFAULT_OPTS="--no-mouse --height 50% -1 --reverse --multi --inline-info --preview='[[ \$(file --mime {}) =~ binary ]] && echo {} is a binary file || (bat --style=numbers --color=always {} || cat {}) 2> /dev/null | head -300' --preview-window='right:hidden:wrap' --bind='f3:execute(bat --style=numbers {} || less -f {}),f2:toggle-preview,ctrl-d:half-page-down,ctrl-u:half-page-up,ctrl-a:select-all+accept,ctrl-y:execute-silent(echo {+} | pbcopy),ctrl-x:execute(rm -i {+})+abort'"

