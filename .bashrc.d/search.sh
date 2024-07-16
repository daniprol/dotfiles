
function f() {
  : '
  Open a file directly in neovim
  '
  if ! command -v fd 2&> /dev/null; then
    echo "fd needs to be installed for this function to run"
    return 1
  fi

  local directories=("node_modules" "venv" ".venv" "envs" "pkgs" ".git")


  local ignore_file="$HOME/.ignore"
  if [[ -f "$ignore_file" ]]; then
    # NOTE: to specify a different directory ($search_path) we need to pass a wildcard "."
    # NOTE: notice the -u --unrestricted (== -HI )
    local fd_command="fd -u -t f --ignore-file $ignore_file . $HOME"
  else
    local directories=("node_modules" "venv" ".venv" "envs" "pkgs" ".git")
    local exclude=""

    for directory in "${directories[@]}"; do
      exclude+="--exclude $directory"
    done

    local fd_command="fd -u -t f $exclude . $HOME"
  fi

    
  # TODO: why doesn't this work if used in the command?
  # local fzf_command="fzf --preview=\"\""

  # Declare first to avoid returning always a 0 code
  local files 
  # NOTE: -m for multiselect should be the default
  # NOTE: we are using an array!

  # NOTE: modify IFS to split by newline instead of space
  # IFS=$'\n'
  # files=($(fd . --type f --type l "${@:2}" | fzf -0 -1 -m))
  # List of files separated by newline
  picked_files=$($fd_command |  fzf -m )

  IFS=$'\n'
  # List of files separated by space
  files=($picked_files)
  IFS=$' '

  # Check string is non-empty
  [[ -n "$files" ]] && $EDITOR "${files[@]}" || return 1
}

function d() {
  : '
  CD into a directory
  '

  local search_path="$HOME"
  local ignore_file="$HOME/.ignore"
  if [[ -f "$ignore_file" ]]; then
    local exclude="--ignore-file $ignore_file"
  else
    local dirs=("node_modules" "venv" ".venv" "virtualenvs" "pkgs" ".git" "envs", "virtualenv")
    IFS=$' '
    local exclude="--exclude ${dirs[@]}"
  fi

  local preview_command="lsd -l --color=always --group-directories-first {}"
  local lsd_blocks="--blocks permission --blocks size  --blocks date --blocks name --date relative"
  local preview_command="lsd -lhA --color=always --group-directories-first $lsd_blocks {}"
  local directory
  directory=$(fd -u -t d $exclude . "$search_path" | fzf -m 1 --preview="$preview_command")
  [[ -n "$directory" ]] && cd "$directory" || return 1
}


function ntodos() {
  : '
  Open all TODOS|FIXME of the current project in neovim quickfix list
  '
  if ! command -v rg 2&> /dev/null; then
    echo "ripgrep needs to be installed to run this function"
    return 1
  fi

  local ignore_file="$HOME/.ignore"
  # NOTE: by default ripgrep ignores hidden files, binaries and directories listed in .gitignore and .ignore so we should not need the .ignore file.
  # Notice that because we are using --hidden we need to make sure that ".git" is also ignored in the .ignore file, otherwise it will be searched
  # -q to open errors
  # --vimgrep to output quickfix list format supported by neovim
  #
  $EDITOR -q <(rg --vimgrep --hidden --ignore-file "$ignore_file" -i "TODO|FIXME")
}

function todos() {
  : '
  Just pretty-print all TODOS|FIXME of the current project.
  '
  # NOTE: project .gitignore will be used in this case
  # TODO: check if .git files are being searched if .git is not included in .gitignore
  rg --hidden -i "TODO|FIXME"
}

