Docker images for the master and slaves nodes can be built using the following procedure.

First of all the jmeter base image needs to be created from the opend-jdk image, this will be used as reference while building the master and slaves images:

# Build, tag and push the base image
````shell
docker build -t quay.io/rfelix/jmeter-base:1.0 -f Dockerfile-base .
docker push quay.io/rfelix/jmeter-base:1.0
````
# Build, tag and push the master image
````shell
docker build -t quay.io/rfelix/jmeter-master:1.0 -f Dockerfile-master .
docker push quay.io/rfelix/jmeter-master:1.0
````

# Build, tag and push the salve image
````shell
docker build -t quay.io/rfelix/jmeter-slave:1.0 -f Dockerfile-slave .
docker push quay.io/rfelix/jmeter-slave:1.0
````
