# VASTDB-S3-Event-Demo
Demonstration of S3 Event notifications using VAST Event Broker and Database
# Overview
This repository contains the files required to demonstrate how the VAST Database, Kafka Event Broker and S3 Buckets with Event Notifications can be used to track S3 Object Tags.
#Prerequisites 
-	VAST Cluster with release 5.3 or greater
-	Admin Access to the cluster.
-	A VIP Pool that is not in use by a Kafka View.
-	A Docker Host that has access to both the VMS network and the network defined in the VIP Pool.
#Building and connecting to the Docker Container for the demo
-	Download the files from the repository to the Docker Host.
-	Build the docker image:
    docker build –no-cache -t vasts3eventdemo:1.0 . 
-	Run the docker image:
    docker run -d --name S3demo -p8888:8888 vasts3eventdemo:1.0
-	Connect to the jupyter server:
https:// [IP Address of the Docker Host]:8888
