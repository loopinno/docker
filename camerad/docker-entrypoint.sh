#!/usr/bin/env sh
set -e

loglevel="${loglevel:-}"
USERID=$(id -u)

# if the first argument look like a parameter (i.e. start with '-'), run camerad
if [ "${1#-}" != "$1" ]; then
    set -- camerad "$@"
fi

if [ "$1" = 'camerad' ]; then
    # set the log level if the $loglevel variable is set
    if [ -n "$loglevel" ]; then
        set -- "$@" --debug-level "$loglevel"
    fi
fi

if [ "$CAMERAD_UID" != "0" ] && [ "$USERID" = 0 ]; then
    if [ -n "$CAMERAD_UID" ]; then
        usermod -u "$CAMERAD_UID" camerad
    fi
    if [ -n "$CAMERAD_GID" ]; then
        groupmod -g "$CAMERAD_GID" camerad
    fi
    # Ensure the camerad user is able to write to container logs
    chown camerad:camerad /dev/stdout /dev/stderr
fi 

exec "${@}"
