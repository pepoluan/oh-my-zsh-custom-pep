# Gentoo Plugin

Provides aliases and functions to assist day-to-day Gentoo maintenance, while
automatically detecting which program is used for subexecution (privilege
escalation).

## Configuration

`zstyle :omz:plugins:gentoo subexecutor $PROG`

> (Optional) Configure this plugin to use $PROG as the subexecutor

## Aliases / Commands

`emup`

> `emerge -pv --update --deep --tree @world`

`emup1`

> `emerge -1v --update --deep @world`

`emch`

> `emerge -pv --changed-use --deep --tree @world`

`emch1`

> `emerge -1v --changed-use --deep @world`

`emsync`

> `emaint sync`

