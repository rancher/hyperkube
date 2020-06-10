FROM gcr.io/google_containers/hyperkube:v1.17.6
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
        /etc/apt/sources.list.d/backports.list && apt-get update
RUN apt-get install -y python3 python3-prettytable python3-requests
RUN curl https://download.gluster.org/pub/gluster/glusterfs/6/6.9/Debian/9/amd64/apt/pool/main/g/glusterfs/glusterfs-common_6.9-1_amd64.deb > glusterfs-common.deb
RUN curl https://download.gluster.org/pub/gluster/glusterfs/6/6.9/Debian/9/amd64/apt/pool/main/g/glusterfs/glusterfs-client_6.9-1_amd64.deb > glusterfs-client.deb
RUN dpkg -i glusterfs-common.deb
RUN dpkg -i glusterfs-client.deb
