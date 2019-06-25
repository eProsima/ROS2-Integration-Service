# ROSIS
ROSIS (ROS2 Integration Services) is an implementation that uses [SOSS][soss] to connect ROS2 to different systems.

## Setup
ROSIS uses *colcon* to work.
As dependencies, it needs a [SOSS][soss] environment with the `soss-ros2` and `soss-mock` packages into it to work.

Clone this repository into [colcon workspace][colcon], and *source* the soss dependency:

```
$ cd rosis_workspace
$ git clone git@github.com:eProsima/ROS2-Integration-Service.git src/rosis
$ source path/to/soss/setup.bash
$ colcon build
```

## Plugins packages
ROSIS can connect ROS2 to any system that has a soss-plugin implemented.
The official list of supported systems can be found at: [SOSS][soss].

If you are a developer and you want to connect ROS2 to other systems,
you may want to check our manual on [how to create a system handle](docs/CreatingSH.md)

## Usage
* Into your colcon workspace, source the *colcon environment* in which ROSIS has been built (see [Setup](# Setup)):
  ```
  $ source path/to/rosis/setup.bash
  ```

* Put into your workspace the plugins that you want to use, and build them:
  ```
  $ colcon build --packages-up-to <plugin>...
  ```

* Source your own environment in order to allow rosis to find the plugins
  ```
  $ source install/local_setup.bash`
  ```

* Run an instance of ROSIS with a [ROSIS configuration YAML file](#ROSIS configuration YAML file)
  ```
  $ rosis path/to/config_file.yaml`
  ```

The systems will be able to communicate through *rosis* now.

## ROSIS configuration YAML file
```
plugins:
    my_system_id: { type: my_system}

topics:
    hello_ros2: {type: "std_msgs/String", from: my_system_id}
    hello_my_system: {type: "std_msgs/String", to: my_system_id}
```

*Note: this configuration files are a simplified version of soss configuration files with ROS2 as fixed communication side.*

The configuration file has two diferenciate parts, `plugins` and `topics`.
The `plugins` part allow to initialize the systems who want to communicate with ROS2.
The `topics` part enable a topic communication through a route.
In the example case, `hello_ros2` topic will be able to arrive to ROS2 if `my_system_id` sends this kind of topic.
From the opposite way, when ROS2 sends a `hello_my_system` topic, `my_system_id` will be able to receive it.

The following YAML file is a more complex example allowing three systems (`s1`, `s2` and `s3`) communicate to ROS2:
```
plugins:
    s1: { type: a}
    s2: { type: a}
    s3: { type: b}

topics:
    hello_ros2: {type: "std_msgs/String", from: [s1, s2]}
    hello_ros2_from_s3: {type: "std_msgs/String", from: s3}
    hello_whatever: {type: "std_msgs/String", to: [s1, s2]}
    hello_whatever_to_s3: {type: "std_msgs/String", to: s3}
```

---

<!--
    ROSIN acknowledgement from the ROSIN press kit
    @ https://github.com/rosin-project/press_kit
-->

<a href="http://rosin-project.eu">
  <img src="http://rosin-project.eu/wp-content/uploads/rosin_ack_logo_wide.png"
       alt="rosin_logo" height="60" >
</a>

Supported by ROSIN - ROS-Industrial Quality-Assured Robot Software Components.
More information: <a href="http://rosin-project.eu">rosin-project.eu</a>

<img src="http://rosin-project.eu/wp-content/uploads/rosin_eu_flag.jpg"
     alt="eu_flag" height="45" align="left" >

This project has received funding from the European Union’s Horizon 2020
research and innovation programme under grant agreement no. 732287.

[colcon]: https://index.ros.org/doc/ros2/Tutorials/Colcon-Tutorial/#create-a-workspace
[ros2]: https://index.ros.org/doc/ros2
[soss]: https://github.com/osrf/soss_v2
[fiware]: https://www.fiware.org/
