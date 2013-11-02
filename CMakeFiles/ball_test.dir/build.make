# CMAKE generated file: DO NOT EDIT!
# Generated by "Unix Makefiles" Generator, CMake Version 2.8

#=============================================================================
# Special targets provided by cmake.

# Disable implicit rules so canonical targets will work.
.SUFFIXES:

# Remove some rules from gmake that .SUFFIXES does not remove.
SUFFIXES =

.SUFFIXES: .hpux_make_needs_suffix_list

# Suppress display of executed commands.
$(VERBOSE).SILENT:

# A target that is always out of date.
cmake_force:
.PHONY : cmake_force

#=============================================================================
# Set environment variables for the build.

# The shell in which to execute make rules.
SHELL = /bin/sh

# The CMake executable.
CMAKE_COMMAND = /usr/bin/cmake

# The command to remove a file.
RM = /usr/bin/cmake -E remove -f

# The top-level source directory on which CMake was run.
CMAKE_SOURCE_DIR = /home/prasanna/opencv_workspace/pingpong_tracker

# The top-level build directory on which CMake was run.
CMAKE_BINARY_DIR = /home/prasanna/opencv_workspace/pingpong_tracker

# Include any dependencies generated for this target.
include CMakeFiles/ball_test.dir/depend.make

# Include the progress variables for this target.
include CMakeFiles/ball_test.dir/progress.make

# Include the compile flags for this target's objects.
include CMakeFiles/ball_test.dir/flags.make

CMakeFiles/ball_test.dir/ball_test.cpp.o: CMakeFiles/ball_test.dir/flags.make
CMakeFiles/ball_test.dir/ball_test.cpp.o: ball_test.cpp
	$(CMAKE_COMMAND) -E cmake_progress_report /home/prasanna/opencv_workspace/pingpong_tracker/CMakeFiles $(CMAKE_PROGRESS_1)
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Building CXX object CMakeFiles/ball_test.dir/ball_test.cpp.o"
	/usr/bin/c++   $(CXX_DEFINES) $(CXX_FLAGS) -o CMakeFiles/ball_test.dir/ball_test.cpp.o -c /home/prasanna/opencv_workspace/pingpong_tracker/ball_test.cpp

CMakeFiles/ball_test.dir/ball_test.cpp.i: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Preprocessing CXX source to CMakeFiles/ball_test.dir/ball_test.cpp.i"
	/usr/bin/c++  $(CXX_DEFINES) $(CXX_FLAGS) -E /home/prasanna/opencv_workspace/pingpong_tracker/ball_test.cpp > CMakeFiles/ball_test.dir/ball_test.cpp.i

CMakeFiles/ball_test.dir/ball_test.cpp.s: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Compiling CXX source to assembly CMakeFiles/ball_test.dir/ball_test.cpp.s"
	/usr/bin/c++  $(CXX_DEFINES) $(CXX_FLAGS) -S /home/prasanna/opencv_workspace/pingpong_tracker/ball_test.cpp -o CMakeFiles/ball_test.dir/ball_test.cpp.s

CMakeFiles/ball_test.dir/ball_test.cpp.o.requires:
.PHONY : CMakeFiles/ball_test.dir/ball_test.cpp.o.requires

CMakeFiles/ball_test.dir/ball_test.cpp.o.provides: CMakeFiles/ball_test.dir/ball_test.cpp.o.requires
	$(MAKE) -f CMakeFiles/ball_test.dir/build.make CMakeFiles/ball_test.dir/ball_test.cpp.o.provides.build
.PHONY : CMakeFiles/ball_test.dir/ball_test.cpp.o.provides

CMakeFiles/ball_test.dir/ball_test.cpp.o.provides.build: CMakeFiles/ball_test.dir/ball_test.cpp.o

# Object files for target ball_test
ball_test_OBJECTS = \
"CMakeFiles/ball_test.dir/ball_test.cpp.o"

# External object files for target ball_test
ball_test_EXTERNAL_OBJECTS =

bin/ball_test: CMakeFiles/ball_test.dir/ball_test.cpp.o
bin/ball_test: /opt/ros/hydro/lib/libopencv_calib3d.so
bin/ball_test: /opt/ros/hydro/lib/libopencv_contrib.so
bin/ball_test: /opt/ros/hydro/lib/libopencv_core.so
bin/ball_test: /opt/ros/hydro/lib/libopencv_features2d.so
bin/ball_test: /opt/ros/hydro/lib/libopencv_flann.so
bin/ball_test: /opt/ros/hydro/lib/libopencv_gpu.so
bin/ball_test: /opt/ros/hydro/lib/libopencv_highgui.so
bin/ball_test: /opt/ros/hydro/lib/libopencv_imgproc.so
bin/ball_test: /opt/ros/hydro/lib/libopencv_legacy.so
bin/ball_test: /opt/ros/hydro/lib/libopencv_ml.so
bin/ball_test: /opt/ros/hydro/lib/libopencv_nonfree.so
bin/ball_test: /opt/ros/hydro/lib/libopencv_objdetect.so
bin/ball_test: /opt/ros/hydro/lib/libopencv_photo.so
bin/ball_test: /opt/ros/hydro/lib/libopencv_stitching.so
bin/ball_test: /opt/ros/hydro/lib/libopencv_superres.so
bin/ball_test: /opt/ros/hydro/lib/libopencv_ts.so
bin/ball_test: /opt/ros/hydro/lib/libopencv_video.so
bin/ball_test: /opt/ros/hydro/lib/libopencv_videostab.so
bin/ball_test: CMakeFiles/ball_test.dir/build.make
bin/ball_test: CMakeFiles/ball_test.dir/link.txt
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --red --bold "Linking CXX executable bin/ball_test"
	$(CMAKE_COMMAND) -E cmake_link_script CMakeFiles/ball_test.dir/link.txt --verbose=$(VERBOSE)

# Rule to build all files generated by this target.
CMakeFiles/ball_test.dir/build: bin/ball_test
.PHONY : CMakeFiles/ball_test.dir/build

CMakeFiles/ball_test.dir/requires: CMakeFiles/ball_test.dir/ball_test.cpp.o.requires
.PHONY : CMakeFiles/ball_test.dir/requires

CMakeFiles/ball_test.dir/clean:
	$(CMAKE_COMMAND) -P CMakeFiles/ball_test.dir/cmake_clean.cmake
.PHONY : CMakeFiles/ball_test.dir/clean

CMakeFiles/ball_test.dir/depend:
	cd /home/prasanna/opencv_workspace/pingpong_tracker && $(CMAKE_COMMAND) -E cmake_depends "Unix Makefiles" /home/prasanna/opencv_workspace/pingpong_tracker /home/prasanna/opencv_workspace/pingpong_tracker /home/prasanna/opencv_workspace/pingpong_tracker /home/prasanna/opencv_workspace/pingpong_tracker /home/prasanna/opencv_workspace/pingpong_tracker/CMakeFiles/ball_test.dir/DependInfo.cmake --color=$(COLOR)
.PHONY : CMakeFiles/ball_test.dir/depend

