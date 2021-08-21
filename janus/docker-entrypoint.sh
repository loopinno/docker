#!/usr/bin/env sh
set -e

export LD_LIBRARY_PATH=/usr/local/lib:$LD_LIBRARY_PATH

loglevel="${loglevel:-}"

if [ "$1" = 'janus' ]; then
    if [ -n "$loglevel" ]; then
        set -- "$@" --debug-level "$loglevel"
    fi
fi

USERID=$(id -u)

if [ "$JANUS_UID" != "0" ] && [ "$USERID" = 0 ]; then
    if [ -n "$JANUS_UID" ]; then
        usermod -u "$JANUS_UID" janus
    fi
    if [ -n "$JANUS_GID" ]; then
        groupmod -g "$JANUS_GID" janus
    fi
    chown janus:janus /dev/stdout /dev/stderr
    exec su-exec janus "$@"
else 
    exec "$@"
fi 
