FROM rancher/hyperkube-base:v0.0.13

COPY k8s-binaries/kube* /usr/local/bin/
