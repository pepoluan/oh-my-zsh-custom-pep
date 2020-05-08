
viml() {
    local lnum=$1
    shift
    vim +"${lnum}|Silent normal zt" "$@"
}

# vim: set ft=zsh ts=4 sts=4 et ai :
