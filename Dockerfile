FROM openjdk:21-jdk

RUN microdnf install unzip

WORKDIR /opt
ENV VERSION=4.5.1
ENV PACKAGE=datagear-${VERSION}
ENV ZIP_FILE=${PACKAGE}.zip

#RUN curl -O http://www.datagear.tech/download/version/${VERSION}/${ZIP_FILE}
RUN curl -o datagear.zip -L https://gitee.com/datagear/datagear/releases/download/v4.5.1/datagear-4.5.1.zip

RUN unzip datagear.zip

RUN chmod +x /opt/${PACKAGE}/startup.sh
RUN chmod +x /opt/${PACKAGE}/shutdown.sh

ENV PATH="$PATH:/opt/${PACKAGE}"

CMD ["/opt/datagear-4.5.1/startup.sh"]
