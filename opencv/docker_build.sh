#!/usr/bin/env bash

REPO="loopinno/opencv"
VERSION="4.4.0"
BASE="ubuntu:18.04"

function usage()
{
cat <<EOF
Usage: $(basename $0) [options] ...
OPTIONS:
    -h, --help                  Display this help and exit.
    -v, --version [0.0.0]       Specify the version of the image.
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

IMAGE="${REPO}:${VERSION}-${BASE//[$'/':]/-}"
echo "IMAGE: ${IMAGE}"
echo "BASE: ${BASE}"

docker build \
    --build-arg BASE=${BASE} \
    --build-arg VERSION=${VERSION} \
    -t ${IMAGE} \
    .
