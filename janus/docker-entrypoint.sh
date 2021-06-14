#!/usr/bin/env sh
set -e

loglevel="${loglevel:-}"
USERID=$(id -u)

# if the first argument look like a parameter (i.e. start with '-'), run Janus
if [ "${1#-}" != "$1" ]; then
    set -- janus "$@"
fi

if [ "$1" = 'janus' ]; then
    # set the log level if the $loglevel variable is set
    if [ -n "$loglevel" ]; then
        set -- "$@" --debug-level "$loglevel"
    fi
fi

if [ "$JANUS_UID" != "0" ] && [ "$USERID" = 0 ]; then
    if [ -n "$JANUS_UID" ]; then
        usermod -u "$JANUS_UID" janus
    fi
    if [ -n "$JANUS_GID" ]; then
        groupmod -g "$JANUS_GID" janus
    fi
    # Ensure the janus user is able to write to container logs
    chown janus:janus /dev/stdout /dev/stderr
fi 

export LD_LIBRARY_PATH=/usr/local/lib:$LD_LIBRARY_PATH
exec "${@}"
