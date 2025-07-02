## Starting from Ubuntu
FROM ubuntu:22.04

## Create a Non-Root User
ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update && apt-get install -y --no-install-recommends dialog apt-utils
RUN apt-get update && apt-get -y install sudo && apt-get install wget -y && apt-get install curl -y && apt-get install nano
RUN useradd -m docker && echo "docker:docker" | chpasswd && adduser docker sudo
RUN echo '%sudo ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers

## Switch to Non-Root User
USER docker

## Set Home to Workdir
WORKDIR /home/docker/

## Generate RSA 
RUN sudo apt-get install -y openssh-server
RUN ssh-keygen -t rsa -P '' -f ~/.ssh/id_rsa \
  && cat ~/.ssh/id_rsa.pub >> ~/.ssh/authorized_keys \
  && chmod 0600 ~/.ssh/authorized_keys

## Install TZData
RUN DEBIAN_FRONTEND=noninteractive TZ="America/Chicago" sudo -E apt-get -y install tzdata

## Install Git
RUN sudo apt-get install git -y

## Install Java Runtime Environment
RUN sudo apt-get install openjdk-11-jre -y
RUN echo 'JAVA_HOME=/usr/lib/jvm/java-11-openjdk-amd64' >> ~/.bashrc
RUN echo 'PATH=$PATH:$JAVA_HOME/bin' >> ~/.bashrc
RUN . ~/.bashrc

## Install Scala for VAST
# RUN sudo apt-get install scala -y

## Install Python 2, 3 and Pip/Pip3 
RUN sudo apt-get install python2 python3 pip -y

# setting python3 to python3.10
RUN if [ -f /etc/alternatives/python3 ]; then rm /etc/alternatives/python3 ; fi 
RUN if [ -f /usr/bin/python3.10 ]; then sudo ln -s /usr/bin/python3.10 /etc/alternatives/python3; fi

## Install Apache Spark
RUN wget -q https://archive.apache.org/dist/spark/spark-3.4.1/spark-3.4.1-bin-hadoop3-scala2.13.tgz
RUN sudo mkdir /opt/spark
RUN sudo tar -xf spark-3.4.1-bin-hadoop3-scala2.13.tgz   -C /opt/spark --strip-component 1
RUN sudo chmod -R 777 /opt/spark
RUN echo 'SPARK_HOME=/opt/spark' >> ~/.bashrc
RUN echo 'PATH=$PATH:$SPARK_HOME/bin:$SPARK_HOME/sbin' >> ~/.bashrc
RUN echo 'PYSPARK_PYTHON=/usr/bin/python3' >> ~/.bashrc
RUN echo 'SPARK_VERSION=3.4.3' >> ~/.bashrc
RUN echo 'HADOOP_VERSION=3' >> ~/.bashrc
RUN . ~/.bashrc
ENV SPARK_DIR=/opt/spark
ENV SPARK_JARS_DIR=/opt/spark/jar

RUN wget -q https://files.pythonhosted.org/packages/10/30/a58b32568f1623aaad7db22aa9eafc4c6c194b429ff35bdc55ca2726da47/py4j-0.10.9.7-py2.py3-none-any.whl \
 && pip install --ignore-requires-python py4j-0.10.9.7-py2.py3-none-any.whl \
 && rm py4j-0.10.9.7-py2.py3-none-any.whl

## Install VAST DB SPARK JARs
#
# TO obtain the JARS:
# On any VAST CNODE:
# run: 
#     docker cp vast_platform:/vast/spark3 /tmp/spark34
# Then create a tar file of the spark3 directory:
# run:
#     tar -cvf vastdb_spark34.tar /tmp/spark34
# Finally copy it to the folder where this Dockerfile is.
#
# or https://github.com/vast-data/vast-db-connectors/releases
RUN sudo mkdir /opt/vastdb_spark
COPY vastdb_spark34.tar /opt/vastdb_spark/
RUN sudo tar xvf /opt/vastdb_spark/vastdb_spark34.tar -C /opt/vastdb_spark --strip-component 1
RUN sudo chown -R docker:docker /opt/vastdb_spark

## Install AWS JARs
RUN wget -q https://repo1.maven.org/maven2/com/amazonaws/aws-java-sdk-bundle/1.11.1026/aws-java-sdk-bundle-1.11.1026.jar \
 && wget -q https://repo1.maven.org/maven2/org/apache/hadoop/hadoop-aws/3.3.2/hadoop-aws-3.3.2.jar
RUN mv -vf aws-java-sdk-bundle-1.11.1026.jar $SPARK_JARS_DIR
RUN mv -vf hadoop-aws-3.3.2.jar $SPARK_JARS_DIR

## Install Notebook and pyspark

RUN pip install notebook pyspark findspark 

EXPOSE 8888


## Start Container
CMD ~/.local/bin/jupyter-notebook --ip 0.0.0.0 --NotebookApp.token ''
