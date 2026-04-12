## Set of instructions to run the code in a container using Docker


Build the image using the Dockerfile:


`docker build -t my_image . `

Runs the container using the image built previously and sharing one host directory that can be edited and use in the container (This host directory will be where the ros2 packages are):

`docker run -it --user ros -v $PWD/udacity-code:/home/ros_ws/src my_image`

Same as before but make the container share the same network stack as the host making it easier to communicate with robots in the same network:

`docker run -it --user ros --network=host --ipc=host -v $PWD/udacity-code:/home/ros_ws/src my_image`


### Running GUI application such as RViz2 or Gazebo using the container:

This can be achieve by using X11.

First the users needs to have access to X Display therefore run in the terminal (this can be )

` xhost + `

Then the commands to run the container needs to have a volume attach and a new env variable that tells which display to use
This is quite similar to the bash files that i created previously, hence all this long command can be on a bash

`docker run -it --user ros --network=host --ipc=host -v $PWD/udacity-code:/home/ros_ws/src -v /tmp.X11-unix:/tmp/.X11-unix:rw --env=DISPLAY --env ROS_DOMAIN_ID=30  my_image`


### In order to use a controller from the container use:

Reference from: https://www.youtube.com/watch?v=uf4zOigzTFo&list=PLunhqkrRNRhaqt0UfFxxC_oj7jscss2qe 

To allow devices such joystick to be utilize on the container add arguments below to the whole command:

` -v /dev/input:/dev/input --device-cgroup-rule='c 13:* rmw' `

As such:

`docker run -it --user ros --network=host --ipc=host -v $PWD/udacity-code:/home/ros_ws/src -v /tmp.X11-unix:/tmp/.X11-unix:rw --env=DISPLAY --env ROS_DOMAIN_ID=30 -v /dev/input:/dev/input --device-cgroup-rule='c 13:* rmw' my_image `