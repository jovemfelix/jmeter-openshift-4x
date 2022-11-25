#!/usr/bin/env bash
#Script created to launch Jmeter tests directly from the current terminal without accessing the jmeter master pod.
#It requires that you supply the path to the jmx file
#After execution, test script jmx file may be deleted from the pod itself but not locally.

THIS_SCRIPT=$(basename -- "$0")
WORKDIR=$(cd -P -- "$(dirname -- "$0")" && pwd -P)
printf "\n# Running %s at %s" "$THIS_SCRIPT" "$WORKDIR"

set -e

export JMETER_TEST_FULL_PATH=$1
export JMETER_TEST_FILENAME=$(basename "$JMETER_TEST_FULL_PATH")
export JMETER_LOAD_TEST_FULL_PATH="$WORKDIR/load_test"
export JMETER_LOAD_TEST_FILENAME=$(basename "$JMETER_LOAD_TEST_FULL_PATH")

tenant=$(awk '{print $NF}' "$WORKDIR"/tenant_export)
printf "\n# The namespace used is '%s'\n" "$tenant"

if [ -n "$JMETER_TEST_FULL_PATH" ]; then
  printf "\n# JMETER_TEST_FULL_PATH is set to '%s'\n" "$JMETER_TEST_FULL_PATH";
  printf "\n# JMETER_TEST_FILENAME is set to '%s'\n" "$JMETER_TEST_FILENAME";
  printf "\n# JMETER_LOAD_TEST_FILENAME is set to '%s'\n" "$JMETER_LOAD_TEST_FILENAME";
else
  >&2 printf "\n# The Test script file is NOT FOUND!\nUse: %s path-to-jmeter.jmx\n" "$THIS_SCRIPT";
  exit 1
fi

if [ ! -f "$JMETER_TEST_FULL_PATH" ];
then
    >&2 printf "\n# '%s' was NOT FOUND in PATH. \nKindly check and input the correct file path\n" "$JMETER_TEST_FULL_PATH"
    exit 1
fi

printf "\n# JMeter Master Pod: "
master_pod=$(oc -n "$tenant" get pod | grep jmeter-master | awk '{print $1}')
printf "'%s'" "$master_pod"

#printf "\n# Copying test loader [%s] --> [%s]\n" "$JMETER_LOAD_TEST_FULL_PATH" "$master_pod"
#oc cp "$JMETER_LOAD_TEST_FULL_PATH" "$master_pod":/tmp/"$JMETER_LOAD_TEST_FILENAME" -n "$tenant"
#
#printf "\n# Making the load test Runnable\n"
#oc -n "$tenant"  exec -ti "$master_pod" -- chmod +x /tmp/"$JMETER_LOAD_TEST_FILENAME"

printf "\n# Copying JMX [%s] --> [%s]\n" "$JMETER_TEST_FULL_PATH" "$master_pod"
oc -n "$tenant" cp "$JMETER_TEST_FULL_PATH" "$master_pod":/tmp/"${JMETER_TEST_FILENAME}"

#oc exec -ti "$master_pod" -- chmod +x /tmp/"${JMETER_TEST_FULL_PATH}"

printf "\n# ------------------------------------ \n"
start=$(date +%s)
oc -n "$tenant" exec -ti "$master_pod" -- /bin/bash /tmp/"$JMETER_LOAD_TEST_FILENAME" /tmp/"${JMETER_TEST_FILENAME}"
end=$(date +%s)
printf "\n# ------------------------------------ \n"
printf "\n# Elapsed Time: [%s] seconds\n" "$(($end-$start))"
