cmake_minimum_required(VERSION 3.21)

project(app_target LANGUAGES C CXX)

set(CMAKE_CXX_STANDARD 20)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

find_package(Qt6 6.10 REQUIRED COMPONENTS Quick QuickControls2 Gui Core Qml Charts Multimedia Widgets Concurrent SerialPort)

qt_standard_project_setup(REQUIRES 6.10)

qt_add_executable(app_target
    main.cpp
)

qt_add_qml_module(app_target
    URI qt_quick_test
    VERSION 1.0
    QML_FILES
        main.qml
)

set_target_properties(app_target PROPERTIES OUTPUT_NAME "app_qt_quick_test")

target_link_libraries(app_target
    PRIVATE Qt6::Quick
)
