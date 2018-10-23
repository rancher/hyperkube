FROM gcr.io/google_containers/hyperkube:v1.10.5
RUN clean-install apt-transport-https gnupg1 curl \
    && echo "deb [arch=amd64] https://packages.microsoft.com/repos/azure-cli/ stretch main" > \
    /etc/apt/sources.list.d/azure-cli.list \
    && curl -L https://packages.microsoft.com/keys/microsoft.asc | apt-key add - \
    && apt-get purge gnupg1 \
    && clean-install \
    xfsprogs \
    open-iscsi \
    azure-cli \
