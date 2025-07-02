# VASTDB-S3-Event-Demo
Demonstration of S3 Event notifications using VAST Event Broker and Database
# Overview
This repository contains the files required to demonstrate how the VAST Database, Kafka Event Broker and S3 Buckets with Event Notifications can be used to track S3 Object Tags.
# Prerequisites 
-	VAST Cluster with release 5.3 or greater
-	Admin Access to the cluster.
-	A VIP Pool that is not in use by a Kafka View.
-	A Docker Host that has access to both the VMS network and the network defined in the VIP Pool.
  
# Building and connecting to the Docker Container for the demo
-	Download the files from the repository to the Docker Host.
-	Follow the instructions in the Dockerfile to obtain the VAST Database connector for Spark.
-	Build the docker image:
    docker build –no-cache -t vasts3eventdemo:1.0 . 
-	Run the docker image:
    docker run -d --name S3demo -p8888:8888 vasts3eventdemo:1.0
-	Connect to the jupyter server:
    https:// [IP Address of the Docker Host]:8888

# Demonstration Flow
Open the “S3 Events – Cluster Setup” notebook. This notebook will create all of the VAST Objects required for the demo. In the “Required VMS Information” section, provide the IP address of the VAST Cluster’s VMS (vastvms_endpoint) and the named of the VIP POOL to be used (vip_pool_name). You can then run the cells above the “Login to VMS and review configuration” section.
At this point it is a good idea to login to the cluster and explain what objects have been created and how they work together.

Next Open the “S3 Events - VAST DB” notebook. This notebook will be used to create the necessary database schema and for SQL reporting against the database.
You can then run all the cells above the “Create SQL for TABLE Create” section.

To create S3 Objects / Events open the “S3 Events - Object Source” notebook. To create 500 Objects and their associated Object Tags run all of the cells above the first “Query Kafka now” section. 

To process the Kafka events that were created from the previous step open the “S3 Events – Kafka” notebook and run the entire notebook.

You can now switch back to the “S3 Events – VAST DB” notebook and run the provided queries to demonstrate that the information is now stored in the VAST DB.

The notebooks also allow you demonstrate:
-	Object deletes
-	New Object Tags added to existing Objects
-	Updating Object Tag data
After you have completed the demo return to the “S3 Events – Cluster Setup” notebook and run all of the cells below the “Cleanup Cluster” section. This will remove the demo environment from the cluster.
