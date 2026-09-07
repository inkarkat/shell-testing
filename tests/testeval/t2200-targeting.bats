#!/usr/bin/env bats

load fixture

@test "with TESTEE targeting, the invocation of any module is recorded" {
    TEST=testee run -0 testcallSimpleCommand
    TEST=testee run -0 testcallSimpleCommand --module testmodule
    TEST=testee run -0 testcallSimpleCommand --module anotherModule

    assert_file_exists "${BATS_TEST_TMPDIR}/testee.log"
    diff -y - --label expected "${BATS_TEST_TMPDIR}/testee.log" <<'EOF'
testee
testee:testmodule
testee:anotherModule
EOF
}

@test "with TESTEE targeting, the invocation of any module and any test point is recorded" {
    TEST=testee run -0 testcallSimpleCommand
    TEST=testee run -0 testcallSimpleCommand --module testmodule
    TEST=testee run -0 testcallSimpleCommand --module testmodule --point testpoint1
    TEST=testee run -0 testcallSimpleCommand --module anotherModule
    TEST=testee run -0 testcallSimpleCommand --module anotherModule --point testpoint2

    assert_file_exists "${BATS_TEST_TMPDIR}/testee.log"
    diff -y - --label expected "${BATS_TEST_TMPDIR}/testee.log" <<'EOF'
testee
testee:testmodule
testee:testmodule::testpoint1
testee:anotherModule
testee:anotherModule::testpoint2
EOF
}

@test "with TESTEE:MODULE targeting, the invocation of only that module is recorded" {
    TEST=testee:testmodule run -0 testcallSimpleCommand
    TEST=testee:testmodule run -0 testcallSimpleCommand --module testmodule
    TEST=testee:testmodule run -0 testcallSimpleCommand --module anotherModule

    assert_file_exists "${BATS_TEST_TMPDIR}/testee.log"
    diff -y - --label expected "${BATS_TEST_TMPDIR}/testee.log" <<<'testee:testmodule'
}

@test "with TESTEE:MODULE targeting, the invocation of only that module but any testpoint in it is recorded" {
    TEST=testee:testmodule run -0 testcallSimpleCommand
    TEST=testee:testmodule run -0 testcallSimpleCommand --module testmodule
    TEST=testee:testmodule run -0 testcallSimpleCommand --module testmodule --point testpoint1
    TEST=testee:testmodule run -0 testcallSimpleCommand --module anotherModule
    TEST=testee:testmodule run -0 testcallSimpleCommand --module anotherModule --point testpoint2

    assert_file_exists "${BATS_TEST_TMPDIR}/testee.log"
    diff -y - --label expected "${BATS_TEST_TMPDIR}/testee.log" <<'EOF'
testee:testmodule
testee:testmodule::testpoint1
EOF
}
