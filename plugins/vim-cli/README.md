# vim-cli Plugin

vim-cli plugin -- Provides aliases and functions to drive vim from the command line

## Usage

Add to the `plugins` array.

## Provided commands (functions/aliases)

| Alias  | Description                                              |
|:------:|:--------------------------------------------------------:|
| `viml` | Open file `$2` vim and make line `$1` to be topmost. [1] |

**Notes:**

[1] You need to create the `Silent` command. [Go here and find "external grep".][Silent]

[Silent]: https://vim.fandom.com/wiki/Avoiding_the_%22Hit_ENTER_to_continue%22_prompts
