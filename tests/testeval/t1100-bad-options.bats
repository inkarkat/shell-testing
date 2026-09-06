#!/usr/bin/env bats

load fixture

@test "multiple COMMANDLINEs / COMMANDLINE + SIMPLECOMMAND cause error" {
    export TEST=another

    run -2 --separate-stderr testeval --command "${TEST:-echo}" foo --command bar
    assert_output ''
    output="$stderr" assert_output 'ERROR: COMMAND is allowed only once, but given "foo" and "bar" (minus "another").'

    run -2 --separate-stderr testeval --command "${TEST:-echo}" foo -- simple-bar
    assert_output ''
    output="$stderr" assert_output 'ERROR: COMMAND is allowed only once, but given "foo" and "simple-bar" (minus "another").'
}
