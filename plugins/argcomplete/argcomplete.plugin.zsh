
autoload bashcompinit
bashcompinit
source ~/.bash_completion.d/python-argcomplete.sh

reg-argcomplete() {
  eval "$(register-python-argcomplete $1)"
}

