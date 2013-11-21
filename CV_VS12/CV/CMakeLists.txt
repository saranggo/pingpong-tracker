cmake_minimum_required(VERSION 2.8)
project( pingpong_tracker_saranggo )
find_package( OpenCV REQUIRED )

set(EXECUTABLE_OUTPUT_PATH ${PROJECT_SOURCE_DIR}/bin)
set(LIBRARY_OUTPUT_PATH ${PROJECT_SOURCE_DIR}/lib)

add_library( colorFilter colorFilter.cpp )
target_link_libraries( colorFilter ${OpenCV_LIBS} )

add_library( detectEllipse detectEllipse.cpp )
target_link_libraries( detectEllipse  ${OpenCV_LIBS} )

add_library( getNextImage getNextImage.cpp )
target_link_libraries( getNextImage ${OpenCV_LIBS} )

add_library( ProjectileEst ProjectileEst.cpp )
target_link_libraries( ProjectileEst ${OpenCV_LIBS} )

add_executable( main main.cpp )
target_link_libraries( main ${OpenCV_LIBS} colorFilter detectEllipse getNextImage ProjectileEst)
