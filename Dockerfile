FROM openjdk:8u275-jdk

WORKDIR /opt
ENV VERSION=4.5.1
ENV PACKAGE=datagear-${VERSION}
ENV ZIP_FILE=${PACKAGE}.zip

RUN curl -O http://www.datagear.tech/download/version/${VERSION}/${ZIP_FILE}

RUN unzip ${ZIP_FILE}

RUN chmod +x /opt/${PACKAGE}/startup.sh
RUN chmod +x /opt/${PACKAGE}/shutdown.sh

ENV PATH="$PATH:/opt/${PACKAGE}"

CMD ["/opt/datagear-4.5.1/startup.sh"]
