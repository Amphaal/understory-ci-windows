// no copyright

#include <cstdlib>
#include <string>
#include <memory>
#include <stdexcept>
#include <iostream>
#include <vector>
#include <algorithm>

int main(int argc, char *argv[]) {
    std::string cmd = "wine";
    #ifdef TO_BE_WRAPPED_PATH
        cmd += " " + std::string(TO_BE_WRAPPED_PATH);
    #endif

    // increment
    std::vector<std::string> arguments(argv + 1, argv + argc);
    for (auto &arg : arguments) {
        cmd += " ";
        cmd += arg;
    }

    // open pipe
    std::unique_ptr<FILE, decltype(&pclose)> pipe(
        popen(cmd.c_str(), "r"),
        pclose
    );
    if (!pipe) {
        throw std::runtime_error("popen() failed!");
    }

    // get result
    std::array<char, 128> buffer;
    std::string result;
    while (fgets(buffer.data(), buffer.size(), pipe.get()) != nullptr) {
        result += buffer.data();
    }

    // output it
    if (!result.empty()) std::cout << result << std::endl;

    return 0;
}
