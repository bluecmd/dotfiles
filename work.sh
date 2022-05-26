#!/bin/bash

if ! docker ps | grep -q bluecmd-work; then
  docker rm bluecmd-work &> /dev/null
  docker run --name bluecmd-work \
    --network host \
    -d \
    -h $(hostname)-work \
    -v /home/bluecmd/work:/home/bluecmd/work \
    cmd.nu/bluecmd-work \
    sleep infinity
fi

exec docker exec \
  -ti bluecmd-work \
  /usr/bin/env \
  LC_ALL=en_US.UTF-8 \
  TERM=$TERM \
  /usr/bin/sudo -u bluecmd -i

