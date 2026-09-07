#!/usr/bin/env bats

load fixture

@test "with test[eval] targeting, the activation information is printed" {
    for value in test{,eval}
    do
	TEST="$value" run -0 --separate-stderr testcallSimpleCommand \
	    && assert_output 'echo just a\ test' \
	    && output="$stderr" assert_output 'testeval: Will activate with TEST=testee[!|=OTHER-COMMAND|@[N-]FILE|^=PREFIX|+=SUFFIX|?PREDICATE]' \
	    || fail "$value"
    done
}

@test "with test targeting, the activation information for used modules and test points is printed" {
    TEST=test run -0 --separate-stderr testcallSimpleCommand --module testmodule
    output="$stderr" assert_output 'testeval: Will activate with TEST=testee:testmodule[!|=OTHER-COMMAND|@[N-]FILE|^=PREFIX|+=SUFFIX|?PREDICATE]'
    TEST=test run -0 --separate-stderr testcallSimpleCommand --module testmodule --point testpoint1
    output="$stderr" assert_output 'testeval: Will activate with TEST=testee:testmodule::testpoint1[!|=OTHER-COMMAND|@[N-]FILE|^=PREFIX|+=SUFFIX|?PREDICATE]'
    TEST=test run -0 --separate-stderr testcallSimpleCommand --module anotherModule
    output="$stderr" assert_output 'testeval: Will activate with TEST=testee:anotherModule[!|=OTHER-COMMAND|@[N-]FILE|^=PREFIX|+=SUFFIX|?PREDICATE]'
    TEST=test run -0 --separate-stderr testcallSimpleCommand --module anotherModule --point testpoint2
    output="$stderr" assert_output 'testeval: Will activate with TEST=testee:anotherModule::testpoint2[!|=OTHER-COMMAND|@[N-]FILE|^=PREFIX|+=SUFFIX|?PREDICATE]'
}
