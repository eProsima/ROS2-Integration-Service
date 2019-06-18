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

    YAML::Node rosis_config = YAML::LoadFile(args[1]);

    YAML::Node soss_config;
    soss_config["systems"]["ros2"] = YAML::Load("type: ros2");

    for (const YAML::detail::iterator_value& plugin: rosis_config["plugins"])
    {
        soss_config["systems"][plugin.first]["type"] = plugin.second["type"];
    }

    for (const YAML::detail::iterator_value& comm: rosis_config["topics"])
    {
        YAML::Node route;
        if (comm.second["to"])
        {
            route["from"] = "ros2";
            route["to"] = comm.second["to"];
        }
        else if (comm.second["from"])
        {
            route["from"] = comm.second["from"];
            route["to"] = "ros2";
        }
        else
        {
            std::cerr << "Error: a 'communication' must have 'to' or 'from' value" << std::endl;
            return 1;
        }

        soss_config["topics"][comm.first]["type"] = comm.second["type"];
        soss_config["topics"][comm.first]["route"] = route;
    }

    //std::cout << "\n===== SOSS CONFIG =====" << std::endl;
    //std::cout << soss_config << std::endl;

    return soss::run_instance(soss_config).wait();
}
