#!/bin/bash
set -e

cd $BASE_DIR/src/docker
docker build -t ${DOCKER_IMAGE} .