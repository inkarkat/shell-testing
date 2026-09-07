#!/usr/bin/env bats

load fixture

@test "with TESTEE@FILE, command is skipped and the contents of FILE are used as output" {
    TEST=testee@${BATS_TEST_DIRNAME@Q}/canned.txt run -0 testcallSimpleCommand
    printf -v expected 'cat %q' "${BATS_TEST_DIRNAME}/canned.txt"
    assert_output "$expected"
}

@test "with TESTEE@N-FILE, command is skipped, the contents of FILE are used as output, and exit status is N" {
    TEST="testee@${BATS_TEST_DIRNAME}/42-canned.txt" run -0 testcallSimpleCommand
    printf -v expected '(cat %q; exit 42)' "${BATS_TEST_DIRNAME}/canned.txt"
    assert_output "$expected"
}
