#!/bin/bash

xhost +
sleep 1s
nvidia-docker run --rm --name orbslam -it \
	--env="DISPLAY" \
	--env="QT_X11_NO_MITSHM=1" \
	--volume="/tmp/.X11-unix:/tmp/.X11-unix:rw" \
	orbslam:latest

