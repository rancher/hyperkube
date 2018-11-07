FROM gcr.io/google_containers/hyperkube:v1.12.1@sha256:02c73330a4d5672ecf424221c3954c072c2190b7e89421ba994368e083181926
RUN clean-install apt-transport-https gnupg1 curl \
    && echo "deb [arch=amd64] https://packages.microsoft.com/repos/azure-cli/ stretch main" > \
    /etc/apt/sources.list.d/azure-cli.list \
    && curl -L https://packages.microsoft.com/keys/microsoft.asc | apt-key add - \
    && apt-get purge gnupg \
    && clean-install \
    xfsprogs \
    open-iscsi \
    azure-cli \
