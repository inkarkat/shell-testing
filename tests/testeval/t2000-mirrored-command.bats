#!/usr/bin/env bats

load fixture

@test "without TEST, the command is mirrored back" {
    run -0 testcallSimpleCommand
    assert_output ' echo just a\ test'	# Note: Leading space due to the printf format string.
}

@test "without TEST, the command-line is mirrored back" {
    run -0 testcallCommandLine
    assert_output 'echo just a\ test'
}

@test "with different TESTEE target, the command is mirrored back" {
    TEST=aDifferentTestee run -0 testcallSimpleCommand
    assert_output 'echo just a\ test'
}

@test "with different TESTEE target, the command-line is mirrored back" {
    TEST=aDifferentTestee run -0 testcallCommandLine
    assert_output 'echo just a\ test'
}

@test "with TESTEE targeting, the command is mirrored back" {
    TEST=testee run -0 testcallSimpleCommand
    assert_output 'echo just a\ test'
}

@test "with TESTEE targeting, the command-line is mirrored back" {
    TEST=testee run -0 testcallCommandLine
    assert_output 'echo just a\ test'
}
