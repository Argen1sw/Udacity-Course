# This gives the container access to the X server, 
# allowing GUI applications to run inside the container and display on the host machine.
xhost local:root


# XAUTH=/tmp/.docker.xauth

docker run -it \
    --user ros \
    --net=host \
    --ipc=host \
    -v $PWD/udacity-code:/home/ros_ws/src \
    -v /tmp/.X11-unix:/tmp/.X11-unix:rw \
    --env=DISPLAY \
    --env ROS_DOMAIN_ID=30 \
    -v /dev/input:/dev/input \
    --device-cgroup-rule='c 13:* rmw' \
    --runtime=nvidia \
    --gpus all \
    udacity-noetic-gazebo-11:latest \
    bash

echo "Done."