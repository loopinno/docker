#!/usr/bin/env bash

REPO="loopinno/ros"
BASE="loopinno/opencv:ridgerun-l4t-base-r32.4.4"

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

TAG="${BASE##*/}"
IMAGE="${REPO}:${TAG//[$'/':]/-}"
echo "IMAGE: ${IMAGE}"

docker build \
    --build-arg BASE="${BASE}" \
    -t "${IMAGE}" \
    .
