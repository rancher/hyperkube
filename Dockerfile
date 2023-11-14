FROM rancher/hyperkube-base:v0.0.18

COPY k8s-binaries/kube* /usr/local/bin/
