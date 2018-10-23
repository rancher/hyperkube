FROM gcr.io/google_containers/hyperkube:v1.9.7
RUN clean-install apt-transport-https gnupg1 \
    && echo "deb [arch=amd64] https://packages.microsoft.com/repos/azure-cli/ stretch main" > \
    /etc/apt/sources.list.d/azure-cli.list \
    && apt-key adv --keyserver packages.microsoft.com --recv-keys 417A0893 \
    && apt-get purge gnupg1 \
    && clean-install \
    xfsprogs \
    open-iscsi \
    azure-cli \
    curl \
