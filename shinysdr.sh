#!/bin/bash

# start required services
sudo service dbus start
sudo service avahi-daemon start

# config directory management
# if /app volume was mounted, then /app should exist. If not, create one for demonstration.
sudo mkdir -p /app
# ensure user ownership
sudo chown shinysdr: /app
# if /app is empty, then no config is available, so create one.
if [ -z "$(ls -A /app)" ]; then
    shinysdr --create ~/app/
    mv ~/app/* /app
fi

shinysdr $@