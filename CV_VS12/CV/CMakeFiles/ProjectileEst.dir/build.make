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
CMAKE_SOURCE_DIR = /home/prasanna/opencv_workspace/pingpong-tracker/CV_VS12/CV

# The top-level build directory on which CMake was run.
CMAKE_BINARY_DIR = /home/prasanna/opencv_workspace/pingpong-tracker/CV_VS12/CV

# Include any dependencies generated for this target.
include CMakeFiles/ProjectileEst.dir/depend.make

# Include the progress variables for this target.
include CMakeFiles/ProjectileEst.dir/progress.make

# Include the compile flags for this target's objects.
include CMakeFiles/ProjectileEst.dir/flags.make

CMakeFiles/ProjectileEst.dir/ProjectileEst.cpp.o: CMakeFiles/ProjectileEst.dir/flags.make
CMakeFiles/ProjectileEst.dir/ProjectileEst.cpp.o: ProjectileEst.cpp
	$(CMAKE_COMMAND) -E cmake_progress_report /home/prasanna/opencv_workspace/pingpong-tracker/CV_VS12/CV/CMakeFiles $(CMAKE_PROGRESS_1)
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Building CXX object CMakeFiles/ProjectileEst.dir/ProjectileEst.cpp.o"
	/usr/bin/c++   $(CXX_DEFINES) $(CXX_FLAGS) -o CMakeFiles/ProjectileEst.dir/ProjectileEst.cpp.o -c /home/prasanna/opencv_workspace/pingpong-tracker/CV_VS12/CV/ProjectileEst.cpp

CMakeFiles/ProjectileEst.dir/ProjectileEst.cpp.i: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Preprocessing CXX source to CMakeFiles/ProjectileEst.dir/ProjectileEst.cpp.i"
	/usr/bin/c++  $(CXX_DEFINES) $(CXX_FLAGS) -E /home/prasanna/opencv_workspace/pingpong-tracker/CV_VS12/CV/ProjectileEst.cpp > CMakeFiles/ProjectileEst.dir/ProjectileEst.cpp.i

CMakeFiles/ProjectileEst.dir/ProjectileEst.cpp.s: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Compiling CXX source to assembly CMakeFiles/ProjectileEst.dir/ProjectileEst.cpp.s"
	/usr/bin/c++  $(CXX_DEFINES) $(CXX_FLAGS) -S /home/prasanna/opencv_workspace/pingpong-tracker/CV_VS12/CV/ProjectileEst.cpp -o CMakeFiles/ProjectileEst.dir/ProjectileEst.cpp.s

CMakeFiles/ProjectileEst.dir/ProjectileEst.cpp.o.requires:
.PHONY : CMakeFiles/ProjectileEst.dir/ProjectileEst.cpp.o.requires

CMakeFiles/ProjectileEst.dir/ProjectileEst.cpp.o.provides: CMakeFiles/ProjectileEst.dir/ProjectileEst.cpp.o.requires
	$(MAKE) -f CMakeFiles/ProjectileEst.dir/build.make CMakeFiles/ProjectileEst.dir/ProjectileEst.cpp.o.provides.build
.PHONY : CMakeFiles/ProjectileEst.dir/ProjectileEst.cpp.o.provides

CMakeFiles/ProjectileEst.dir/ProjectileEst.cpp.o.provides.build: CMakeFiles/ProjectileEst.dir/ProjectileEst.cpp.o

# Object files for target ProjectileEst
ProjectileEst_OBJECTS = \
"CMakeFiles/ProjectileEst.dir/ProjectileEst.cpp.o"

# External object files for target ProjectileEst
ProjectileEst_EXTERNAL_OBJECTS =

lib/libProjectileEst.a: CMakeFiles/ProjectileEst.dir/ProjectileEst.cpp.o
lib/libProjectileEst.a: CMakeFiles/ProjectileEst.dir/build.make
lib/libProjectileEst.a: CMakeFiles/ProjectileEst.dir/link.txt
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --red --bold "Linking CXX static library lib/libProjectileEst.a"
	$(CMAKE_COMMAND) -P CMakeFiles/ProjectileEst.dir/cmake_clean_target.cmake
	$(CMAKE_COMMAND) -E cmake_link_script CMakeFiles/ProjectileEst.dir/link.txt --verbose=$(VERBOSE)

# Rule to build all files generated by this target.
CMakeFiles/ProjectileEst.dir/build: lib/libProjectileEst.a
.PHONY : CMakeFiles/ProjectileEst.dir/build

CMakeFiles/ProjectileEst.dir/requires: CMakeFiles/ProjectileEst.dir/ProjectileEst.cpp.o.requires
.PHONY : CMakeFiles/ProjectileEst.dir/requires

CMakeFiles/ProjectileEst.dir/clean:
	$(CMAKE_COMMAND) -P CMakeFiles/ProjectileEst.dir/cmake_clean.cmake
.PHONY : CMakeFiles/ProjectileEst.dir/clean

CMakeFiles/ProjectileEst.dir/depend:
	cd /home/prasanna/opencv_workspace/pingpong-tracker/CV_VS12/CV && $(CMAKE_COMMAND) -E cmake_depends "Unix Makefiles" /home/prasanna/opencv_workspace/pingpong-tracker/CV_VS12/CV /home/prasanna/opencv_workspace/pingpong-tracker/CV_VS12/CV /home/prasanna/opencv_workspace/pingpong-tracker/CV_VS12/CV /home/prasanna/opencv_workspace/pingpong-tracker/CV_VS12/CV /home/prasanna/opencv_workspace/pingpong-tracker/CV_VS12/CV/CMakeFiles/ProjectileEst.dir/DependInfo.cmake --color=$(COLOR)
.PHONY : CMakeFiles/ProjectileEst.dir/depend

