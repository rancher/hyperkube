#!/bin/bash

if [ "x${DEBUG}" != "x" ]; then
  set -x
fi

REPO=${REPO:-"rancher"}
PUSH=${PUSH:-""}

build_image() {
  pushd $1/$2

  echo "building version: $1, arch: $2"

  docker build -t $REPO/hyperkube:${1}-${2} .
  
  popd
}

push_manifest() {
  VERSION=${1} && shift

  cat > manifest.yml << EOM
image: ${REPO}/hyperkube:${VERSION}
manifests:
EOM

  for ARCH in "$@"; do
    PLATFORM_ARCH=${ARCH}
    if [ "${ARCH}" == "aarch64" ]; then
      PLATFORM_ARCH=arm64
    fi

    cat >> manifest.yml <<EOM
  - image: ${REPO}/hyperkube:${VERSION}-${ARCH}
    platform:
      architecture: ${PLATFORM_ARCH}
      os: linux
EOM
  done

  MANIFEST_OPTS=""
  if [ "x${PRIVATE_REGISTRY}" != "x" ]; then
    MANIFEST_OPTS = "--username ${REGISTRY_USERNAME} --password \"${REGISTRY_PASSWORD}\""
  fi

  manifest-tool $MANIFEST_OPTS push from-spec manifest.yml
}

for VERSION in $(ls -d v*); do
  for ARCH in $(ls -d $VERSION/*); do
    build_image $VERSION $(basename $ARCH)
  done
done

if [ "x${PUSH}" != "x" ]; then
  docker push $REPO/hyperkube

  if [ "x`which manifest-tool`" == "x" ]; then
    echo "Unable to push manifest, please install manifest-tool"
    exit 1
  fi

  if [ "x${REPO}" != "rancher" ]; then
    if [ "x${REGISTRY_USERNAME}" == "x" ]; then
      echo "Unable to push manifest, expect REGISTRY_USERNAME to be set"
      exit 1
    fi
  fi

  for VERSION in $(ls -d v*); do
    pushd $VERSION
    push_manifest $VERSION `ls -d *`
    rm -f manifest.yml
    popd
  done
fi

