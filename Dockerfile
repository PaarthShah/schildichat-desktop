FROM node:14

RUN apt-get -qq update && apt-get -qq install --no-install-recommends -y \
    curl \
    g++ \
    gcc \
    git \
    jq \
    libarchive-tools \
    libsecret-1-dev \
    libsqlcipher-dev \
    libssl-dev \
    make \
    openssl \
    pkg-config \
    python \
    tcl \
    vim

ENV RUSTUP_HOME=/usr/local/rustup \
    CARGO_HOME=/usr/local/cargo \
    PATH=/usr/local/cargo/bin:$PATH
RUN curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y --no-modify-path --profile minimal

WORKDIR /project