#!/usr/bin/env bash
#Script writtent to stop a running jmeter master test
#Kindly ensure you have the necessary kubeconfig

THIS_SCRIPT=$(basename -- "$0")
echo Running $THIS_SCRIPT
WORKDIR=$(cd -P -- "$(dirname -- "$0")" && pwd -P)


#Get namesapce variable
tenant=`awk '{print $NF}' "$WORKDIR"/tenant_export`

master_pod=`oc get pod | grep jmeter-master | awk '{print $1}'`

oc exec -ti $master_pod -- /bin/bash /jmeter/apache-jmeter-4.0/bin/stoptest.sh
