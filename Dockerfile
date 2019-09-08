FROM openjdk:8-alpine
LABEL maintainer="Michael Peter Christen <mc@yacy.net>"

# build the image with (i.e.)
# docker build -t loklak_server/latest .

# start the image with (i.e.)
# docker run -d -p 9000:9000 <image>

# Create Volume for persistence
VOLUME ["/loklak_server/data"]

# loklak start
CMD ["/loklak_server/bin/start.sh", "-Idn"]

# setup locales
ENV LANG=en_US.UTF-8

# Expose the web interface ports
EXPOSE 9000 9443

# copy the required parts of the source code
ADD bin /loklak_server/bin/
ADD conf /loklak_server/conf/
ADD src /loklak_server/src/
ADD html /loklak_server/html/
ADD installation /loklak_server/installation/
ADD ssi /loklak_server/ssi/
ADD gradle /loklak_server/gradle/
ADD gradlew /loklak_server/
ADD build.gradle /loklak_server/
ADD settings.gradle /loklak_server/
ADD test/queries /loklak_server/test/queries/

# install required software
RUN apk update && apk add --no-cache bash

# compile loklak
RUN cd /loklak_server && ./gradlew build -x checkstyleMain -x checkstyleTest -x jacocoTestReport

# change config file
RUN sed -i 's/^\(upgradeInterval=\).*/\186400000000/' /loklak_server/conf/config.properties

# set current working directory to loklak_server
WORKDIR /loklak_server
