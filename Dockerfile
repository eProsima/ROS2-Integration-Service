FROM ubuntu:bionic

# Dependencies
RUN apt-get install -f
RUN apt-get update

RUN apt-get install -y lsb-release
RUN apt-get install -y gnupg2

ENV APT_KEY_DONT_WARN_ON_DANGEROUS_USAGE=DontWarn
RUN apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys C1CF6E31E6BADE8868B172B4F42ED6FBAB17C654
RUN echo "deb http://packages.ros.org/ros2/ubuntu `lsb_release -sc` main" > /etc/apt/sources.list.d/ros2-latest.list
RUN apt-get update

RUN apt-get install -y libyaml-cpp-dev
RUN apt-get install -y libboost-program-options-dev
RUN apt-get install -y python3
RUN apt-get install -y python3-vcstool
RUN apt-get install -y python3-colcon-common-extensions
RUN apt-get install -y git #Required for config

# ROS2
RUN apt-get install -y ros-crystal-desktop
RUN apt-get install -y ros-crystal-test-msgs
RUN chmod +x ./opt/ros/crystal/setup.sh

# SOSS
RUN mkdir -p /root/soss_wp/src
WORKDIR /root/soss_wp
RUN git clone https://github.com/eProsima/soss_v2.git src/soss

RUN . /opt/ros/crystal/setup.sh && \
    colcon build --packages-up-to soss-ros2 soss-mock --cmake-args -DCMAKE_BUILD_TYPE=RELEASE --install-base /opt/soss

# ROSIS
RUN mkdir -p /root/rosis_wp/src
WORKDIR /root/rosis_wp
RUN git clone https://github.com/eProsima/ROS2-Integration-Service.git src/rosis

RUN . /opt/soss/setup.sh && \
    colcon build --cmake-args -DCMAKE_BUILD_TYPE=RELEASE --install-base /opt/rosis

# Prepare environment
WORKDIR /root
RUN rm -rf soss_wp
RUN rm -rf rosis_wp
RUN mkdir -p workspace/src
WORKDIR /root/workspace/src

# Plugin: dds
RUN git clone https://github.com/eProsima/SOSS-DDS.git dds

# Plugin: fiware
RUN apt-get install -y libasio-dev
RUN apt-get install -y libcurlpp-dev
RUN git clone https://github.com/eProsima/SOSS-FIWARE.git fiware

WORKDIR /root/workspace

ENTRYPOINT . /opt/rosis/setup.sh && \
    echo "[NOTE]: This docker comes with several plugins already downloaded. " && \
    echo "[STEP] 1: Compile the plugins you want with: 'colcon build --packages-up-to <your_plugin>...'" && \
    echo "[STEP] 2: Source your project to register your plugins: '. install/local_setup.bash'" && \
    echo "[STEP] 3: Now, you can test it running an example: 'rosis <your_config.yaml>'" && \
    bash
