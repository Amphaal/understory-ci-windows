cmake_minimum_required(VERSION 3.17)

project(wine-wrappers
    DESCRIPTION "wrapper for execution on X-Compilation environement"
    LANGUAGES CXX
)

file(STRINGS wrappersList.txt WRAPPERS_LIST)

foreach(TB_WRAPPED_PATH ${WRAPPERS_LIST})
    get_filename_component(EXEC_NAME ${TB_WRAPPED_PATH} NAME_WE)
    add_executable(${EXEC_NAME} main.cpp)
    target_compile_definitions(${EXEC_NAME} PRIVATE TO_BE_WRAPPED_PATH="${TB_WRAPPED_PATH}")
    install(TARGETS ${EXEC_NAME} RUNTIME)
endforeach()
