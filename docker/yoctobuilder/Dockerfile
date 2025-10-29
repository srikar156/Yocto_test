FROM ubuntu:jammy

USER root
RUN apt-get update \
      && apt-get install -y sudo \
      && apt-get install -y wget \
      && apt-get install -y git \
      && apt-get install -y podman \
      && apt-get install -y python3-git \
      && apt-get install -y python3-yaml \
      && apt-get install -y python3-jsonschema \
      && apt-get install -y python3-distro \
      && apt-get install -y python3-kconfiglib \
      && apt-get install -y python3-pip \
      && apt-get install -y libssl-dev \
      && apt-get install -y locales \
      && apt-get install -y chrpath \
      && apt-get install -y diffstat \
      && apt-get install -y lz4 \
      && apt-get install -y binutils \
      && apt-get install -y build-essential \
      && apt-get install -y bzip2 \
      && apt-get install -y cpio \
      && apt-get install -y file \
      && apt-get install -y g++ \
      && apt-get install -y gawk \
      && apt-get install -y gcc \
      && apt-get install -y liblz4-tool \
      && apt-get install -y zstd \      
      && apt-get install -y unzip \   
      && apt-get install -y dnf \   
      && rm -rf /var/lib/apt/lists/* 

# Set the locale
RUN sed -i -e 's/# en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/' /etc/locale.gen && \
     dpkg-reconfigure --frontend=noninteractive locales && \
     update-locale LANG=en_US.UTF-8
ENV LANG=en_US.UTF-8  
ENV LANGUAGE=en_US:en  
ENV LC_ALL=en_US.UTF-8  
RUN pip install python-gnupg
COPY ./STMicroelectronics.zip /usr/local/bin/

