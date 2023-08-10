#!/usr/bin/zsh

# Function to determine the need of a zcompile. If the .zwc file
# does not exist, or the base file is newer, we need to compile.
zrecompile() {
    case $1 in
        -q) local quiet=1 ; shift ;;
        -qq) local quiet=2 ; shift ;;
        -qqq) local quiet=3 ; shift ;;
    esac

    (( quiet == 0 )) && echo -n "${1} ... "
    if [[ -s ${1} && ( ! -s ${1}.zwc || ${1} -nt ${1}.zwc) ]]; then
        (( quiet == 1 )) && echo -n "${1} ... "
        (( quiet < 2 ))  && echo -n "compiling ... "
        if (( quiet <= 2 )); then
            zcompile ${1}
        else
            zcompile ${1} > /dev/null 2> /dev/null
        fi
        (( quiet < 2 ))  && echo "ok"
    else
        (( quiet == 0 )) && echo "ok"
    fi
}


zrecompile-omz() {
    setopt localoptions EXTENDED_GLOB

    # For the for's, the (.N) is "plain file" and "NULL_GLOB"
    # See: https://zsh.sourceforge.io/Doc/Release/Expansion.html#Glob-Qualifiers

    # zcompile the completion cache; siginificant speedup.
    for file in ${ZDOTDIR:-${HOME}}/.zcomp^(*.zwc)(.N); do
        zrecompile $1 ${file}
    done

    # zcompile .zshrc
    zrecompile $1 ${ZDOTDIR:-${HOME}}/.zshrc

    # zcompile all .zsh files in omz
    local omz_dir=${ZDOTDIR:-${HOME}}/.oh-my-zsh
    for file in $(find $omz_dir -name "*.zsh"); do
        zrecompile $1 ${file}
    done

    # ... also compdef plugins that has no .zsh suffix
    for file in $(grep -rl "compdef" $omz_dir/plugins | egrep -v "\.(md|zsh|zwc)" ); do
        zrecompile $1 ${file}
    done
}
