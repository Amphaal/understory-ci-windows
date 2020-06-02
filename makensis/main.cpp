// no copyright

#include <cstdlib>
#include <string>
#include <memory>
#include <stdexcept>
#include <iostream>
#include <vector>
#include <algorithm>

void replaceAll(
    std::string * str,
    const std::string& from,
    const std::string& to
) {
    if (from.empty())
        return;
    size_t start_pos = 0;
    while ((start_pos = str->find(from, start_pos)) != std::string::npos) {
        str->replace(start_pos, from.length(), to);
        start_pos += to.length();
    }
}

int main(int argc, char *argv[]) {
    std::string cmd = "wine /mingw64/bin/makensis.exe";

    // increment
    std::vector<std::string> arguments(argv + 1, argv + argc);
    for (auto &arg : arguments) {
        cmd += " ";
        cmd += arg;
    }

    // replace "-" with "/"
    // replaceAll(&cmd, "-VERSION", "/VERSION");
    std::clog << "Requesting command : [" << cmd << "]" << std::endl;

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
