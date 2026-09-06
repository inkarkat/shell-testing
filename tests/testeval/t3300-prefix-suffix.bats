#!/usr/bin/env bats

load fixture

@test "with TESTEE^=PREFIX, command is prefixed" {
    TEST=testee^=time\  run -0 testcallSimpleCommand
    assert_output 'time echo just a\ test'
}

@test "multiple TESTEE^=PREFIX are concatenated" {
    TEST=testee^=time\ ,testee^=verbose\  run -0 testcallSimpleCommand
    assert_output 'verbose time echo just a\ test'
}

@test "with TESTEE+=SUFFIX, command is suffixed" {
    TEST=testee+=. run -0 testcallSimpleCommand
    assert_output 'echo just a\ test.'
}

@test "multiple TESTEE+=SUFFIX are concatenated" {
    TEST=testee+=\ to,testee+=\ check\\\! run -0 testcallSimpleCommand
    assert_output 'echo just a\ test to check\!'
}

@test "multiple TESTEE^=PREFIX and TESTEE+=SUFFIX among other TESTEEs" {
    TEST=testee+=ing\ run,aDifferentTestee+=X,testee^=verbose\ ,aDifferentTestee^=echo\ ,testee+='\?' run -0 testcallSimpleCommand
    assert_output 'verbose echo just a\ testing run\?'
}
