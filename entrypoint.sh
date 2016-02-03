#!/bin/bash

if [ ! -z $DOWNGRADE ]; then
  echo Downgrading docker-engine to: $DOWNGRADE ...
  apt-get remove -y docker-engine
  apt-get autoremove
  apt-get autoclean
  apt-get install -y  docker-engine=${DOWNGRADE}~trusty
  echo "The new docker version is: "
  docker -v
fi

/opt/erlang_app/generate_release.sh

name=$IMAGE_APP_NAME
tagName=$IMAGE_TAG_NAME

if [ -e "/var/run/docker.sock" ] && [ -e "./Dockerfile" ];
then
  # Default TAG_NAME to package name if not set explicitly
  imageName="$name":${tagName:-latest}

  # Build the image from the Dockerfile in the package directory
  docker build -t $imageName .
fi
