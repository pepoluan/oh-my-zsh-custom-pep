# ys-pep Theme version 2, based on ys Theme by Yad Smood
#
# ----- BEGIN Original Description -----
#
# Clean, simple, compatible and meaningful.
# Tested on Linux, Unix and Windows under ANSI colors.
# It is recommended to use with a dark background.
# Colors: black, red, green, yellow, *blue, magenta, cyan, and white.
#
# Mar 2013 Yad Smood
#
# ----- END Original Description -----
#
# Changes to ys theme:
#   * Move timestamp to the front and make it darker
#   * List current IP addresses
#   * GCE hook (for controlling Google Cloud)
#   * Virtualenv hook
#   * Fix Mercurial detection
#
# Sep-Oct 2017 Pandu POLUAN <pepoluan@gmail.com>
#
# Changes to ys-pep theme:
#   * Split the prompt definition to 3 sections for better maintainability
#   * Add "leftbar" to more easily identify the prompt after a monstrous scroll
#   * Better IP address detection -- skips link-local, loopback, and DOWN ifaces
#
# Nov-Dec 2017 Pandu POLUAN <pepoluan@gmail.com>

# VCS
local vcs_prompt_prefix1=" %F{white}on%{$reset_color%} "
local vcs_prompt_prefix2=":%F{cyan}"
local vcs_prompt_suffix="%{$reset_color%}"
local vcs_prompt_dirty=" %F{red}%BX%b"
local vcs_prompt_clean=" %F{green}%Bo%b"

local default_iface_exclude="docker.*|br-.*"
local iface_exclude_re="${YSP_IFACE_EXCLUDE_RE:-${default_iface_exclude}}"

local bar_color="${YSP_BAR_COLOR:-148}"

# Git info
local git_info='$(git_prompt_info)'
ZSH_THEME_GIT_PROMPT_PREFIX="${vcs_prompt_prefix1}git${vcs_prompt_prefix2}"
ZSH_THEME_GIT_PROMPT_SUFFIX="$vcs_prompt_suffix"
ZSH_THEME_GIT_PROMPT_DIRTY="$vcs_prompt_dirty"
ZSH_THEME_GIT_PROMPT_CLEAN="$vcs_prompt_clean"

# HG info
local hg_info='$(ys_hg_prompt_info)'
ys_hg_prompt_info() {
  # make sure this is a Mercurial project
  if [ -d '.hg' ] && $(hg summary > /dev/null 2>&1) ; then
    echo -n "${vcs_prompt_prefix1}hg${vcs_prompt_prefix2}"
    echo -n $(hg branch 2>/dev/null)
    if [ -n "$(hg status 2>/dev/null)" ]; then
      echo -n "$vcs_prompt_dirty"
    else
      echo -n "$vcs_prompt_clean"
    fi
    echo -n "$vcs_prompt_suffix"
  fi
}

local exit_code="%(?,,C:%F{red}%?%{$reset_color%} )"

### BEGIN: pepoluan changes ###
#local dgrey="%B%F{black}"
local dgrey="%F{240}"
local leftbar1="%F{${bar_color}}┏%f"
local leftbar2="%F{${bar_color}}┃%f"
local leftbar3="%F{${bar_color}}┗%f"

# Show my IP Address
ZSH_THEME_SHOW_IP=${ZSH_THEME_SHOW_IP:-1}
ZSH_THEME_SHOW_IP6=${ZSH_THEME_SHOW_IP6:-0}
ZSH_THEME_SHOW_APIPA=${YSP_IFACE_EXCLUDE_REZSH_THEME_SHOW_APIPA:-0}
yspep_my_ip() {
  [[ $ZSH_THEME_SHOW_IP != 1 ]] && return
  echo -n "${dgrey}[%b%F{green}"
  addrs=()
  _uname="$(uname)"
  case "${(L)_uname}" in
    darwin*)
      for i in $(networksetup -listallhardwareports | awk '$1 == "Device:" {print $2}'); do
        addrs+=("$(ipconfig getifaddr $i)")
      done
      ;;
    freebsd*)
      ifaces=( $(ifconfig | grep "UP" | sed -r -e 's|:.*||') )
      for dev in ${ifaces[@]}; do
        [[ $dev =~ ^lo ]] && continue
        [[ $dev =~ $iface_exclude_re ]] && continue
        addr=$( ifconfig $dev | grep "inet " | cut -d" " -f2 )
        addrs+=( "%F{022}$dev:%F{green}$addr" )
      done
      ;;
    cygwin*)
      for addr in $(ipconfig | awk '$0 ~ /IPv4 Address/ { gsub(/[\t\r]/, "", $NF); print $NF }'); do
        [[ $addr =~ 169\.254\. && $ZSH_THEME_SHOW_APIPA != 1 ]] && continue
        addrs+=( $addr )
      done
      ;;
    *)  # Assume Linux
      while read num dev fam addr etc; do
        [[ $dev =~ ^lo ]] && continue   # skip loopback
        [[ $fam =~ ^inet ]] || continue  # skip non-inet addr's (what could they be?)
        [[ $fam == inet6 && $ZSH_THEME_SHOW_IP6 != 1 ]] && continue
        [[ $addr =~ 169\.254\. && $ZSH_THEME_SHOW_APIPA != 1 ]] && continue
        [[ $dev =~ $iface_exclude_re ]] && continue
        addrs+=( "%F{022}$dev:%F{green}${addr%/*}" )
      done < <(ip -d -o addr sh)
      ;;
  esac
  echo -n "${(j: :)addrs}"
  echo "${dgrey}]%b"
}
local ip_info='$(yspep_my_ip)'

# Show Virtualenv
ZSH_THEME_VIRTUALENV_PREFIX=" V:"
ZSH_THEME_VIRTUALENV_SUFFIX=" "
local venv_info="%B%F{blue}\$(virtualenv_prompt_info)%b"

# Detect tmux
yspep_tmux_info() {
  if [[ $TMUX ]]; then
    tmux_window="$(tmux run 'echo "#{window_id}"')"
    printf "\xE2\x80\x96${tmux_window#@}"
  fi
}
local tmux_info='$(yspep_tmux_info)'

# Host name, because in WSL the host name picks up the physical name
yspep_host() {
  if [[ $WSL_DISTRO_NAME ]]; then
    printf "$fg[yellow]wsl|$fg[green]${WSL_DISTRO_NAME}"
  else
    printf "$fg[green]%%m"
  fi
}
local host='$(yspep_host)'

# Other info, you can override this function in .zshrc
yspep_other_info() {
  # Example: Show the GCE_PROJECT variable in yellow:
  : echo "%{${GCE_PROJECT:+$fg[yellow] GCE:}$GCE_PROJECT%}"

  # IMPORTANT: You should *not* escape the vars in the above echo!
}
local other_info='$(yspep_other_info)'

# First Line (notice the newline at end!)
PROMPT="$leftbar1$ip_info
"

# Second Line (notice the newline at end!)
PROMPT+="$leftbar2${dgrey}[%*]%b \
%(#,%K{yellow}%F{black}%n%k,%F{cyan}%n)\
%F{white}@${host}${tmux_info}$dgrey:%b\
%B%F{yellow}%~%b\
${hg_info}\
${git_info}\
 $exit_code$venv_info$other_info
"

# Third Line (NO newline!)
PROMPT+="$leftbar3%B%F{red}%#%b%f "

unset RPROMPT

# vim: set ai ts=2 sts=2 et ft=sh :
