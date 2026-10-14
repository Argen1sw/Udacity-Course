#!/bin/bash
# Starts the development container, or opens another terminal in it if it is already running.

IMAGE=udacity-noetic-gazebo-11:latest
NAME=udacity-dev

# Run from the repo folder so the udacity-code mount works no matter where the script is called from
cd "$(dirname "$0")"

# If the container is already running, just open another shell in it
if [ -n "$(docker ps -q -f name=^${NAME}$)" ]; then
    docker exec -it $NAME bash
    exit
fi

# This gives the container access to the X server,
# allowing GUI applications to run inside the container and display on the host machine.
# Only your own user is allowed (the container's "ros" user has the same UID).
xhost +SI:localuser:$(id -un)

# --rm removes the container on exit; the code is safe because it lives in the mounted udacity-code folder.
# The NVIDIA variables make OpenGL (Gazebo, RViz) render on the NVIDIA GPU instead of the CPU on this hybrid laptop.
docker run -it --rm \
    --name $NAME \
    --user ros \
    --net=host \
    --ipc=host \
    -v $PWD/udacity-code:/home/ros_ws/src \
    -v /tmp/.X11-unix:/tmp/.X11-unix:rw \
    --env=DISPLAY \
    --env ROS_DOMAIN_ID=30 \
    --env GAZEBO_MODEL_PATH=/home/ros_ws/src/myrobot/model \
    --env GAZEBO_PLUGIN_PATH=/home/ros_ws/src/myrobot/build \
    -v /dev/input:/dev/input \
    --device-cgroup-rule='c 13:* rmw' \
    --runtime=nvidia \
    --gpus all \
    --env NVIDIA_DRIVER_CAPABILITIES=all \
    --env __NV_PRIME_RENDER_OFFLOAD=1 \
    --env __GLX_VENDOR_LIBRARY_NAME=nvidia \
    $IMAGE \
    bash

echo "Done."
