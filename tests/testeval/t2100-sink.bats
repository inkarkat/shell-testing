#!/usr/bin/env bats

load fixture

@test "without TEST, no recording is done" {
    run -0 testcallSimpleCommand
    assert_file_not_exists "${BATS_TEST_TMPDIR}/testee.log"
}

@test "with different TESTEE target, no recording is done" {
    TEST=aDifferentTestee run -0 testcallSimpleCommand
    assert_file_not_exists "${BATS_TEST_TMPDIR}/testee.log"
}

@test "with TESTEE targeting, the invocation is recorded" {
    TEST=testee run -0 testcallSimpleCommand
    assert_file_exists "${BATS_TEST_TMPDIR}/testee.log"
    diff -y - --label expected "${BATS_TEST_TMPDIR}/testee.log" <<<'testee'
}

@test "multiple invocations are recorded" {
    TEST=testee run -0 testcallSimpleCommand
    TEST=testee run -0 testcallSimpleCommand
    TEST=testee run -0 testcallSimpleCommand

    assert_file_exists "${BATS_TEST_TMPDIR}/testee.log"
    diff -y - --label expected "${BATS_TEST_TMPDIR}/testee.log" <<'EOF'
testee
testee
testee
EOF
}

@test "with TESTEE targeting outside Bats, the invocation is recorded in the current working directory" {
    rm --force -- "${PWD}/testee.log"
    BATS_TEST_TMPDIR='' TEST=testee run -0 testcallSimpleCommand
    assert_file_not_exists "${BATS_TEST_TMPDIR}/testee.log"
    assert_file_exists "${PWD}/testee.log"
    diff -y - --label expected "${PWD}/testee.log" <<<'testee'
}

@test "the invocation can be recorded to a custom TEST_LOGDIR file" {
    rm --force -- "${PWD}/testee.log"
    BATS_TEST_TMPDIR='' TEST_LOGDIR="$BATS_TMPDIR" TEST=testee run -0 testcallSimpleCommand
    assert_file_not_exists "${PWD}/testee.log"
    assert_file_exists "${BATS_TMPDIR}/testee.log"
}

@test "the invocation can be recorded to a custom TEST_SINK file" {
    rm --force -- "${BATS_TMPDIR}/custom.txt"
    TEST_SINK="${BATS_TMPDIR}/custom.txt" TEST=testee run -0 testcallSimpleCommand
    assert_file_not_exists "${BATS_TEST_TMPDIR}/testee.log"
    assert_file_exists "${BATS_TMPDIR}/custom.txt"
    diff -y - --label expected "${BATS_TMPDIR}/custom.txt" <<<'testee'
}

@test "the invocation can be recorded to a custom TEST_SINK file descriptor " {
    TEST_SINK='&2' TEST=testee run -0 --separate-stderr testcallSimpleCommand
    assert_file_not_exists "${BATS_TEST_TMPDIR}/testee.log"
    output="$stderr" assert_output 'testee'
}
