#!/usr/bin/env bash

REPO="loopinno/httpd"
TAG="latest"
BASE="ubuntu:18.04"
ARCH="x64"

function usage()
{
cat <<EOF
Usage: $(basename $0) [options] ...
OPTIONS:
    -h, --help                  Display this help and exit.
    -t, --tag [0.0.0 | latest]  Specify the tag of the image.
    -b, --base [ubuntu:18.04]   Specify the base image.
    -a, --arch [x64 | arm64]    Specify the architecture.
EOF
exit 0
}

while [ $# -gt 0 ]
do
    case "$1" in
    -h | --help )       usage
                        exit
                        ;;
    -t | --tag )        shift
                        TAG=$1
                        ;;
    -b | --base )       shift
                        BASE=$1
                        ;;
    -a | --arch )       shift
                        ARCH=$1
                        ;;
    *)                  usage
                        exit 1
    esac
    shift
done

IMAGE="${REPO}:${TAG}"
DOCKERFILE="Dockerfile"
if [ -n "$ARCH" ] ; then 
    IMAGE="${IMAGE}-${ARCH}"
    DOCKERFILE="${DOCKERFILE}.${ARCH}"
fi 
echo "IMAGE: ${IMAGE}"
echo "DOCKERFILE: ${DOCKERFILE}"

docker build \
    -f ${DOCKERFILE} \
    -t ${IMAGE} \
    .
