#!/usr/bin/env bash
#Create multiple Jmeter namespaces on an existing kuberntes cluster

THIS_SCRIPT=$(basename -- "$0")
WORKDIR=$(cd -P -- "$(dirname -- "$0")" && pwd -P)
printf "\n# Running %s at %s" "$THIS_SCRIPT" "$WORKDIR"

printf "\n# Checking if oc is present\n"

if ! hash oc 2>/dev/null
then
    >&2 echo "'oc' was not found in PATH"
    >&2 echo "Kindly ensure that you can access an existing OpenShift cluster via oc"
    exit 1
fi

oc version

printf "\n# Checking if the Namespace Variable is set\n"

if [ -z ${JMETER_NAMESPACE+x} ]; then
  >&2 printf "JMETER_NAMESPACE variable is unset!\nUse: export JMETER_NAMESPACE=xxx";
  exit 1
else
  echo "JMETER_NAMESPACE is set to '$JMETER_NAMESPACE'";
fi

#Check If namespace exists

oc get project "$JMETER_NAMESPACE" 2> /dev/null

if [ $? -eq 0 ]
then
  printf "\n# Printout Of the %s Objects\n" "$JMETER_NAMESPACE"
  oc get all -o wide
  printf "\n# Project %s ALREADY exists, please select a UNIQUE name!!\n" "$JMETER_NAMESPACE"
  exit 1
fi

set -e
echo
echo "Creating project: $JMETER_NAMESPACE"
oc new-project $JMETER_NAMESPACE --description="jmeter cluster for load testing" --display-name="loadtesting"
echo "Project $JMETER_NAMESPACE has been created"

printf "\n# Set the current namespace cluster to %s:\n" "$JMETER_NAMESPACE"
oc project "$JMETER_NAMESPACE"

printf "\n# Creating Jmeter Slave:\n"
oc create -f "${WORKDIR}"/../templates/jmeter_slave_deployment.yaml
oc create -f "${WORKDIR}"/../templates/jmeter_slave_svc.yaml

printf "\n# Creating Jmeter Master: Configuration\n"
oc create -f "${WORKDIR}"/../templates/jmeter_master_configmap.yaml

printf "\n# Creating Jmeter Master\n"
oc create -f "${WORKDIR}"/../templates/jmeter_master_deployment.yaml


printf "\n# Creating Influxdb: Configuration\n"
oc create -f "${WORKDIR}"/../templates/jmeter_influxdb_configmap.yaml

printf "\n# Creating Influxdb:\n"
oc create -f "${WORKDIR}"/../templates/jmeter_influxdb_openshift_deployment_ephemeral.yaml
oc create -f "${WORKDIR}"/../templates/jmeter_influxdb_svc.yaml

printf "\n# Creating Grafana Deployment\n"
oc create -f "${WORKDIR}"/../templates/jmeter_grafana_deploy.yaml
oc create -f "${WORKDIR}"/../templates/jmeter_grafana_svc.yaml
oc create -f "${WORKDIR}"/../templates/jmeter_grafana_route.yaml

printf "\n# Creating Grafana Reporter\n"
oc create -f "${WORKDIR}"/../templates/jmeter_grafana_reporter.yaml

printf "\n# Printout Of the %s Objects\n" "$JMETER_NAMESPACE"
oc get all -o wide

echo project= "$JMETER_NAMESPACE" > "${WORKDIR}"/tenant_export
