#!/usr/bin/env bash

REPO="loopinno/l4t-opencv"

# versions 
L4T_VERSION="32.4.4"
OPENCV_VERSION="4.4.0"

# Display help 
function usage()
{
cat <<EOF
Usage: $(basename $0) [options] ...
OPTIONS:
    -h, --help             Display this help and exit.
    -t, --l4t <32.4.4>     Specify the version of L4T.
    -c, --opencv <4.4.0>   Specify the version of OpenCV.
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
    *)                  usage
                        exit 1
    esac
    shift
done

echo "L4T_VERSION: ${L4T_VERSION}"
echo "OPENCV_VERSION: ${OPENCV_VERSION}"

TAG="${L4T_VERSION}-${OPENCV_VERSION}"
IMAGE="${REPO}:${TAG}"

docker build \
    --build-arg L4T_VERSION=${L4T_VERSION} \
    --build-arg OPENCV_VERSION=${OPENCV_VERSION} \
    -t ${IMAGE} \
    .

echo "Built docker image ${IMAGE}"
