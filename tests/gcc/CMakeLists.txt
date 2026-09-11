cmake_minimum_required(VERSION 3.21)

project(app_target LANGUAGES C CXX)

set(CMAKE_CXX_STANDARD 20)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

find_package(GTest REQUIRED)
find_package(benchmark REQUIRED)
find_package(Boost REQUIRED)
find_package(OpenSSL REQUIRED)

enable_testing()

add_executable(app_target main.cpp)

target_link_libraries(app_target
    PRIVATE
        GTest::gtest_main
        benchmark::benchmark
        Boost::headers
        OpenSSL::Crypto
)

set_target_properties(app_target PROPERTIES OUTPUT_NAME "app_gcc_test")

include(GoogleTest)
gtest_discover_tests(app_target)
