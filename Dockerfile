FROM eclipse-temurin:21-jre-jammy

# 使用 apt 安装 unzip
RUN apt-get update && apt-get install -y unzip curl

WORKDIR /opt

ENV VERSION=5.5.0
ENV PACKAGE=datagear-${VERSION}
ENV ZIP_FILE=${PACKAGE}.zip

# 下载 datagear zip 文件
RUN curl -o datagear.zip -L https://gitee.com/datagear/datagear/releases/download/v5.5.0/datagear-5.5.0.zip

# 解压并删除 zip 文件
RUN unzip datagear.zip && rm -rf datagear.zip

# 修改启动脚本权限
RUN chmod +x /opt/${PACKAGE}/startup.sh
RUN chmod +x /opt/${PACKAGE}/shutdown.sh

# 将 datagear 的目录添加到 PATH
ENV PATH="$PATH:/opt/${PACKAGE}"

# 默认命令
CMD ["/opt/datagear-5.5.0/startup.sh"]
