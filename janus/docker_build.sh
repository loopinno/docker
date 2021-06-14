#!/usr/bin/env bash

REPO="loopinno/janus"

# versions 
BASE=docker.io/arm64v8/ubuntu:18.04
TAG="ubuntu-18.04-arm64v8"
REVISION=""

# Display help 
function usage()
{
cat <<EOF
Usage: $(basename $0) [options] ...
OPTIONS:
    -h, --help                  Display this help and exit.
    -b, --base <repo>           Specify the base of the image.
    -t, --tag <tag>             Specify the tag of the image.
    -r, --revision <version>    Specify the version of revision.
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
    -t | --tag )        shift
                        TAG=$1
                        ;;
    -r | --revision )   shift
                        REVISION=$1
                        ;;
    *)                  usage
                        exit 1
    esac
    shift
done

echo "BASE: ${BASE}"
echo "TAG: ${TAG}"
echo "REVISION: ${REVISION}"

# revision 
DOCKERFILE="Dockerfile"
if [ -n "$REVISION" ] ; then 
    DOCKERFILE="${DOCKERFILE}.${REVISION}"
    TAG="${TAG}-${REVISION}"
fi 
echo "DOCKERFILE: ${DOCKERFILE}"
echo "TAG: ${TAG}"

# image 
IMAGE=${REPO}:${TAG}
echo "IMAGE: ${IMAGE}"

docker build \
    --build-arg BASE=${BASE} \
    -f ${DOCKERFILE} \
    -t ${IMAGE} \
    .

echo "Built new docker image ${IMAGE}"
