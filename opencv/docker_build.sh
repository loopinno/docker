#!/usr/bin/env bash

REPO="loopinno/opencv"
VERSION="4.4.0"
BASE="nvcr.io/nvidia/l4t-base:r32.4.4"
REVISION=""

function usage()
{
cat <<EOF
Usage: $(basename $0) [options] ...
OPTIONS:
    -h, --help                          Display this help and exit.
    -v, --version <0.0.0>               Specify the version.
    -b, --base <arm64v8/ubuntu:18.04>   Specify the base image.
    -r, --revision <ridgerun>           Specify the revision.
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
    -r | --revision )   shift
                        REVISION=$1
                        ;;
    *)                  usage
                        exit 1
    esac
    shift
done

echo "VERSION: ${VERSION}"
echo "BASE: ${BASE}"
echo "REVISON: ${REVISON}"

TAG="${VERSION}-${BASE//[$'/':]/-}"
DOCKERFILE="Dockerfile"
if [ -n "$REVISION" ] ; then 
    TAG="${TAG}-${REVISION}"
    DOCKERFILE="${DOCKERFILE}.${REVISION}"
fi 
echo "TAG: ${TAG}"
echo "DOCKERFILE: ${DOCKERFILE}"

## dev
IMAGE="${REPO}:${TAG}-dev"
echo "IMAGE: ${IMAGE}"

docker build \
    --build-arg BASE=${BASE} \
    --build-arg VERSION="${VERSION}" \
    --target="dev" \
    -f ${DOCKERFILE} \
    -t ${IMAGE} \
    .
    
## runtime
IMAGE="${REPO}:${TAG}"
echo "IMAGE: ${IMAGE}"

docker build \
    --build-arg BASE=${BASE} \
    --build-arg VERSION="${VERSION}" \
    -f ${DOCKERFILE} \
    -t ${IMAGE} \
    .
