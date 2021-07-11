#!/usr/bin/env bash

REPO="loopinno/camerad"

# versions 
L4T_VERSION="32.4.4"
OPENCV_VERSION="ridgerun"
REVISION=""

# Display help 
function usage()
{
cat <<EOF
Usage: $(basename $0) [options] ...
OPTIONS:
    -h, --help                  Display this help and exit.
    -t, --l4t <version>         Specify the version of L4T.
    -c, --opencv <version>      Specify the version of OpenCV.
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
    -t | --l4t )        shift
                        L4T_VERSION=$1
                        ;;
    -c | --opencv )     shift
                        OPENCV_VERSION=$1
                        ;;
    -r | --revision )   shift
                        REVISION=$1
                        ;;
    *)                  usage
                        exit 1
    esac
    shift
done

echo "L4T_VERSION: ${L4T_VERSION}"
echo "OPENCV_VERSION: ${OPENCV_VERSION}"
echo "REVISION: ${REVISION}"

# tag and docker file 
TAG="${L4T_VERSION}-${OPENCV_VERSION}"
DOCKERFILE="Dockerfile"
if [ -n "$REVISION" ] ; then 
    TAG="${TAG}-${REVISION}"
    DOCKERFILE="${DOCKERFILE}.${REVISION}"
fi 
echo "DOCKERFILE: ${DOCKERFILE}"

# image 
IMAGE=${REPO}:${TAG}
echo "IMAGE: ${IMAGE}"

# base image
BASE="loopinno/l4t-opencv:${L4T_VERSION}-${OPENCV_VERSION}"
echo "BASE: ${BASE}"

docker build \
    --build-arg BASE=${BASE} \
    -f ${DOCKERFILE} \
    -t ${IMAGE} \
    .

echo "Built new docker image ${IMAGE}"
