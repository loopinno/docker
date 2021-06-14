#!/usr/bin/env sh
set -e

loglevel="${loglevel:-}"
USERID=$(id -u)

# if the first argument look like a parameter (i.e. start with '-'), run rtspd
if [ "${1#-}" != "$1" ]; then
    set -- rtspd "$@"
fi

if [ "$1" = 'rtspd' ]; then
    # set the log level if the $loglevel variable is set
    if [ -n "$loglevel" ]; then
        set -- "$@" --log-level "$loglevel"
    fi
fi

if [ "$RTSPD_UID" != "0" ] && [ "$USERID" = 0 ]; then
    if [ -n "$RTSPD_UID" ]; then
        usermod -u "$RTSPD_UID" rtspd
    fi
    if [ -n "$RTSPD_GID" ]; then
        groupmod -g "$RTSPD_GID" rtspd
    fi
    # Ensure the rtspd user is able to write to container logs
    chown rtspd:rtspd /dev/stdout /dev/stderr
fi 

exec "${@}"
