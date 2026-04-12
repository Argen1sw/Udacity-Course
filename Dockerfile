# Use the official ROS 2 Humble image as the base image

FROM osrf/ros:noetic-desktop-full

# Set the working directory
RUN apt-get update 

#  Install necessary packages and tools
RUN apt-get install -y \
git \
python3-pip \
nano \
cmake \
python3-rosdep \
python3-rosinstall \
python3-rosinstall-generator \
python3-wstool \
build-essential \
# Clean up apt cache to reduce image size
&& rm -rf /var/lib/apt/lists/* 

# Create a directory for the ROS 2 workspace
RUN mkdir -p /home/ros_ws/src

COPY udacity-code /home/ros_ws/src

ARG USERNAME=ros
ARG USER_UID=1000
ARG USER_GID=$USER_UID

# Create a non-root user and set permissions for the ROS 2 workspace
RUN groupadd --gid $USER_GID $USERNAME \
  && useradd -s /bin/bash --uid $USER_UID --gid $USER_GID -m $USERNAME \
  && mkdir /home/$USERNAME/.config && chown $USER_UID:$USER_GID /home/$USERNAME/.config

# Set up sudo
RUN apt-get update \
  && apt-get install -y sudo \
  && echo $USERNAME ALL=\(root\) NOPASSWD:ALL > /etc/sudoers.d/$USERNAME\
  && chmod 0440 /etc/sudoers.d/$USERNAME \
  && rm -rf /var/lib/apt/lists/*

# Install ROS 2 control and controller packages to control the robot in the ROS 2 workspace
RUN apt-get update && apt-get install -y --no-install-recommends \
  # ros-humble-ros2-control \
  # ros-humble-ros2-controllers \
  ros-noetic-gazebo-ros-pkgs \
  ros-noetic-gazebo-ros-control \
  # jstest-gtk \
  # evtest \
  # python3-serial \
  && rm -rf /var/lib/apt/lists/*


# Copy the entrypoint script into the container
COPY entrypoint.sh /entrypoint.sh
# Copy the bashrc file into the container and set permissions
COPY bashrc /home/${USERNAME}/.bashrc

# Make the entrypoint script executable
ENTRYPOINT [ "/bin/bash", "/entrypoint.sh" ]

# Set the default command to run when the container starts
CMD ["bash"]

RUN echo "ALL DONE !"