#!/usr/bin/env bash

THIS_SCRIPT=$(basename -- "$0")
echo Running $THIS_SCRIPT
WORKDIR=$(cd -P -- "$(dirname -- "$0")" && pwd -P)

if [ -z ${JMETER_NAMESPACE+x} ]; then
  >&2 printf "JMETER_NAMESPACE variable is unset!\nUse: export JMETER_NAMESPACE=xxx";
  exit 1
else
  echo "JMETER_NAMESPACE is set to '$JMETER_NAMESPACE'";
fi

printf "\nDeleting namespace JMETER_NAMESPACE\n"
oc delete project $JMETER_NAMESPACE
