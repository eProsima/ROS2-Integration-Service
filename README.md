# rosis

ROSIS (ROS2 Integration Services) is an implementation that uses SOSS to connect ROS2 to different systems.

## Setup

This repository has a workspace already organized in order to make easy starting a connection between ROS2 and any other system.

It should be downloaded with the recursive option, in order to download soss as a third party. That way, the initial layout will include a folder with a workspace, which contains a `src` (source) directory, and inside that last folder, the SOSS project and the ROS2 system handle will be downloaded and ready to build.

```
git clone git@github.com:eProsima/ROSIS.git --recursive 
```

If the user wants to connect with other systems, the system handle for each system to be connected must be downloaded separately. To make things easier, this repository includes in its root directory a file called rosis.repos, to be used together with [vcstool](https://github.com/dirk-thomas/vcstool) to clone eProsima's system handles. In the root directory, execute the following command:

```
vcs import < rosis.repos
```

This will clone the system handles into the folder workspace/src/plugins.

## Usage

0. If you are using soss-ros2 system handle, source a colcon environment in which ROS2 has been built (soss-ros2 uses rclcpp package).
1. Change directories to the workspace folder `$ cd workspace`
1. Build the necessary packages with colcon `$ colcon build --packages-up-to <system_handle_pkg_names>`
1. Source the current workspace `$ source install/local_setup.bash`
1. Run an instance of SOSS with the configuration file `$ soss path/to/config_file.yaml`

The two systems will communicate through soss now.

## Example - Connecting ROS2 with FIWARE

In the workspace directory, having previously sourced a colcon ws with ROS2:
```
colcon build --packages-up-to soss-ros2 soss-fiware
source install/local_setup.bash
soss src/plugins/soss-fiware/fiware/sample/hello_fiware_ros2.yaml
```
Now, fiware an ROS2 can exchange messages of the type specified in the configuration file.
