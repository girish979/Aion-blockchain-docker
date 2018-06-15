FROM ubuntu:16.04

ENV AION_MINING_ADDRESS=0xa000a91ce631e7fea365d9b18732eb9490ef5f6e2c3329b97845d6a9c05477d7

WORKDIR /build

# Install tools and dependencies
RUN apt-get update && \
        apt-get install -y \
        curl \
        wget \
        jq \
        bzip2 \
        lsb-release \
        locales

# Download latest AION Kernel
RUN curl -s https://api.github.com/repos/aionnetwork/aion/releases/latest | jq --raw-output '.assets[0] | .browser_download_url' | xargs wget -O kernel.tar.bz2
RUN tar -xvjf ./kernel.tar.bz2

# Set the locale. Issue ASCII/UTF-8 in writing config XML file
RUN apt-get clean && apt-get update && apt-get install -y locales
RUN locale-gen en_US.UTF-8
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US:en
ENV LC_ALL en_US.UTF-8

# Start AION kernel
RUN sed "s/<miner-address>.*\/miner-address>/<miner-address>$AION_MINING_ADDRESS<\/miner-address>/g" -i ./aion/config/config.xml 

RUN grep 'miner-add' ./aion/config/config.xml 
RUN ./aion/aion.sh
