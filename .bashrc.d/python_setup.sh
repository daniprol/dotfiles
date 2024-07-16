#####  PYENV CONFIGURATION #####
export PYENV_ROOT="$HOME/.pyenv"
[[ -d $PYENV_ROOT/bin ]] && export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init -)"
eval "$(pyenv virtualenv-init -)"


##### MICROMAMBA CONFIGURATION #####
# !! Contents within this block are managed by 'mamba init' !!
export MAMBA_EXE='/home/daniprol/.local/bin/micromamba';
export MAMBA_ROOT_PREFIX='/home/daniprol/micromamba';
__mamba_setup="$("$MAMBA_EXE" shell hook --shell bash --root-prefix "$MAMBA_ROOT_PREFIX" 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__mamba_setup"
else
    alias micromamba="$MAMBA_EXE"  # Fallback on help from mamba activate
fi
unset __mamba_setup
# <<< mamba initialize <<<
alias mm="micromamba"
alias conda="micromamba"



# Pip install won't work outside a virtual environment
export PIP_REQUIRE_VIRTUALENV=true

# To install packages globally:
gpip() {
    PIP_REQUIRE_VIRTUALENV="" pip "$@"
}

function av() {
  : '
  Activate python virtual environment
  '
	if [ -d "venv" ]; then
		source "venv/bin/activate"
		echo "Activated virtual environment"
	elif [ -d ".venv" ]; then
		source ".venv/bin/activate"
		echo "Activated virtual environment"
	else
		echo "No virtual environment found"
	fi
}

