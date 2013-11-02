cmake_minimum_required(VERSION 2.8)
project( test_cv )
find_package( OpenCV REQUIRED )
set(EXECUTABLE_OUTPUT_PATH ${PROJECT_SOURCE_DIR}/bin)

add_executable( test_cv src/image_test.cpp )
target_link_libraries( test_cv ${OpenCV_LIBS} )
add_executable( ball_test src/ball_test.cpp )
target_link_libraries( ball_test ${OpenCV_LIBS} )
