FROM babbleshack/hadoop:3-2-1 AS test_bed

ENV WORKDIR=/hadoop
WORKDIR ${WORKDIR}

COPY ./files/deploy.tar.gz ${WORKDIR}/deploy.tar.gz

##Copy new jars in place
RUN mkdir ${WORKDIR}/deploy \
	&& tar xzf ${WORKDIR}/deploy.tar.gz -C ${WORKDIR}/deploy --strip-components=1 \
	&& rm -rf ${WORKDIR}/deploy.tar.gz \
	&& cp -rf ${WORKDIR}/deploy/share/hadoop/yarn/* /opt/hadoop/share/hadoop/yarn/
