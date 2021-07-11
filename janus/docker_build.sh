#!/usr/bin/env bash

REPO="loopinno/janus"
VERSION="0.11.3"
BASE="arm64v8/ubuntu:18.04"

function usage()
{
cat <<EOF
Usage: $(basename $0) [options] ...
OPTIONS:
    -h, --help                          Display this help and exit.
    -v, --version <0.0.0>               Specify the version.
    -b, --base <arm64v8/ubuntu:18.04>   Specify the base image.
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

echo "VERSION: ${VERSION}"
echo "BASE: ${BASE}"

TAG="${VERSION}-${BASE//[$'/':]/-}"
echo "TAG: ${TAG}"

## dev
IMAGE="${REPO}:${TAG}-dev"
echo "IMAGE: ${IMAGE}"

docker build \
    --build-arg BASE=${BASE} \
    --build-arg VERSION="${VERSION}" \
    --target="dev" \
    -t ${IMAGE} \
    .
    
## runtime
IMAGE="${REPO}:${TAG}"
echo "IMAGE: ${IMAGE}"

docker build \
    --build-arg BASE=${BASE} \
    --build-arg VERSION="${VERSION}" \
    -t ${IMAGE} \
    .
