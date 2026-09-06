#!/usr/bin/env bats

load fixture

@test "with TESTEE!, the command is suppressed" {
    TEST=testee\! run -0 testcallSimpleCommand
    assert_output ''
}
