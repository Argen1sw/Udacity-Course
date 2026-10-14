## Set of instructions to run the code in a container using Docker

The image uses ROS 1 Noetic with Gazebo 11 (`osrf/ros:noetic-desktop-full`).


### Quick start

Build the image once (only needed again if the Dockerfile, `entrypoint.sh` or `bashrc` change):

`docker build -t udacity-noetic-gazebo-11 .`

Start the container (can be run from any folder):

`./run_container_bash_script.bash`

Running the script again while the container is up opens a second terminal in the same container.
The container is removed when you exit its first terminal (`--rm`). Your code is not lost, because it lives in the
mounted `udacity-code` folder on the host. Anything installed inside the container (e.g. with `apt`) is lost; add it to the Dockerfile instead.


### What the script does

Shares the host directory `udacity-code` with the container at `/home/ros_ws/src`, so code can be edited on the host and used in the container:

`-v $PWD/udacity-code:/home/ros_ws/src`

Makes the container share the same network stack as the host, making it easier to communicate with robots in the same network:

`--network=host --ipc=host`

Sets the Gazebo paths so the project's models and the built plugin are found:

`--env GAZEBO_MODEL_PATH=/home/ros_ws/src/myrobot/model --env GAZEBO_PLUGIN_PATH=/home/ros_ws/src/myrobot/build`


### Running GUI applications such as RViz or Gazebo using the container:

This can be achieved by using X11.

First the container needs access to the X display. This only allows your own user (the container's `ros` user has the same UID):

`xhost +SI:localuser:$(id -un)`

Then the container needs the X11 socket mounted and the env variable that tells which display to use:

`-v /tmp/.X11-unix:/tmp/.X11-unix:rw --env=DISPLAY`


### Using the NVIDIA GPU

This laptop has both an NVIDIA and an AMD GPU. Without the options below, OpenGL inside the container fails to load
the AMD driver and Gazebo renders on the CPU (very slow, high CPU usage):

`--runtime=nvidia --gpus all --env NVIDIA_DRIVER_CAPABILITIES=all --env __NV_PRIME_RENDER_OFFLOAD=1 --env __GLX_VENDOR_LIBRARY_NAME=nvidia`

`NVIDIA_DRIVER_CAPABILITIES=all` makes Docker add NVIDIA's OpenGL libraries to the container, and the other two
variables tell OpenGL to use the NVIDIA GPU. To check, run `glxinfo -B` in the container (from the `mesa-utils` package):
the renderer should mention NVIDIA.


### In order to use a controller from the container use:

Reference from: https://www.youtube.com/watch?v=uf4zOigzTFo&list=PLunhqkrRNRhaqt0UfFxxC_oj7jscss2qe

To allow devices such as a joystick to be used in the container, the script adds:

`-v /dev/input:/dev/input --device-cgroup-rule='c 13:* rmw'`


### Building and running the project inside the container

```bash
cd /home/ros_ws/src/myrobot
mkdir -p build && cd build && cmake .. && make && cd ..
gazebo world/project1_world
```
