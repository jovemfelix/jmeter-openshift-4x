#!/bin/bash
#Script created to invoke jmeter test script with the slave POD IP addresses
#Script should be run like: ./load_test "path to the test script in jmx format"


export x="/tmp/test-jms.jmx"
name=$(basename "$x" ".jmx")

echo "--> $name"
