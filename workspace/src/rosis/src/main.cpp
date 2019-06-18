#include <soss/Instance.hpp>

#include <iostream>

int main(int argc, char* argv[])
{
    std::cout << "Hello rosis" << std::endl;

    const YAML::Node config_node;

    return soss::run_instance(config_node).wait();
}
