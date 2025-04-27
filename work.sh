#!/bin/bash

if ! podman ps | grep -q bluecmd-work; then
  podman rm bluecmd-work &> /dev/null
  podman run --name bluecmd-work \
    --network host \
    -d \
    -h $(hostname)-work \
    --add-host=$(hostname)-work:127.0.1.1 \
    -v /home/bluecmd/work:/home/bluecmd/work \
    cmd.nu/bluecmd-work \
    sleep infinity >/dev/null
fi

exec podman exec \
  -ti bluecmd-work \
  /usr/bin/env \
  LC_ALL=en_US.UTF-8 \
  TERM=$TERM \
  /usr/bin/sudo -u bluecmd -i

