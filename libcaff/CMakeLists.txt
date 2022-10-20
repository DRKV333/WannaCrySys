cmake_minimum_required(VERSION 3.22)
project(libcaff LANGUAGES CXX)

set(SOURCEFILES
	src/Caff.cpp
	src/Ciff.cpp
	src/PngEncoder.cpp
	src/libcaff.cpp
)

set(RUNER_SOURCEFILES
	caffrunner/caffrunner.cpp
)

set(ZLIB_USE_STATIC_LIBS ON)
set(SPNG_SHARED OFF)
set(SPNG_STATIC ON)
set(BUILD_EXAMPLES OFF)
add_subdirectory(libspng EXCLUDE_FROM_ALL)

add_library(libcaff SHARED ${SOURCEFILES})
target_include_directories(libcaff PUBLIC include)

target_link_libraries(libcaff spng_static)
find_package(ZLIB REQUIRED)
target_link_libraries(spng_static ${ZLIB_LIBRARIES})
target_include_directories(libcaff PRIVATE libspng/spng) # spng doesn't do this, for some reason...

file(GLOB_RECURSE HEADERFILES src/*.h)
target_sources(libcaff PRIVATE ${HEADERFILES})

file(GLOB_RECURSE PUBLIC_HEADERFILES include/*.h)
target_sources(libcaff PRIVATE ${PUBLIC_HEADERFILES})

add_executable(caffrunner ${RUNER_SOURCEFILES})
target_link_libraries(caffrunner libcaff)