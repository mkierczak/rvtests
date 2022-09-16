FROM ubuntu:latest AS builder
MAINTAINER NBISweden <marcin.kierczak@scilifelab.se>
LABEL authors="Marcin Kierczak"
ARG REPO="https://github.com/mkierczak/rvtests.git"

RUN apt update -y && \
    apt upgrade -y && \
    apt clean && \
    apt install -y \
		bzip2 \
		g++ \
		gfortran \
		git \
		libz-dev \
		make \
		sudo \
		wget \
		zip && \
	rm -rf /var/lib/apt/lists/*

RUN mkdir /rvtests
WORKDIR /rvtests

RUN cd /rvtests && \
	git clone ${REPO} && \
	cd /rvtests/rvtests/ && \
	/rvtests/rvtests/build/linux/requirements.sh && \
	/rvtests/rvtests/build/linux/build.sh
	
FROM ubuntu:latest AS production

# COPY --from=verku/htslib-1.15.1:latest /htslib/tabix /usr/bin # container used for development
COPY --from=builder /rvtests/rvtests/executable /usr/bin/

# docker build -t quiestrho/rvtests:v1.0.0 .