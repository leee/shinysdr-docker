#!/bin/bash

# start required services
service dbus start
service avahi-daemon start

# config directory management
# if /app volume was mounted, then /app should exist. If not, create one for demonstration.
mkdir -p /app
# ensure user ownership
chown shinysdr: /app
# if /app is empty, then no config is available, so create one.
if [ -z "$(ls -A /app)" ]; then
    su - shinysdr -c "shinysdr --create ~/app/"
    su - shinysdr -c "mv ~/app/* /app"
fi

su - shinysdr -c "shinysdr $@"