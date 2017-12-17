FROM golang:1.9.2

ARG VERSION=0.5.3

ADD https://github.com/tendermint/ethermint/releases/download/v${VERSION}/ethermint_${VERSION}_linux-amd64.zip /tmp/ethermint.zip

RUN apt-get update && apt-get install -y zip unzip

WORKDIR /tmp

RUN unzip /tmp/ethermint.zip

RUN mv ethermint /usr/local/bin/

CMD ["ethermint"]
