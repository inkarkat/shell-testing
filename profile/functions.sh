#!/bin/sh source-this-script

# mock COMMAND [REPLACEMENT-CMD ...]
#			Define and export a function COMMAND that overrides
#			another command with REPLACEMENT-CMD. You can pass
#			":" to make that a no-op. The default is
#			"echo >&2 COMMAND", which prints the original command
#			and its arguments.
mock()
{
    case "$1" in
	--help|-h|-\?|"")   shift; echo "Usage: COMMAND [REPLACEMENT-CMD ...] [-?|-h|--help]"; return 0;;
    esac

    typeset command="$1"; shift

    if [ $# -eq 0 ]; then
	eval "${command}() { echo >&2 '$command' \"\$@\"; }"
    else
	eval "${command}() { $*; }"
    fi
    functionexport "${command?}"
}
