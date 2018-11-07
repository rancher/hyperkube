# Hyperkube Images for Rancher

Rancher 2.0 is built off of Kubernetes upstream hyperkube images (gcr/google_containers/hyperkube).  This repo repackages the hyperkube images for Rancher.

There is now one folder per release of Kubernetes, and subsequently one per architecture to allow for multi-arch support.

## Requirements

* manifest-tool
* docker
  * docker server with binfmt_misc setup for multi-arch images (if you have docker for mac, it already does this for you)

## Building

The script currently builds all versions and all architectures.

```bash
bash build.sh
```

If you want to push to the registry, set `PUSH` to any value, assuming you've set other variables and permissions are correct everything will work.

### Change Repo Prefix

If you need to change the prefix of the images, `export REPO=ekristen`

This will result in images being built as `ekristen/hyperkube:VERSION-ARCH`

### Private Registry

If using a private registry, `export PRIVATE_REGISTRY=1`

You will also need to export REGISTRY_USERNAME and REGISTRY_PASSWORD for manifest publishing.

## Adding New Versions

Adding new versions is just about duplicating the existing folder structure for a previous image and updating the FROM. 

Once you know the version of hyperkube you are wanting to add, you can inspect it's manifest on the gcr.io registry to determine the digest to target.

```
docker manifest inspect gcr.io/google_containers/hyperkube:v1.12.1
```

Find the one for AMD64 and use the digest for the FROM address, repeat the process for other architectures you want to support.

## Debugging

If at any time you want to get more output from the script, set `DEBUG` to any value. 
