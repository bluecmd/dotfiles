#!/bin/bash

if ! docker ps | grep -q bluecmd-debian; then
  docker rm bluecmd-debian &> /dev/null
  docker run --name bluecmd-debian \
    -d \
    -h $(hostname)-debian \
    -v /home/bluecmd/work:/home/bluecmd/work \
    cmd.nu/bluecmd-debian \
    sleep infinity
fi

exec docker exec \
  -ti bluecmd-debian \
  /usr/bin/env \
  LC_ALL=en_US.UTF-8 \
  TERM=$TERM \
  /usr/bin/sudo -u bluecmd -i

