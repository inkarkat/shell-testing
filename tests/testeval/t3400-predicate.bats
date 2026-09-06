#!/usr/bin/env bats

load fixture

@test "with TESTEE?PREDICATE,TESTEE!, the command is suppressed only if PREDICATE is true" {
    TEST=testee\?true,testee\! run -0 testcallSimpleCommand
    assert_output ''

    TEST=testee\?false,testee\! run -0 testcallSimpleCommand
    assert_output 'echo just a\ test'
}

@test "complex predicate that evaluates environment variable" {
    P=1 TEST=testee'?[ $P -gt 0 ]',testee\! run -0 testcallSimpleCommand
    assert_output ''

    P=0 TEST=testee'?[ $P -gt 0 ]',testee\! run -0 testcallSimpleCommand
    assert_output 'echo just a\ test'
}

@test "with TESTEE?PREDICATE, TESTEE=OTHER-COMMAND, command is replaced with a simple OTHER-COMMAND only if PREDICATE is true" {
    TEST=testee\?true,testee=uname run -0 testcallSimpleCommand
    assert_output 'uname'

    TEST=testee\?false,testee=uname run -0 testcallSimpleCommand
    assert_output 'echo just a\ test'
}

@test "with TESTEE?PREDICATE,TESTEE@FILE, command is skipped and the contents of FILE are used as output only if PREDICATE is true" {
    TEST=testee\?true,testee@${BATS_TEST_DIRNAME@Q}/canned.txt run -0 testcallSimpleCommand
    printf -v expected 'cat %q' "${BATS_TEST_DIRNAME}/canned.txt"
    assert_output "$expected"

    TEST=testee\?false,testee@${BATS_TEST_DIRNAME@Q}/canned.txt run -0 testcallSimpleCommand
    assert_output 'echo just a\ test'
}

@test "with TESTEE?PREDICATE,TESTEE^=PREFIX, command is prefixed only if PREDICATE is true" {
    TEST=testee\?true,testee^=time\  run -0 testcallSimpleCommand
    assert_output 'time echo just a\ test'

    TEST=testee\?false,testee^=time\  run -0 testcallSimpleCommand
    assert_output 'echo just a\ test'
}
