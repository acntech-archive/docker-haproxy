#!/bin/sh
set -e

# Set up logging
service rsyslog start
touch /var/log/haproxy.log

# Tail the output if not muted
if [ -z "${HAPROXY_MUTED}" ]; then
	echo "Logging to STDOUT"
	tail -f /var/log/haproxy.log &
else
	echo "Logging is muted"
fi

# first arg is `-f` or `--some-option`
if [ "${1#-}" != "$1" ]; then
	set -- haproxy "$@"
fi

if [ "$1" = 'haproxy' ]; then
	# if the user wants "haproxy", let's use "haproxy-systemd-wrapper" instead so we can have proper reloadability implemented by upstream
	shift # "haproxy"
	set -- "$(which haproxy-systemd-wrapper)" -p /run/haproxy.pid "$@"
fi

exec "$@"
