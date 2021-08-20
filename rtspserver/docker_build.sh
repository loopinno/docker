#!/usr/bin/env bash

REPO="loopinno/rtspserver"
BASE="arm64v8/ubuntu:18.04"

function usage()
{
cat <<EOF
Usage: $(basename $0) [options] ...
OPTIONS:
    -h, --help                  Display this help and exit.
    -b, --base [ubuntu:18.04]   Specify the base image.
EOF
exit 0
}

while [ $# -gt 0 ]
do
    case "$1" in
    -h | --help )       usage
                        exit
                        ;;
    -b | --base )       shift
                        BASE=$1
                        ;;
    *)                  usage
                        exit 1
    esac
    shift
done

echo "BASE: ${BASE}"

IMAGE="${REPO}:latest-${BASE//[$'/':]/-}"
echo "IMAGE: ${IMAGE}"

BUILD_IMAGE="${IMAGE}-build"
echo "BUILD_IMAGE: ${BUILD_IMAGE}"

docker build \
    --build-arg BASE="${BASE}" \
    --target build \
    -t "${BUILD_IMAGE}" \
    .

docker build \
    --build-arg BASE="${BASE}" \
    -t "${IMAGE}" \
    .
