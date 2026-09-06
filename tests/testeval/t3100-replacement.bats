#!/usr/bin/env bats

load fixture

@test "with TESTEE=OTHER-COMMAND, command is replaced with a simple OTHER-COMMAND" {
    TEST=testee=uname run -0 testcallSimpleCommand
    assert_output 'uname'
}

@test "with TESTEE=OTHER-COMMAND, command is replaced with a complex OTHER-COMMAND" {
    TEST=testee=grep\ \'my\ name\'\ /etc/passwd run -0 testcallSimpleCommand
    assert_output "grep 'my name' /etc/passwd"
}

@test "TESTEE=OTHER-COMMAND extraction among other TESTEEs" {
    TEST=aDifferentTestee=exit,testee=uname\ -a,yetAnotherTestee=who\ -a run -0 testcallSimpleCommand
    assert_output 'uname -a'
}

@test "multiple TESTEE=OTHER-COMMANDs are concatenated" {
    TEST=testee=uname\ -a,testee=uptime,aDifferentTestee=who\ -a,testee=sleep\ 10 run -0 testcallSimpleCommand
    assert_output 'uname -a; uptime; sleep 10'
}
