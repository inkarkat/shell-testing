#!/usr/bin/env bats

load fixture

testSimpleCommand()
{
    eval "$(${TEST:+testeval --for testee --} "${TEST:-printf}" "${TEST:- %q}" echo the '"quick"' brown '/fox\' jumps over an ol\'dog)"
}

testCommandLine()
{
    eval "$(${TEST:+testeval --for testee --command} "${TEST:-echo}" "echo the \\\"quick\\\" brown /fox\\\\ jumps over an ol\\'dog")"
}

assertCall()
{
    assert_output "the \"quick\" brown /fox\\ jumps over an ol'dog"
}

@test "without TEST, the command is executed" {
    run -0 testSimpleCommand
    assertCall
}

@test "without TEST, the command-line is mirrored back" {
    run -0 testCommandLine
    assertCall
}

@test "with different TEST target, the command is mirrored back" {
    TEST=aDifferentTestee run -0 testSimpleCommand
    assertCall
}

@test "with different TEST target, the command-line is mirrored back" {
    TEST=aDifferentTestee run -0 testCommandLine
    assertCall
}

@test "with TEST targeting, the command is mirrored back" {
    TEST=testee run -0 testSimpleCommand
    assertCall
}

@test "with TEST targeting, the command-line is mirrored back" {
    TEST=testee run -0 testCommandLine
    assertCall
}
