#include <soss/Instance.hpp>

#include <iostream>
#include <vector>
#include <string>

int main(int argc, char* argv[])
{
    std::vector<std::string> args(argv, argv + argc);

    if (argc == 1 || (argc >= 2 && (args[1] == "-h" || args[1] == "--help")))
    {
        std::cout << "Usage: rosis <config_file.yaml> | -h | --help " << std::endl;
        return argc != 1;
    }

    std::cout << "Hello rosis" << std::endl;

    YAML::Node config_node;

    return soss::run_instance(config_node).wait();
}
