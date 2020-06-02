cmake_minimum_required(VERSION 3.17)

project(makensis-wrapper
    DESCRIPTION "wrapper for makensis execution on X-Compilation environement"
    LANGUAGES CXX
)

add_executable(makensis main.cpp)

install(TARGETS makensis RUNTIME)