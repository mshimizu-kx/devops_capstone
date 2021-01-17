FROM ubuntu:20.04

COPY . q/ /q/
COPY . src/ /src/
COPY . logs/ /logs/

WORKDIR /src

ENV S3_MOUNT_POINT /var/s3hdb
ENV QHOME=/q
ENV PATH=${PATH}:${QHOME}/l64

RUN apt-get -y update
RUN apt-get install -y rlwrap
RUN DEBIAN_FRONTEND=noninteractive TZ=Asia/Tokyo apt-get install -y s3fs
RUN mkdir -p ${S3_MOUNT_POINT}

CMD ./configure.sh; q init_hdb.q >> /logs/hdb_$(date +%Y%m%d_%H%M%S).log 2>&1