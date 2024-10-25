K8S_VERSION?=v1.28.15

ARCH?=amd64
ALL_ARCH=amd64 arm64

IMAGE?=docker.io/rancher/hyperkube
TAGEND?=rancher1

K8S_STAGING:=$(shell mktemp -d)

K8S_SERVER_TARBALL=kubernetes-server-linux-$(ARCH).tar.gz

HYPERKUBE_BASE_VERSION = $(shell grep hyperkube-base Dockerfile | awk '{ print $$2 }' )

all: all-push

sub-build-%:
	$(MAKE) ARCH=$* build

all-build: $(addprefix sub-build-,$(ALL_ARCH))

sub-push-image-%:
	$(MAKE) ARCH=$* push

all-push-images: $(addprefix sub-push-image-,$(ALL_ARCH))

all-push: all-push-images push-manifest

k8s-tars/${K8S_VERSION}/${ARCH}/${K8S_SERVER_TARBALL}:
	mkdir -p k8s-tars/${K8S_VERSION}/${ARCH}
	cd k8s-tars/${K8S_VERSION}/${ARCH} && curl -sSLO --retry 5 https://dl.k8s.io/${K8S_VERSION}/${K8S_SERVER_TARBALL} \
	&& curl -sSLO --retry 5 https://github.com/rancher/kubernetes/releases/download/${K8S_VERSION}/kubelet-${K8S_VERSION}-${ARCH}.tar.gz
	
k8s-binaries: k8s-tars/${K8S_VERSION}/${ARCH}/$(K8S_SERVER_TARBALL)
	mkdir -p ${K8S_STAGING}/k8s-server-untarred
	tar -xz -C ${K8S_STAGING}/k8s-server-untarred -f "k8s-tars/${K8S_VERSION}/${ARCH}/${K8S_SERVER_TARBALL}"
	tar -xz -C ${K8S_STAGING}/k8s-server-untarred -f "k8s-tars/${K8S_VERSION}/${ARCH}/kubelet-${K8S_VERSION}-${ARCH}.tar.gz"

	mkdir -p ${K8S_STAGING}/k8s-binaries

	cp ${K8S_STAGING}/k8s-server-untarred/kubernetes/server/bin/kube-apiserver ${K8S_STAGING}/k8s-binaries
	cp ${K8S_STAGING}/k8s-server-untarred/kubernetes/server/bin/kube-controller-manager ${K8S_STAGING}/k8s-binaries
	cp ${K8S_STAGING}/k8s-server-untarred/kubernetes/server/bin/kube-proxy ${K8S_STAGING}/k8s-binaries
	cp ${K8S_STAGING}/k8s-server-untarred/kubernetes/server/bin/kube-scheduler ${K8S_STAGING}/k8s-binaries
	cp ${K8S_STAGING}/k8s-server-untarred/kubernetes/server/bin/kubectl ${K8S_STAGING}/k8s-binaries
	cp ${K8S_STAGING}/k8s-server-untarred/kubelet ${K8S_STAGING}/k8s-binaries
	
	mkdir -p k8s-binaries
	cp -r ${K8S_STAGING}/k8s-binaries/* k8s-binaries/
	rm -rf ${K8S_STAGING}

clean:
	rm -rf k8s-tars
	rm -rf k8s-binaries

build: k8s-binaries
	docker build --pull -t ${IMAGE}:${K8S_VERSION}-${TAGEND}-${ARCH} -f Dockerfile .

push: build
	docker push ${IMAGE}:${K8S_VERSION}-${TAGEND}-${ARCH} 

check-security:
	/drone/src/trivy image -s HIGH,CRITICAL --exit-code 1 $(HYPERKUBE_BASE_VERSION) || (echo "trivy found issues $$?"; exit 1)

.PHONY: all build push clean all-build all-push-images all-push push-manifest k8s-binaries

.DEFAULT_GOAL := build
