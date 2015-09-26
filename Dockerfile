FROM mooxe/java8:latest

MAINTAINER FooTearth "footearth@gmail.com"

WORKDIR /root

ENV SCALA_VERSION 2.11.7
ENV SCALA_TARBALL http://www.scala-lang.org/files/archive/scala-$SCALA_VERSION.deb

# pre system update
RUN \

  echo "deb https://dl.bintray.com/sbt/debian /" | \
    tee -a /etc/apt/sources.list.d/sbt.list && \
  apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv 642AC823 && \

  apt-get install apt-transport-https

# system update
RUN \
  apt-get update && \
  apt-get update && \
  apt-get upgrade -y && \
  apt-get autoremove

# install scala
RUN \
  # apt-get install -y \
  #   scala scala-library scala-doc

  curl -SL http://apt.typesafe.com/repo-deb-build-0002.deb  -o repo-deb.deb  && \
  dpkg -i repo-deb.deb && \

  curl -SL $SCALA_TARBALL -o scala.deb && \
  dpkg -i scala.deb && \

  rm -f *.deb && \

  rm -f *.deb

# install sbt
RUN \
  apt-get install sbt && \
  sbt ++2.11.7 clean updateClassifiers compile && \
  rm -rf /root/target
COPY repositories /root/.sbt/repositories
