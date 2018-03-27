#!/bin/sh
set -e
set -o xtrace

docker build . -t drone-example:${DRONE_COMMIT_SHA}

# clean old images
CLEAN_FROM=11
OLD_IMAGES=$(docker images drone-example -q --no-trunc | uniq | sed -n "${CLEAN_FROM}"',$p')
if [ -n "${OLD_IMAGES}" ]; then
  docker rmi -f ${OLD_IMAGES};
fi
