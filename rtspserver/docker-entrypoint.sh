#!/usr/bin/env sh
set -e

USERID=$(id -u)

if [ "$RTSP_UID" != "0" ] && [ "$USERID" = 0 ]; then
    if [ -n "$RTSP_UID" ]; then
        usermod -u "$RTSP_UID" rtsp
    fi
    if [ -n "$RTSP_GID" ]; then
        groupmod -g "$RTSP_GID" rtsp
    fi
    chown rtsp:rtsp /dev/stdout /dev/stderr
    exec su-exec rtsp "$@"
else 
    exec "$@"
fi 
