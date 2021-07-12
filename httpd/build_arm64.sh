#!/usr/bin/env bash

REPO="loopinno/httpd"
VERSION=""
BASE="arm64v8/ubuntu:18.04"

function usage()
{
cat <<EOF
Usage: $(basename $0) [options] ...
OPTIONS:
    -h, --help                          Display this help and exit.
    -v, --version [0.0.0 | latest]      Specify the version of the image.
    -b, --base [arm64v8/ubuntu:18.04]   Specify the base image.
EOF
exit 0
}

while [ $# -gt 0 ]
do
    case "$1" in
    -h | --help )       usage
                        exit
                        ;;
    -v | --version )    shift
                        VERSION=$1
                        ;;
    -b | --base )       shift
                        BASE=$1
                        ;;
    *)                  usage
                        exit 1
    esac
    shift
done

IMAGE="${REPO}"
if [ -z "${VERSION}" ] ; then 
    IMAGE="${IMAGE}:latest"
else 
    IMAGE="${IMAGE}:${VERSION}"
fi 
IMAGE="${IMAGE}-${BASE//[$'/':]/-}"
echo "IMAGE: ${IMAGE}"

DOCKERFILE="Dockerfile.arm64"
echo "DOCKERFILE: ${DOCKERFILE}"

docker build \
    --build-arg BASE=${BASE} \
    -f ${DOCKERFILE} \
    -t ${IMAGE} \
    .
