FROM gcr.io/google_containers/hyperkube:v1.17.5
RUN sed -i -e 's!\bmain\b!main contrib!g' /etc/apt/sources.list && \
    apt-get update && apt-get upgrade -y && apt-get clean && \
    clean-install apt-transport-https gnupg1 curl zfsutils-linux \
    && echo "deb [arch=amd64] https://packages.microsoft.com/repos/azure-cli/ stretch main" > \
    /etc/apt/sources.list.d/azure-cli.list \
    && curl -L https://packages.microsoft.com/keys/microsoft.asc | apt-key add - \
    && apt-get purge gnupg \
    && clean-install \
    xfsprogs \
    open-iscsi \
    azure-cli

RUN echo "deb http://deb.debian.org/debian stretch-backports main" >> \
    /etc/apt/sources.list.d/backports.list \
    && clean-install -t stretch-backports glusterfs-client glusterfs-common
