FROM alpine:3.3

ARG S3FS_VERSION=v1.86

COPY . q/ /q/
COPY . src/ /src/
COPY . logs/ /logs/
COPY configure.sh configure.sh

ENV S3_MOUNT_POINT /var/s3hdb
ENV QHOME=/q
ENV PATH=${PATH}:${QHOME}/l32

RUN apk --update --no-cache add fuse=2.9.4-r1 alpine-sdk=0.4-r3 automake=1.15-r0 autoconf=2.69-r0 libxml2-dev=2.9.4-r3 fuse-dev=2.9.4-r1 curl-dev=7.55.0-r2 git=2.8.6-r0 bash=4.3.42-r6; 

RUN wget "http://ftp.us.debian.org/debian/pool/main/g/glibc/libc6-i386_2.19-18+deb8u10_amd64.deb";
SHELL ["/bin/ash", "-c", "echo \"aeee7bebb8e957e299c93c884aba4fa9 libc6-i386_2.19-18+deb8u10_amd64.deb\" | md5sum -c - "]
SHELL ["/bin/ash", "-c", "ar p libc6-i386_2.19-18+deb8u10_amd64.deb data.tar.xz | unxz | tar -x"]
RUN rm -rf libc6-i386_2.19-18+deb8u10_amd64.deb /usr/share/doc/libc6-i386 /usr/lib32/gconv /usr/share/lintian;

RUN git clone https://github.com/s3fs-fuse/s3fs-fuse.git;

WORKDIR /s3fs-fuse

RUN git checkout tags/${S3FS_VERSION}; \
    ./autogen.sh; \
    ./configure --prefix=/usr; \
    make; \
    make install; \
    make clean; \
    rm -rf /var/cache/apk/*; \
    apk del git automake autoconf;

WORKDIR /

RUN mkdir -p "${S3_MOUNT_POINT}"

EXPOSE 80

CMD ["bash", "-c", "./configure.sh"]
