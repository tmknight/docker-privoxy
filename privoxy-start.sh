#!/bin/bash

CONFIG=${CONFFILE:-/data/privoxy/config}
PID=${PIDFILE:-/var/run/privoxy.pid}

if [ -f "${CONFIG}" ]
then
	/usr/sbin/privoxy --no-daemon --pidfile "${PID}" "${CONFIG}"
else
	echo "Configuration file ${CONFIG} not found!"
	exit 1
fi
