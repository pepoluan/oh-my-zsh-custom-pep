
viml() {
    vim +"${1}|execute 'silent normal zt'|redraw!" "$2"
}

vimrc() {
    vim ~/.vimrc
}

# vim: set ft=zsh ts=4 sts=4 et ai :
