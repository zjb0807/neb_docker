#docker run -it zjb0807/neb bash
FROM ubuntu:16.04

ENV TZ=Asia/Shanghai
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

RUN apt-get update && \
    apt-get -y install git wget sudo g++-4.8 build-essential libgflags-dev libsnappy-dev zlib1g-dev libbz2-dev liblz4-dev libzstd-dev && \
    apt-get -y install vim jq

# install go1.10.3
RUN cd /root && mkdir -p /root/gopath && \
    wget https://dl.google.com/go/go1.10.3.linux-amd64.tar.gz && \
    tar -zxf go1.10.3.linux-amd64.tar.gz && \
    rm -f go1.10.3.linux-amd64.tar.gz && \
    # Go env
    echo '' >> /root/bashrc && \
    echo '############### go env ###############' >> /root/bashrc && \
    echo 'export GOROOT=/root/go' >> /root/bashrc && \
    echo 'export GOPATH=/root/gopath' >> /root/bashrc && \
    echo 'export GOBIN=$GOPATH/bin' >> /root/bashrc && \
    echo 'export PATH=$GOROOT/bin:$GOBIN:$PATH' >> /root/bashrc && \
    echo '############### go env ###############' >> /root/bashrc && \
    echo '' >> /root/bashrc && \
    # env
    echo 'set -o vi' >> /root/bashrc && \
    echo '' >> /root/bashrc

# git clone rocksdb sourece code
RUN git clone https://github.com/facebook/rocksdb.git && \
    cd rocksdb && make shared_lib && make install-shared

# git clone go-nebulas sourece code
RUN git clone https://github.com/nebulasio/go-nebulas.git /root/gopath/src/github.com/nebulasio/go-nebulas && \
    cd /root/gopath/src/github.com/nebulasio/go-nebulas && \
    /bin/bash -c 'source /root/bashrc && \
    go get -u github.com/golang/dep/cmd/dep && \
    make dep && \
    make deploy-v8 && \
    make build'

# ubuntu bug:
# https://github.com/docker/for-linux/issues/395
RUN cat '/root/bashrc' >> /root/.bashrc && \
    rm -f /root/bashrc

WORKDIR /root/gopath/src/github.com/nebulasio/go-nebulas

CMD ["./neb"]
