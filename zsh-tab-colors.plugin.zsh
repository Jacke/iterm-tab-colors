tcConfigFilePath="$(dirname "$0")/.tc-config"
declare -A tcConfigColors
declare -a orderedConfig
while IFS="=" read -r configKey hexValue || [ -n "$hexValue" ]; do
  if ! ( [[ $configKey == \#* ]]); then
    orderedConfig+=( $configKey )
    tcConfigColors[$configKey]+=$hexValue
  fi
done < $tcConfigFilePath

function directory_tab_color() {
  try_set_tab_color "$PWD"
}

function command_tab_color() {
  try_set_tab_color "$1"
}

function try_set_tab_color() {
  for k in $orderedConfig; do
    if ( [[ "$1" =~ "$k" ]] ); then
      iterm_tab_color "$tcConfigColors[$k]"
      return 0
    fi

    iterm_tab_color
  done
}

function iterm_tab_color() {
  if [ $# -eq 0 ]; then
    # Reset tab color if called with no arguments
    echo -ne "\033]6;1;bg;*;default\a"
    return 0
  elif [ $# -eq 1 ]; then
    if ( [[ $1 == \#* ]] ); then
      # If single argument starts with '#', skip first character to find hex value
      RED_HEX=${1:1:2}
      GREEN_HEX=${1:3:2}
      BLUE_HEX=${1:5:2}
    else
      # If single argument doesn't start with '#', assume it's hex value
      RED_HEX=${1:0:2}
      GREEN_HEX=${1:2:2}
      BLUE_HEX=${1:4:2}
    fi

    RED=$(( 16#${RED_HEX} ))
    GREEN=$(( 16#${GREEN_HEX} ))
    BLUE=$(( 16#${BLUE_HEX} ))

    echo -ne "\033]6;1;bg;red;brightness;$RED\a"
    echo -ne "\033]6;1;bg;green;brightness;$GREEN\a"
    echo -ne "\033]6;1;bg;blue;brightness;$BLUE\a"

    return 0
  fi

  # If more than 1 argument, assume 3 arguments were passed
  echo -ne "\033]6;1;bg;red;brightness;$1\a"
  echo -ne "\033]6;1;bg;green;brightness;$2\a"
  echo -ne "\033]6;1;bg;blue;brightness;$3\a"
}

alias tc='iterm_tab_color'
#preexec_functions=(${preexec_functions[@]} "command_tab_color")
#precmd_functions=(${precmd_functions[@]} "directory_tab_color")

function automatic_iterm_tab_color_cwd () {
#RES=`python -c "import random; import os; \
#             random.seed('red'   + os.getcwd()); a=(random.randint(0,255)+255); \
#             random.seed('green' + os.getcwd()); b=(random.randint(0,255)+255); \
#             random.seed('blue'  + os.getcwd()); c=(random.randint(0,255)+255); \
#             print(str(a)+' '+str(b)+' '+str(c));
#             "`
#RES=`echo $PWD | hexdump -ve '/1 "%02d"' | cut -c 1-3`
RES=`echo 0x$(echo -n "$PWD" | sha1sum | cut -d " " -f 1 | cut -c 1-5) | cut -c 1-5`
RES1=`echo 0x$(echo -n "$PWD" | sha1sum | cut -d " " -f 1 | cut -c 5-10) | cut -c 1-5`
RES2=`echo 0x$(echo -n "$PWD" | sha1sum | cut -d " " -f 1 | cut -c 10-15) | cut -c 1-5`
A=`echo $(($RES % 256))`
B=`echo $(($RES1 % 256))`
C=`echo $(($RES2 % 256))`

iterm_tab_color $A $B $C
}

#automatic_iterm_tab_color_cwd 
alias atc='automatic_iterm_tab_color_cwd'
#autoload -U add-zsh-hook
#add-zsh-hook chpwd automatic_iterm_tab_color_cwd 
