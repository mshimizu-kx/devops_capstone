FROM ubuntu:20.04

COPY . q/ /q/
COPY . src/ /src/
COPY . logs/ /logs/

WORKDIR /src

RUN apt-get -y update
RUN apt-get install -y rlwrap

ENV QHOME=/q
ENV PATH=${PATH}:${QHOME}/l64

CMD q init_hdb.q >> /logs/hdb_$(date +%Y%m%d_%H%M%S).log 2>&1