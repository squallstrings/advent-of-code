#include <iostream>
#include <filesystem>

extern "C" long long SolveDay5Part1(const char* input);
extern "C" long long SolveDay5Part2(const char* input);

int main() {
    namespace fs = std::filesystem;
    std::cout << "Working Directory = "
        << std::filesystem::current_path()
        << std::endl;

    long long resultPart1 = SolveDay5Part1("input5.txt");
    std::cout << "Day 5 - Part 1: " << resultPart1 << std::endl;

    long long resultPart2 = SolveDay5Part2("input5.txt");
    std::cout << "Day 5 - Part 2: " << resultPart2 << std::endl;

    return 0;
}
