#!/bin/bash source-this-script

unset remainingTest
testConsumeDirectiveInto()
{
    local -n directiveRef="${1:?}"; shift
    local sigil="${1:?}"; shift
    [ -n "${remainingTest+t}" ] || remainingTest=",${TEST},"

    case "$remainingTest" in
	*,"${testee}${module:+:}${module}${testPointName:+::}${testPointName}${sigil}"*([^,]),*)
	    directiveRef=",${remainingTest},"; directiveRef="${directiveRef#*,${testee}${module:+:}${module}${testPointName:+::}${testPointName}${sigil}}"; directiveRef="${directiveRef%%,*}"
	    remainingTest="${remainingTest/",${testee}${module:+:}${module}${testPointName:+::}${testPointName}${sigil}${directiveRef},"/,}"
	    return 0
	    ;;

	*)
	    unset remainingTest
	    return 1
	    ;;
    esac
}
