# hyperkube container images for RKE clusters

The source repository for the `rancher/hyperkube` image used by RKE clusters. The image contains everything needed to run each Kubernetes component in a container. Images are automatically pushed to [Docker Hub](https://hub.docker.com/r/rancher/hyperkube/tags) on tag. See [Versioning and Releasing](#versioning-and-releasing) for more information about the tags. There is a branch for each minor Kubernetes version.

## kubelet binary source change

Due to an issue with cri-dockerd causing high cpu usage when collecting metrics from the Docker daemon, we started to package the `kubelet` binary from our own source ([`rancher/kubernetes`](https://github.com/rancher/kubernetes)) starting with the following versions:

- `v1.24.10-rancher3` and higher
- `v1.25.6-rancher3` and higher
- `v1.26.4-rancher1` and higher

More information about the high cpu usage issue can be found in [this issue](https://github.com/rancher/rancher/issues/38816).

## Updating and Building

* Check out the correct branch for the minor version
* Check if the latest `rancher/hyperkube-base` image is used in the `Dockerfile`
* Change `K8S_VERSION` in `Makefile` to the correct version
* Run `make build` to build an image with the new version

## Versioning and Releasing

Tags contain the Kubernetes version and a suffix (default `-rancher1`), for example `v1.26.7-rancher1`. The suffix indicates the version iteration of the image. If there is a change in the `rancher/hyperkube` image for the same Kubernetes patch version, the number in the suffix will be incremented. 

If you are releasing a new Kubenetes patch version, the suffix should be `-rancher1`. If you are making a change in an existing Kubernetes version, you should increment the number in the suffix (if current suffix is `-rancher1`, the new suffix will be `-rancher2`).

To release a new `rancher/hyperkube` image:

* Make sure you have checked out the correct branch and that the branch is up-to-date
* Create the correct tag
* Push the tag

Check [Drone Publish](https://drone-publish.rancher.io/rancher/hyperkube) for the build progress.

## Dependencies

* [`rancher/hyperkube-base`](https://github.com/rancher/hyperkube-base): The base image used by `rancher/hyperkube`
* Upstream Kubernetes server binaries, published on each GitHub release in [`kubernetes/kubernetes`](https://github.com/kubernetes/kubernetes/releases)
* [`rancher/kubernetes`](https://github.com/rancher/kubernetes): The source for building our own kubelet binary (see [kubelet binary source change](#kubelet-binary-source-change) for more info)
