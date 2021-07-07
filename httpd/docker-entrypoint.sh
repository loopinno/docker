#!/usr/bin/env sh
set -e

USERID=$(id -u)

if [ "$HTTPD_UID" != "0" ] && [ "$USERID" = 0 ]; then
    if [ -n "$HTTPD_UID" ]; then
        usermod -u "$HTTPD_UID" httpd
    fi
    if [ -n "$HTTPD_GID" ]; then
        groupmod -g "$HTTPD_GID" httpd
    fi
    # Ensure the httpd user is able to write to container logs
    chown httpd:httpd /dev/stdout /dev/stderr
fi 

exec "${@}"
