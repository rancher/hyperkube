FROM gcr.io/google_containers/hyperkube:v1.13.1
RUN clean-install apt-transport-https gnupg1 curl ca-certificates gnupg2 software-properties-common \
    && curl -fsSL https://download.docker.com/linux/debian/gpg | apt-key add - \
    && add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/debian $(lsb_release -cs) stable" \
    && echo "deb [arch=amd64] https://packages.microsoft.com/repos/azure-cli/ stretch main" > \
    /etc/apt/sources.list.d/azure-cli.list \
    && curl -L https://packages.microsoft.com/keys/microsoft.asc | apt-key add - \
    && apt-get purge gnupg -y \
    && clean-install \
    xfsprogs \
    open-iscsi \
    azure-cli \
    docker-ce \
    docker-ce-cli \
    containerd.io
