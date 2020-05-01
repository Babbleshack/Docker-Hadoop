FROM ubuntu:bionic AS base

MAINTAINER Babbleshack <dcrl94@gmail.com> Version: 0.1

ARG HADOOP_VERSION_ARG=3.2.1
ARG CLUSTER_NAME_ARG=hadoop-cluster

ENV HADOOP_VERSION=$HADOOP_VERSION_ARG
ENV CLUSTER_NAME=$CLUSTER_NAME_ARG

ENV ENTRYPOINT_SCRIPT_DIR=/opt/init_container.d
ENV HELPER_SCRIPTS_DIR=/opt/scripts

#HADOOP environment vars
ENV MAPRED_EXAMPLES=/opt/hadoop/share/hadoop/mapreduce/hadoop-mapreduce-examples-$HADOOP_VERSION.jar
ENV HADOOP_HOME=/opt/hadoop
ENV HADOOP_INSTALL=${HADOOP_HOME}
ENV HADOOP_MAPRED_HOME=${HADOOP_HOME}
ENV HADOOP_COMMON_HOME=${HADOOP_HOME}
ENV HADOOP_HDFS_HOME=${HADOOP_HOME}
ENV YARN_HOME=${HADOOP_HOME}
ENV HADOOP_COMMON_LIB_NATIVE_DIR=${HADOOP_HOME}/lib/native
ENV PATH=${PATH}:${HADOOP_HOME}/sbin:${HADOOP_HOME}/bin
ENV HADOOP_OPTS="-Djava.library.path=$HADOOP_HOME/lib/native"
ENV HADOOP_CONF_DIR=${HADOOP_HOME}/etc/hadoop 

#HADOOP data directories
ENV HADOOP_DATA_NODE_DATA=${HADOOP_HOME}/hdfs/datanode
ENV HADOOP_NAME_NODE_DATA=${HADOOP_HOME}/hdfs/namenode
ENV HADOOP_TEMPDIR=${HADOOP_HOME}/hadooptmpdata

#HADOOP users
ENV HDFS_NAMENODE_USER="root"
ENV HDFS_DATANODE_USER="root"
ENV HDFS_SECONDARYNAMENODE_USER="root"
ENV YARN_RESOURCEMANAGER_USER="root"
ENV YARN_NODEMANAGER_USER="root"
ENV YARN_EXAMPLES=${HADOOP_HOME}/share/hadoop/mapreduce

#WORK ENVIRONMENT
ENV WORKDIR=/hadoop

#Java env var
ENV JAVA_HOME=/usr/lib/jvm/java-8-openjdk-amd64

#Configure Container
RUN apt update && apt install -y \
        bash \
        vim \
        openjdk-8-jdk-headless \
        openssh-server \
        openssh-client \
        curl \
        python3 \
        python3-pip \
	net-tools \
	iputils-ping \
	iproute2

RUN pip3 install yarn_api_client 

# Grab hadoop files
RUN curl -L \
	"https://www.mirrorservice.org/sites/ftp.apache.org/hadoop/common/hadoop-${HADOOP_VERSION}/hadoop-${HADOOP_VERSION}.tar.gz" \
	-o /tmp/hadoop.tar.gz \
	&& tar xzf /tmp/hadoop.tar.gz -C /tmp/ \
	&& rm -rf /tmp/hadoop.tar.gz \
	&& mv -v /tmp/hadoop-${HADOOP_VERSION} ${HADOOP_HOME} \
	&& mkdir -pv ${ENTRYPOINT_SCRIPT_DIR} \
	&& mkdir -pv ${HELPER_SCRIPTS_DIR}

# passwordless ssh, update to use pregenerated keys.
RUN rm -rf /etc/ssh/ssh_host_dsa_key && ssh-keygen -q -N "" -t dsa -f /etc/ssh/ssh_host_dsa_key 
RUN rm -rf /etc/ssh/ssh_host_rsa_key && ssh-keygen -q -N "" -t rsa -f /etc/ssh/ssh_host_rsa_key 
RUN rm -rf /root/.ssh/id_rsa && ssh-keygen -q -N "" -t rsa -f /root/.ssh/id_rsa 
RUN cp -f /root/.ssh/id_rsa.pub /root/.ssh/authorized_keys

#Set work dir
WORKDIR ${WORKDIR} 

###########
##Configure hadoop
###########
FROM base AS hadoop

#copy hadoop files
COPY ./files/hadoop/* ${HADOOP_HOME}/etc/hadoop/
COPY ./files/init_scripts/* ${ENTRYPOINT_SCRIPT_DIR}/
COPY ./files/ssh/ssh_config /etc/ssh/
COPY ./files/scripts/* ${HELPER_SCRIPTS_DIR}/

#Copy init_scripts to work dir
RUN mkdir -pv ${WORKDIR}/scripts
COPY ./files/init_scripts/* ${WORKDIR}/scripts/

#Configure hadoop data dirs
RUN mkdir -pv ${HADOOP_DATA_NODE_DATA} \
        && mkdir -pv ${HADOOP_NAME_NODE_DATA} \
        && mkdir -pv ${HADOOP_TEMPDIR} \
        && mkdir -pv ${ENTRYPOINT_SCRIPT_DIR}

#Prepare Spark
ENV SPARK_HOME=/hadoop/spark
RUN curl -L "http://apache.mirror.anlx.net/spark/spark-3.0.0-preview2/spark-3.0.0-preview2-bin-hadoop3.2.tgz" \
	-o /tmp/spark.tgz \
	&& mkdir -v ${SPARK_HOME} \
	&& tar xzf /tmp/spark.tgz -C $SPARK_HOME --strip-components 1 \
	&& rm -f /tmp/spark.tgz
## COPY SPARK CONF FILES
COPY files/spark/conf/* ${SPARK_HOME}/conf/
RUN mkdir ${WORKDIR}/spark-metrics
#update path env
ENV PATH="${PATH}:${SPARK_HOME}/bin"
#Points to yarn conf dir (yarn-site.xml)
#ENV YARN_CONF_DIR="${HADOOP_CONF_DIR:-/opt/hadoop/etc/hadoop}"

############################
## FLINK
###########################
FROM alpine:3 AS flink

ARG FLINK_URL="http://mirror.vorboss.net/apache/flink/flink-1.10.0/flink-1.10.0-bin-scala_2.11.tgz"
ARG FLINK_SHADE_GIT="https://github.com/apache/flink-shaded.git"
ARG FLINK_SHADE="https://github.com/apache/flink-shaded/archive/release-10.0.tar.gz"

ENV WORKDIR=/flink
ENV HADOOP_VERSION=3.2.1

RUN apk update && \
	apk add maven \
	git \
	curl
#Builds hadoop shaded jars for hadoop

RUN mkdir ${WORKDIR} 
WORKDIR ${WORKDIR} 
ENV HADOOP_VERSION=3.2.1

# Prepare flink files
RUN mkdir ${WORKDIR}/flink \
	&& curl -L ${FLINK_URL} -o /tmp/flink.tar.gz \
	&& tar xzf /tmp/flink.tar.gz --strip-components 1 -C ${WORKDIR}/flink \
	&& rm -f /tmp/flink.tar.gz 

# Prepare shaded files
RUN curl -L ${FLINK_SHADE} -o /tmp/flink-shaded.tar.gz \
	&& mkdir ${WORKDIR}/flink-shaded \ 
	&& tar xzf /tmp/flink-shaded.tar.gz --strip-components 1 -C ${WORKDIR}/flink-shaded \
	&& rm -f /tmp/flink-shaded.tar.gz 

# Compile flink-shaded and move hadoop uber to $WORKDIR/flink/lib
RUN cd flink-shaded && mvn clean install -DskipTests -Dhadoop.version=${HADOOP_VERSION} \
	&& cd ${WORKDIR} \
	&& cp $(find ${WORKDIR}/flink-shaded -type f -iname "flink-shaded-hadoop-*-uber-*.jar") \
		${WORKDIR}/flink/lib \
	&& rm -rf ${WORKDIR}/flink-shaded

RUN tar czf ${WORKDIR}/flink.tar.gz ${WORKDIR}/flink 

##############################
##FEDERATED IMAGE
##############################
FROM hadoop AS federated

ENV ROUTER_CONF_DIR=${WORKDIR}/federation/router

#grab flink
COPY --from=flink /flink/flink.tar.gz .
RUN tar xzf ${WORKDIR}/flink.tar.gz --strip-components 1 -C ${WORKDIR} && rm -f ${WORKDIR}/flink.tar.gz

#prepare federated confs
COPY ./files/federated_confs/node/yarn-site.xml ${WORKDIR}/federation/node/yarn-site.xml
COPY ./files/federated_confs/general/yarn-site.xml ${HADOOP_CONF_DIR}/yarn-site.xml

#prepare router confs
RUN mkdir -pv ${ROUTER_CONF_DIR} \
	&& cp -rf ${HADOOP_CONF_DIR}/* ${ROUTER_CONF_DIR}/
COPY ./files/federated_confs/router/yarn-site.xml ${ROUTER_CONF_DIR}/yarn-site.xml

#add flink to path
ENV FLINK_HOME=${WORKDIR}/flink
ENV PATH=${PATH}:${FLINK_HOME}/bin

##############################
## EXPERIMENT SINGLE CLUSTER
##############################
FROM hadoop AS single-cluster
COPY --from=flink /flink/flink.tar.gz .
RUN tar xzf ${WORKDIR}/flink.tar.gz --strip-components 1 -C ${WORKDIR} && rm -f ${WORKDIR}/flink.tar.gz
#add flink to path
ENV FLINK_HOME=${WORKDIR}/flink
ENV PATH=${PATH}:${FLINK_HOME}/bin

#COPY Experiment yarn files
COPY ./files/experiment/yarn-site.xml ${HADOOP_CONF_DIR}/yarn-site.xml
