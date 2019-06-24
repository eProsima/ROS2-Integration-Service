cmake_minimum_required(VERSION 3.5.0)

project(rosis)

find_package(soss-core REQUIRED)

# Will be load dynamically at execution time,
# but we must to create the dependency at this moment in order to build it.
find_package(soss-ros2 REQUIRED)

###############################
# Default supported msgs
find_package(geometry_msgs REQUIRED)
find_package(nav_msgs REQUIRED)
find_package(test_msgs REQUIRED)

find_package(soss-rosidl REQUIRED)

# Necessary for 'soss_rosidl_mix'
if(NOT CMAKE_CXX_STANDARD)
  set(CMAKE_CXX_STANDARD 14)
endif()

soss_rosidl_mix(
  PACKAGES geometry_msgs nav_msgs test_msgs
  MIDDLEWARES ros2
)

###############################
# Build rosis
set(SRC src/main.cpp)

add_executable(${PROJECT_NAME} ${SRC})

set_target_properties(${PROJECT_NAME}
    PROPERTIES
        CXX_STANDARD 14
)

target_compile_options(${PROJECT_NAME}
    PRIVATE
        -Werror -Wall -Wextra -Wpedantic
)

target_link_libraries(${PROJECT_NAME}
    PRIVATE
        soss::core
)


###############################
# Install rosis
install(
  TARGETS rosis
  DESTINATION "${CMAKE_INSTALL_BINDIR}"
  COMPONENT rosis
)
