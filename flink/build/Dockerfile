FROM alpine:3

ARG FLINK_URL="http://mirror.vorboss.net/apache/flink/flink-1.10.0/flink-1.10.0-bin-scala_2.11.tgz"
ARG FLINK_SHADE_GIT="https://github.com/apache/flink-shaded.git"
ARG FLINK_SHADE="https://github.com/apache/flink-shaded/archive/release-10.0.tar.gz"

ENV WORKDIR=/flink
ENV HADOOP_VERSION=2.9.2

RUN apk update && \
	apk add maven \
	git \
	curl
#Builds hadoop 2.9.2 shaded jars for hadoop

RUN mkdir ${WORKDIR} 
WORKDIR ${WORKDIR} 

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
RUN cd flink-shaded && mvn clean install -DskipTests -Dhadoop.version=3.2.1 \
	&& cd ${WORKDIR} \
	&& cp $(find ${WORKDIR}/flink-shaded -type f -iname "flink-shaded-hadoop-*-uber-*.jar") \
		${WORKDIR}/flink/lib \
	&& rm -rf ${WORKDIR}/flink-shaded

RUN tar czf ${WORKDIR}/flink.tar.gz ${WORKDIR}/flink 

