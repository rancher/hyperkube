#!/bin/bash

REPO=${REPO:-rancher}

docker build -t $REPO/hyperkube:dev .
docker push $REPO/hyperkube:dev
