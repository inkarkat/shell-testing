#!/usr/bin/env bats

load fixture

@test "with TESTEE?PREDICATE targeting, the invocation is recorded only if PREDICATE is true" {
    TEST=testee\?true run -0 testcallSimpleCommand
    TEST=testee\?false run -0 testcallSimpleCommand
    assert_file_exists "${BATS_TEST_TMPDIR}/testee.log"
    diff -y - --label expected "${BATS_TEST_TMPDIR}/testee.log" <<<'testee'
}

@test "with TESTEE?PREDICATE targeting of modules, the invocation is recorded only if PREDICATE is true" {
    TEST=testee\?true run -0 testcallSimpleCommand --module testmodule1
    TEST=testee\?false run -0 testcallSimpleCommand --module testmodule2
    TEST=testee\?true run -0 testcallSimpleCommand --module testmodule3
    TEST=testee\?false run -0 testcallSimpleCommand --module testmodule4
    assert_file_exists "${BATS_TEST_TMPDIR}/testee.log"
    diff -y - --label expected "${BATS_TEST_TMPDIR}/testee.log" <<'EOF'
testee:testmodule1
testee:testmodule3
EOF
}

@test "with TESTEE?PREDICATE targeting of test points, the invocation is recorded only if PREDICATE is true" {
    TEST=testee\?true run -0 testcallSimpleCommand --point testpoint1
    TEST=testee\?false run -0 testcallSimpleCommand --point testpoint2
    TEST=testee\?true run -0 testcallSimpleCommand --point testpoint3
    TEST=testee\?false run -0 testcallSimpleCommand --point testpoint4
    assert_file_exists "${BATS_TEST_TMPDIR}/testee.log"
    diff -y - --label expected "${BATS_TEST_TMPDIR}/testee.log" <<'EOF'
testee::testpoint1
testee::testpoint3
EOF
}

@test "with TESTEE:MODULE?PREDICATE targeting of test points, the invocation is recorded only if PREDICATE is true" {
    TEST=testee\?true run -0 testcallSimpleCommand --module testmoduleA --point testpoint1
    TEST=testee\?false run -0 testcallSimpleCommand --module testmoduleA --point testpoint2
    TEST=testee\?true run -0 testcallSimpleCommand --module testmoduleB --point testpoint3
    TEST=testee\?false run -0 testcallSimpleCommand --module testmoduleB --point testpoint4
    assert_file_exists "${BATS_TEST_TMPDIR}/testee.log"
    diff -y - --label expected "${BATS_TEST_TMPDIR}/testee.log" <<'EOF'
testee:testmoduleA::testpoint1
testee:testmoduleB::testpoint3
EOF
}

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
