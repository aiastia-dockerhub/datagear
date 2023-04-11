FROM openjdk:21-jdk

WORKDIR /opt
ENV VERSION=4.5.1
ENV PACKAGE=datagear-${VERSION}
ENV ZIP_FILE=${PACKAGE}.zip

#RUN curl -O http://www.datagear.tech/download/version/${VERSION}/${ZIP_FILE}
RUN curl -O https://gitee.com/datagear/datagear/releases/download/v${VERSION}/${ZIP_FILE}

RUN jar -xvf ${ZIP_FILE}

RUN chmod +x /opt/${PACKAGE}/startup.sh
RUN chmod +x /opt/${PACKAGE}/shutdown.sh

ENV PATH="$PATH:/opt/${PACKAGE}"

CMD ["/opt/datagear-4.5.1/startup.sh"]
