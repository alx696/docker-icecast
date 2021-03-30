FROM alpine:3
ENV VERSION 2.4.4
WORKDIR /home
#复制资源文件夹中内容到WORKDIR中(不含resource文件夹)
COPY resource .
RUN set -eux && \
  #设置源
  echo "http://mirrors.ustc.edu.cn/alpine/latest-stable/main/" > /etc/apk/repositories && \
  echo "http://mirrors.ustc.edu.cn/alpine/latest-stable/community/" >> /etc/apk/repositories && \
  echo "http://mirrors.ustc.edu.cn/alpine/edge/testing/" >> /etc/apk/repositories && \
  apk update && \
  \
  #设置时区
  apk add --no-cache tzdata && \
  cp /usr/share/zoneinfo/Asia/Shanghai /etc/localtime && \
  echo "Asia/Shanghai" > /etc/timezone && \
  apk del tzdata && \
  #创建用户(这玩意不让以root运行)
  adduser --disabled-password --no-create-home nu nu && \
  #安装依赖
  apk add --no-cache --virtual bp build-base wget && \
  apk add --no-cache libxml2 libxslt-dev curl libogg-dev libvorbis-dev openssl && \
  #编译安装
  wget https://downloads.xiph.org/releases/icecast/icecast-${VERSION}.tar.gz && \
  tar zxf icecast-${VERSION}.tar.gz  && \
  cd icecast-${VERSION} && \
  ./configure && \
  make && \
  make install && \
  mkdir -p /usr/local/icecast/logs && \
  touch /usr/local/icecast/logs/error.log && \
  touch /usr/local/icecast/logs/access.log && \
  chown -R nu /usr/local/icecast/logs && \
  #清理
  rm -rf icecast-${VERSION}.tar.gz icecast-${VERSION} && \
  apk del bp

USER nu

ENTRYPOINT ["icecast", "-c", "/home/icecast.xml"]

EXPOSE 8000