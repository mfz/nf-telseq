FROM --platform=linux/amd64 ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive
ENV SAMTOOLS_VERSION=1.23
ENV HTSLIB_VERSION=1.23
ENV BAMTOOLS_VERSION=2.5.2


# Install build dependencies (pinned via Ubuntu release)
RUN apt-get update && apt-get install -y \
    build-essential=12.9ubuntu3 \
    wget \
    curl \
    ca-certificates \
    git \
    autoconf \
    automake \
    pkg-config \
    cmake \
    zlib1g-dev \
    libbz2-dev \
    liblzma-dev \
    libcurl4-openssl-dev \
    libssl-dev \
    libncurses5-dev \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /opt

# Build htslib
RUN wget https://github.com/samtools/htslib/releases/download/${HTSLIB_VERSION}/htslib-${HTSLIB_VERSION}.tar.bz2 \
    && tar -xjf htslib-${HTSLIB_VERSION}.tar.bz2 \
    && cd htslib-${HTSLIB_VERSION} \
    && ./configure --enable-libcurl \
    && make -j4 \
    && make install

# Build samtools
RUN wget https://github.com/samtools/samtools/releases/download/${SAMTOOLS_VERSION}/samtools-${SAMTOOLS_VERSION}.tar.bz2 \
    && tar -xjf samtools-${SAMTOOLS_VERSION}.tar.bz2 \
    && cd samtools-${SAMTOOLS_VERSION} \
    && ./configure \
    && make -j4 \
    && make install

# Build bamtools
RUN wget https://github.com/pezmaster31/bamtools/archive/refs/tags/v${BAMTOOLS_VERSION}.tar.gz \
    && tar -xzf v${BAMTOOLS_VERSION}.tar.gz \
    && cd bamtools-${BAMTOOLS_VERSION} \
    && mkdir build \
    && cd build \
    && cmake -DCMAKE_INSTALL_PREFIX=/usr/local .. \
    && make -j4 \
    && make install

# Build Telseq from pinned commit
RUN git clone https://github.com/zd1/telseq.git \
    && cd telseq/src \
    && ./autogen.sh \
    && ./configure --with-bamtools=/usr/local \
    && make \
    && cp Telseq/telseq /usr/local/bin/

WORKDIR /data

CMD ["/bin/bash"]