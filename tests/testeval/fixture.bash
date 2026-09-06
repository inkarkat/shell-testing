#!/bin/bash

bats_require_minimum_version 1.5.0
bats_load_library bats-support
bats_load_library bats-assert

testcallSimpleCommand()
{
    ${TEST:+testeval --for testee --} "${TEST:-printf}" "${TEST:- %q}" echo just 'a test'
}

testcallCommandLine()
{
    ${TEST:+testeval --for testee --command} "${TEST:-echo}" 'echo just a\ test'
}
