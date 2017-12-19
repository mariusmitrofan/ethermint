FROM golang:1.9.2

ARG ETHERMINT_VERSION=0.5.3
ARG TENDERMINT_VERSION=0.14.0

# Install pre-requisites
RUN apt-get update && apt-get install -y zip unzip curl apt-transport-https

# Add gcsfuse to store data in google cloud storage buckets
RUN echo "deb http://packages.cloud.google.com/apt gcsfuse-xenial main" | tee /etc/apt/sources.list.d/gcsfuse.list && \
    curl https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key add - && \
    apt-get update && apt-get install -y gcsfuse

# Add gcloud library to authenticate against google cloud storage
RUN echo "deb https://packages.cloud.google.com/apt cloud-sdk-xenial main" | tee /etc/apt/sources.list.d/google-cloud-sdk.list && \
    curl https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key add - && \
    apt-get update && apt-get install -y google-cloud-sdk

# Add google cloud storage credentials
ENV GOOGLE_APPLICATION_CREDENTIALS=/opt/google_credentials.json
ENV FUSE_MOUNT_DIR=/mount

# Add ethermint app
ADD https://github.com/tendermint/ethermint/releases/download/v${ETHERMINT_VERSION}/ethermint_${ETHERMINT_VERSION}_linux-amd64.zip /tmp/ethermint.zip

# Add tendermint app
ADD https://github.com/tendermint/tendermint/releases/download/v${TENDERMINT_VERSION}/tendermint_${TENDERMINT_VERSION}_linux_amd64.zip /tmp/tendermint.zip

# Add script to mount google cloud storage bucket
COPY run.sh /

# Finish ethermint+tendermint install
WORKDIR /tmp
RUN unzip /tmp/ethermint.zip && mv ethermint /usr/local/bin/ && \
    unzip /tmp/tendermint.zip && mv tendermint /usr/local/bin/

ENTRYPOINT ["/run.sh"]
CMD ["ethermint"]
