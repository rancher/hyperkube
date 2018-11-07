FROM gcr.io/google_containers/hyperkube:v1.11.3@sha256:2c8ed99c06ad96e5e747838833ec7bb538a8ee64bef94004bad1659401265311
RUN clean-install apt-transport-https gnupg1 curl \
    && echo "deb [arch=arm64] https://packages.microsoft.com/repos/azure-cli/ stretch main" > \
    /etc/apt/sources.list.d/azure-cli.list \
    && curl -L https://packages.microsoft.com/keys/microsoft.asc | apt-key add - \
    && apt-get purge gnupg \
    && clean-install \
    xfsprogs \
    open-iscsi \
    azure-cli \
