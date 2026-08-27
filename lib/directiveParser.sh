#!/bin/bash source-this-script

unset remainingTest
testConsumeDirectiveInto()
{
    local -n directiveRef="${1:?}"; shift
    local sigil="${1:?}"; shift
    [ -n "${remainingTest+t}" ] || remainingTest=",${TEST},"

    case "$remainingTest" in
	*,"${testee}${sigil}"*([^:,])"${module:+:}${module}",*)
	    directiveRef=",${remainingTest},"; directiveRef="${directiveRef#*,${testee}${sigil}}"; directiveRef="${directiveRef%%${module:+:}${module},*}"
	    remainingTest="${remainingTest/",${testee}${sigil}${directiveRef}${module:+:}${module},"/,}"
	    return 0
	    ;;

	*)
	    unset remainingTest
	    return 1
	    ;;
    esac
}
