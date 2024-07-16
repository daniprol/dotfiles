# Function to perform math operations
# NOTE: you need to scape all parenthesis \( , so it is better to just pass the expression as a string
math() {
  python3 -c "from math import *; print($*)"
}

# Unzip my_file.zip into my_file directory
unzd() {
    if [[ $# != 1 ]]; then echo I need a single argument, the name of the archive to extract; return 1; fi
    target="${1%.zip}"
    unzip "$1" -d "${target##*/}"
}

### ARCHIVE EXTRACTION
# usage: ex <file>
ex ()
{
  if [ -f "$1" ] ; then
    case $1 in
      *.tar.bz2)   tar xjf "$1"   ;;
      *.tar.gz)    tar xzf "$1"   ;;
      *.bz2)       bunzip2 "$1"   ;;
      *.rar)       unrar x "$1"   ;;
      *.gz)        gunzip "$1"    ;;
      *.tar)       tar xf "$1"    ;;
      *.tbz2)      tar xjf "$1"   ;;
      *.tgz)       tar xzf "$1"   ;;
      *.zip)       unzip "$1"     ;;
      *.Z)         uncompress "$1";;
      *.7z)        7z x "$1"      ;;
      *.deb)       ar x "$1"      ;;
      *.tar.xz)    tar xf "$1"    ;;
      *.tar.zst)   unzstd "$1"    ;;
      *)           echo "'$1' cannot be extracted via ex()" ;;
    esac
  else
    echo "'$1' is not a valid file"
  fi
}



# Plots with GNUPLOT
# Example use: >> iplot 'sin(x*3)*exp(x*.2)'

# FIXME: check if this only works with kitty terminal
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

