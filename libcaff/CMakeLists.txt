cmake_minimum_required(VERSION 3.22)
project(libcaff LANGUAGES CXX)

set(SOURCEFILES
	src/Caff.cpp
	src/Ciff.cpp
)

set(ZLIB_USE_STATIC_LIBS ON)
set(SPNG_SHARED OFF)
set(SPNG_STATIC ON)
set(BUILD_EXAMPLES OFF)
add_subdirectory(libspng EXCLUDE_FROM_ALL)

add_library(libcaff MODULE ${SOURCEFILES})

target_link_libraries(libcaff spng_static)

file(GLOB_RECURSE HEADERFILES src/*.h)
target_sources(libcaff PRIVATE ${HEADERFILES})