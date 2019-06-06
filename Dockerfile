FROM ubuntu:18.04 as builder
LABEL author="buzzkillb"
RUN apt-get update && apt-get install -y \
    git \
    wget \
    unzip \
    automake \
    build-essential \
    libdb++-dev \
    libboost-all-dev \
    libqrencode-dev \
    libminiupnpc-dev \
    libevent-dev \
    autogen \
    automake \
    libtool \
    make \
    libqt5gui5 \
    libqt5core5a \
    libqt5dbus5 \
    qttools5-dev \
    qttools5-dev-tools \
    qt5-default \
 && rm -rf /var/lib/apt/lists/*
RUN (wget https://www.openssl.org/source/openssl-1.0.1j.tar.gz && \
    tar -xzvf openssl-1.0.1j.tar.gz && \
    cd openssl-1.0.1j && \
    ./config && \
    make install && \
    ln -sf /usr/local/ssl/bin/openssl `which openssl` && \
    cd ~)
RUN (git clone https://github.com/carsenk/denarius && \
    cd denarius && \
    git checkout master && \
    git pull && \
    qmake "USE_UPNP=1" "USE_QRCODE=1" OPENSSL_INCLUDE_PATH=/usr/local/ssl/include OPENSSL_LIB_PATH=/usr/local/ssl/lib denarius-qt.pro && \
    make)

# final image
FROM ubuntu:18.04

RUN apt-get update && apt-get install -y \
    automake \
    build-essential \
    libdb++-dev \
    libboost-all-dev \
    libqrencode-dev \
    libminiupnpc-dev \
    libevent-dev \
    libtool \
 && rm -rf /var/lib/apt/lists/*

RUN mkdir -p /data

VOLUME ["/data"]

COPY --from=builder /usr/local/ssl/bin/openssl /usr/local/ssl/bin/openssl
COPY --from=builder /denarius/Denarius /usr/local/bin/

EXPOSE 33369 9999 9089

ENV DISPLAY=:0
ENV QT_GRAPHICSSYSTEM="native"

ENTRYPOINT ["Denarius", "--datadir=/data", "--printtoconsole"]
