cmake_minimum_required(VERSION 3.5.0)

project(rosis)

find_package(soss-core REQUIRED)

# Will be load dynamically at execution time.
# We must to create the dependency.
find_package(soss-ros2 REQUIRED)

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
