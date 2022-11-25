# jmeter-openshift
Run Apache Jmeter on OpenShift 4x

* make the cluster setup 
* run distributed load testing

## Prerequisites
* Running OpenShift cluster (tested on v4.10)

  ```shell
  ❯ oc version
  Client Version: 4.10.32
  Server Version: 4.10.22
  Kubernetes Version: v1.23.5+3afdacb
  ```

* a jmx file to load into the Jmeter cluster

  * Testes with JMETER 5.5

  ```shell
  ❯ sh $JMETER_HOME/bin/jmeter.sh --version
      _    ____   _    ____ _   _ _____       _ __  __ _____ _____ _____ ____
     / \  |  _ \ / \  / ___| | | | ____|     | |  \/  | ____|_   _| ____|  _ \
    / _ \ | |_) / _ \| |   | |_| |  _|    _  | | |\/| |  _|   | | |  _| | |_) |
   / ___ \|  __/ ___ \ |___|  _  | |___  | |_| | |  | | |___  | | | |___|  _ <
  /_/   \_\_| /_/   \_\____|_| |_|_____|  \___/|_|  |_|_____| |_| |_____|_| \_\ 5.5
  
  Copyright (c) 1999-2022 The Apache Software Foundation
  ```

* Java 11

  ```shell
  ❯ java --version
  openjdk 11.0.11 2021-04-20
  OpenJDK Runtime Environment AdoptOpenJDK-11.0.11+9 (build 11.0.11+9)
  OpenJDK 64-Bit Server VM AdoptOpenJDK-11.0.11+9 (build 11.0.11+9, mixed mode)
  ```

## To Run

    ``` shell
    ❯ # name of namespace to be created! 
    ❯ export JMETER_NAMESPACE=rfelix-jmeter
    ❯ sh scripts/jmeter_cluster_create.sh
    ❯ sh scripts/dashboard.sh
    ❯ sh scripts/start_test.sh
    ```

# References
* https://blog.kubernauts.io/load-testing-as-a-service-with-jmeter-on-kubernetes-fc5288bb0c8b
* https://github.com/jiajunngjj/jmeter-openshift
