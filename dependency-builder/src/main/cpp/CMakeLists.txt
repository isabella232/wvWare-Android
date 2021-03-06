# CMakeLists.txt
#
# Copyright (c) 2019 Vilius Sutkus <ViliusSutkus89@gmail.com>
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License version 3 as
# published by the Free Software Foundation.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <https://www.gnu.org/licenses/>.

cmake_minimum_required(VERSION 3.10.2 FATAL_ERROR)

set(CMAKE_BUILD_TYPE Release CACHE STRING "Build configuration (Debug, Release, RelWithDebInfo, MinSizeRel)")

project(DependencyBuilder)

include(ExternalProject)

get_filename_component(DP_ROOT_DIR "${CMAKE_CURRENT_LIST_DIR}/../../.." ABSOLUTE)
SET(THIRDPARTY_PREFIX ${DP_ROOT_DIR}/build/installed/${CMAKE_BUILD_TYPE}/${ANDROID_ABI})
SET(THIRDPARTY_PKG_CONFIG_PATH ${THIRDPARTY_PREFIX}/share/pkgconfig)
SET(THIRDPARTY_PKG_CONFIG_LIBDIR ${THIRDPARTY_PREFIX}/lib/pkgconfig)
SET(THIRDPARTY_PKG_CONFIG_EXECUTABLE ${THIRDPARTY_PREFIX}/bin/pkg-config)
SET(PKG_CONFIG_EXECUTABLE ${THIRDPARTY_PKG_CONFIG_EXECUTABLE})
find_package(PkgConfig REQUIRED)

# LIST(PREPEND is unavailable in CMake 3.10)
LIST(REVERSE CMAKE_FIND_ROOT_PATH)
LIST(APPEND CMAKE_FIND_ROOT_PATH ${THIRDPARTY_PREFIX})
LIST(REVERSE CMAKE_FIND_ROOT_PATH)

# Generate pkg-config wrapper
if(BUILD_SHARED_LIBS)
  configure_file(${CMAKE_CURRENT_LIST_DIR}/pkg-config.in ${THIRDPARTY_PKG_CONFIG_EXECUTABLE} @ONLY)
else()
  configure_file(${CMAKE_CURRENT_LIST_DIR}/pkg-config-static.in ${THIRDPARTY_PKG_CONFIG_EXECUTABLE} @ONLY)
endif()

include(${CMAKE_CURRENT_SOURCE_DIR}/EPHelpers.cmake)
include(${CMAKE_CURRENT_SOURCE_DIR}/EPAutotools.cmake)
include(${CMAKE_CURRENT_SOURCE_DIR}/EPCMake.cmake)
include(${CMAKE_CURRENT_SOURCE_DIR}/EPMeson.cmake)

SET(TARBALL_STORAGE ${CMAKE_CURRENT_SOURCE_DIR}/tarballs/ CACHE PATH "Path to manually downloaded tarballs. Used to look up before downloading from the internet.")

option(BUILD_3RDPARTY_BINARIES "Build all 3rd party binaries to catch missing symbols earlier" OFF)

# List of root level packages that we want installed.
# Defined dependencies will be picked up too.

include(${CMAKE_CURRENT_SOURCE_DIR}/packages/wvWare.cmake)

add_executable(emptyProgram emptyProgram.cpp)
if (NOT EXISTS ${THIRDPARTY_PREFIX}/lib/libwv.a)
  add_dependencies(emptyProgram wvWare)
endif()

