#!/bin/sh
echo 0 > /tmp/port
/app/cleaner.sh &
socat TCP-LISTEN:1337,fork,nodelay,reuseaddr,pktinfo EXEC:"/usr/bin/timeout -k 5 ${TIMEOUT} /app/entrypoint.sh"
