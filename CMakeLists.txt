cmake_minimum_required(VERSION 3.8)
project(meldog_app)

if(CMAKE_COMPILER_IS_GNUCXX OR CMAKE_CXX_COMPILER_ID MATCHES "Clang")
  add_compile_options(-Wall -Wextra -Wpedantic)
endif()

find_package(ament_cmake REQUIRED)
find_package(Qt5 REQUIRED COMPONENTS Widgets Quick QuickWidgets Qml)

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

set(CMAKE_AUTOMOC ON)
set(CMAKE_AUTORCC ON)

include_directories(include)

add_executable(meldog_app
  app/main.cpp
  backend/app_controller.cpp
  qml/resources.qrc
  include/backend/app_controller.hpp
)

target_link_libraries(meldog_app
  Qt5::Widgets
  Qt5::Quick
  Qt5::QuickWidgets
  Qt5::Qml
)

install(TARGETS meldog_app
  DESTINATION lib/${PROJECT_NAME}
)


if(BUILD_TESTING)
  find_package(ament_lint_auto REQUIRED)
  set(ament_cmake_copyright_FOUND TRUE)
  set(ament_cmake_cpplint_FOUND TRUE)
  ament_lint_auto_find_test_dependencies()
endif()

ament_package()
