FROM openjdk:27-jdk

RUN microdnf install unzip

WORKDIR /opt
ENV VERSION=4.5.1
ENV PACKAGE=datagear-${VERSION}
ENV ZIP_FILE=${PACKAGE}.zip

#RUN curl -O http://www.datagear.tech/download/version/${VERSION}/${ZIP_FILE}
RUN curl -o datagear.zip -L https://gitee.com/datagear/datagear/releases/download/v5.5.0/datagear-5.5.0.zip
RUN unzip datagear.zip && rm -rf datagear.zip

RUN chmod +x /opt/${PACKAGE}/startup.sh
RUN chmod +x /opt/${PACKAGE}/shutdown.sh

ENV PATH="$PATH:/opt/${PACKAGE}"

CMD ["/opt/datagear-4.5.1/startup.sh"]
