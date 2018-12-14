# ArgComplete Plugin

Initializes [Python argcomplete](https://argcomplete.readthedocs.io/en/latest/#) to work with zsh... in a way (see below)

## Usage

This plugin will first activate the `bashcompinit` ZSH module.

Afterwards, it will try to source the `~/.bash_completion.d/python-argcomplete.sh` script.

Finally, it will create a **function**, `reg-argcomplete`, which needs to be run against Python scripts you want argcomplete to work.

The `reg-argcomplete` function **must be run per Python script** you want tab-completion to work against.

For example, if you want tab-completion to work on the `gcloud` command, you must add this to your `.zshrc` file:

    reg-argcomplete $(which gcloud)

## Reference

Idea for this plugin came from [this Stack Overflow answer](https://stackoverflow.com/a/34797889/149900).

