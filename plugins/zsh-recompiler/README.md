# zsh-recompiler
> zsh plugin for recompiling ZSH scripts using `zcompile`

## Usage
Once the plugin is installed, two commands are provided:

### `zrecompile`

```
zrecompile [-q[q[q]]] <zsh_script>
```

  * `-q` only show recompiled scripts
  * `-qq` only show errors
  * `-qqq` totally quiet


Recompile stated zsh script if:
  * The associated `.zwc` file does not exist, or
  * The base file is newer


### `zrecompile-omz`

```
zrecompile-omz [-q[q[q]]]
```

Recompile all oh-my-zsh scripts
