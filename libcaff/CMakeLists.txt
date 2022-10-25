cmake_minimum_required(VERSION 3.24)
project(libcaff LANGUAGES C CXX)

set(SOURCEFILES
	src/Caff.cpp
	src/Ciff.cpp
	src/PngEncoder.cpp
	src/libcaff.cpp
)

set(RUNER_SOURCEFILES
	caffrunner/caffrunner.cpp
)

set(SPNG_SOURCEFILES miniz/miniz.c libspng/spng/spng.c)

add_library(spng STATIC ${SPNG_SOURCEFILES})
target_include_directories(spng PRIVATE miniz PUBLIC libspng/spng)
target_compile_definitions(spng PUBLIC SPNG_STATIC SPNG_USE_MINIZ)

add_library(libcaff SHARED ${SOURCEFILES})
target_include_directories(libcaff PUBLIC include)
target_link_libraries(libcaff spng)

file(GLOB_RECURSE HEADERFILES src/*.h)
target_sources(libcaff PRIVATE ${HEADERFILES})

file(GLOB_RECURSE PUBLIC_HEADERFILES include/*.h)
target_sources(libcaff PRIVATE ${PUBLIC_HEADERFILES})

add_executable(caffrunner ${RUNER_SOURCEFILES})
target_link_libraries(caffrunner libcaff)