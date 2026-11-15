cmake_minimum_required(VERSION 3.8)
project(LRT_meldog_application)

if(CMAKE_COMPILER_IS_GNUCXX OR CMAKE_CXX_COMPILER_ID MATCHES "Clang")
  add_compile_options(-Wall -Wextra -Wpedantic)
endif()

find_package(ament_cmake REQUIRED)

find_package(rclcpp REQUIRED)
find_package(sensor_msgs REQUIRED)

find_package(Qt6 REQUIRED COMPONENTS Core Gui Qml Quick Widgets QuickControls2)

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

set(CMAKE_AUTOMOC ON)
set(CMAKE_AUTORCC ON)

include_directories(include)

add_executable(LRT_meldog_application
  app/main.cpp
  backend/app_controller.cpp
  backend/diagnostics_node.cpp
  backend/diagnostics_bridge.cpp

  include/backend/diagnostics_bridge.hpp
  include/backend/app_controller.hpp
  include/backend/diagnostics_node.hpp
)

qt6_add_big_resources(BIG_RESOURCES qml/resources.qrc)

target_sources(LRT_meldog_application
    PRIVATE ${BIG_RESOURCES}
)

target_link_libraries(LRT_meldog_application
  Qt6::Core 
  Qt6::Gui 
  Qt6::Qml 
  Qt6::Quick 
  Qt6::Widgets
  Qt6::QuickControls2
)

ament_target_dependencies(LRT_meldog_application
  rclcpp
  sensor_msgs
)

install(TARGETS LRT_meldog_application
  DESTINATION lib/${PROJECT_NAME}
)


if(BUILD_TESTING)
  find_package(ament_lint_auto REQUIRED)
  set(ament_cmake_copyright_FOUND TRUE)
  set(ament_cmake_cpplint_FOUND TRUE)
  ament_lint_auto_find_test_dependencies()
endif()

ament_package()
