#!/usr/bin/env bash

REPO="loopinno/opencv"
BASE="ubuntu:18.04"
VERSION="4.4.0"

function usage()
{
cat <<EOF
Usage: $(basename $0) [options] ...
OPTIONS:
    -h, --help                  Display this help and exit.
    -b, --base [ubuntu:18.04]   Specify the base image.
    -v, --version [0.0.0]       Specify the version.
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
    -v | --version )    shift
                        VERSION=$1
                        ;;
    *)                  usage
                        exit 1
    esac
    shift
done

echo "BASE: ${BASE}"

IMAGE="${REPO}:${VERSION}-${BASE//[$'/':]/-}"
echo "IMAGE: ${IMAGE}"

docker build \
    --build-arg BASE=${BASE} \
    --build-arg VERSION=${VERSION} \
    -t ${IMAGE} \
    .
