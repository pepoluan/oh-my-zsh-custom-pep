

SetAliases() {
  local _subex
  zstyle -s ':omz:plugins:gentoo' 'subexecutor' _subex
  if [[ -z $_subex && $EUID != 0 ]]; then
    if eix app-admin/doas | grep '\[I]' > /dev/null; then
      _subex='doas '
    elif eix app-admin/sudo | grep '\[I]' > /dev/null; then
      _subex='sudo '
    fi
  else
    _subex="$_subex "
  fi
  alias emup="${_subex}emerge -pv --update --deep --tree @world"
  alias emup1="${_subex}emerge -1v --update --deep @world"
  alias emch="${_subex}emerge -pv --changed-use --deep --tree @world"
  alias emch1="${_subex}emerge -1v --changed-use --deep @world"
  alias emsync="${_subex}emaint sync"
  alias emres="${_subex}emerge --resume"
  alias emcln="${_subex}emerge -p --depclean"
  alias emcln1="${_subex}emerge --depclean"
}

SetAliases

