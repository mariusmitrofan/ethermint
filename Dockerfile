FROM golang:1.9.2

ARG VERSION=0.5.3

# Add ethermint app
ADD https://github.com/tendermint/ethermint/releases/download/v${VERSION}/ethermint_${VERSION}_linux-amd64.zip /tmp/ethermint.zip

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
COPY google_credentials.json /opt/

# Add script to mount google cloud storage bucket
COPY run.sh /

# Finish tendermint install
WORKDIR /tmp
RUN unzip /tmp/ethermint.zip
RUN mv ethermint /usr/local/bin/

ENTRYPOINT ["/run.sh"]
CMD ["ethermint"]
