#!/usr/bin/env bash
set -e

# setup ros environment
source "/opt/ros/$ROS_DISTRO/setup.bash"

USERID=$(id -u)

if [ "$ROS_UID" != "0" ] && [ "$USERID" = 0 ]; then
    if [ -n "$ROS_UID" ]; then
        usermod -u "$ROS_UID" ros
    fi
    if [ -n "$ROS_GID" ]; then
        groupmod -g "$ROS_GID" ros
    fi
    chown ros:ros /dev/stdout /dev/stderr
    exec su-exec ros "$@"
else 
    exec "$@"
fi 
