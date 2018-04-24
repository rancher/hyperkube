FROM gcr.io/google_containers/hyperkube:v1.8.11
RUN clean-install apt-transport-https \
    && echo "deb [arch=amd64] https://packages.microsoft.com/repos/azure-cli/ wheezy main" > \
    /etc/apt/sources.list.d/azure-cli.list \
    && apt-key adv --keyserver packages.microsoft.com --recv-keys 417A0893 \
    && clean-install \
    xfsprogs \
    open-iscsi \
    azure-cli \
