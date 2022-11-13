cmake_minimum_required(VERSION 3.22)
project(libcaff LANGUAGES C CXX)

set(DEFAULT_BUILD_TYPE "Debug")

if(NOT CMAKE_BUILD_TYPE AND NOT CMAKE_CONFIGURATION_TYPES)
	message(STATUS "Setting build type to '${DEFAULT_BUILD_TYPE}' as none was specified.")
	set(CMAKE_BUILD_TYPE "${DEFAULT_BUILD_TYPE}" CACHE STRING "Choose the type of build." FORCE)
endif()

option(LIBCAFF_STATIC "Link libcaff to caffrunner statically (for fuzzing)" OFF)

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

if(LIBCAFF_STATIC)
	add_library(libcaff STATIC ${SOURCEFILES})
else()
	add_library(libcaff SHARED ${SOURCEFILES})
endif()
target_include_directories(libcaff PUBLIC include)
target_link_libraries(libcaff spng)

file(GLOB_RECURSE HEADERFILES src/*.h)
target_sources(libcaff PRIVATE ${HEADERFILES})

file(GLOB_RECURSE PUBLIC_HEADERFILES include/*.h)
target_sources(libcaff PRIVATE ${PUBLIC_HEADERFILES})

add_executable(caffrunner ${RUNER_SOURCEFILES})
target_link_libraries(caffrunner libcaff)

if(WIN32 AND (NOT LIBCAFF_STATIC))
	target_compile_definitions(libcaff PUBLIC DO_DLL_EXPORTS)
endif()

if(MSVC)
	target_compile_options(libcaff PRIVATE "/Wall" "$<$<CONFIG:Debug>:/fsanitize=address>")
	target_compile_options(caffrunner PRIVATE "/Wall" "$<$<CONFIG:Debug>:/fsanitize=address>")
elseif (CMAKE_CXX_COMPILER_ID STREQUAL "GNU")
	target_compile_options(libcaff PRIVATE "-Wall" "-pedantic")
	target_compile_options(caffrunner PRIVATE "-Wall" "-pedantic")
	if (NOT WIN32) # GCC does not support asan on windows. :(
		target_compile_options(libcaff PRIVATE "$<$<CONFIG:Debug>:-fsanitize=address>")
		target_compile_options(caffrunner PRIVATE "$<$<CONFIG:Debug>:-fsanitize=address>")
		target_link_options(libcaff PRIVATE "$<$<CONFIG:Debug>:-fsanitize=address>")
		target_link_options(caffrunner PRIVATE "$<$<CONFIG:Debug>:-fsanitize=address>")
	endif()
endif()

if((NOT WIN32) AND (NOT LIBCAFF_STATIC))
	if(CMAKE_CXX_COMPILER_ID STREQUAL "GNU")
		target_compile_options(spng PRIVATE "-fPIC")
		target_compile_options(libcaff PRIVATE "-fPIC")
	endif()
endif()

find_program(CPPCHECK cppcheck)
if(CPPCHECK)
	set_target_properties(libcaff caffrunner PROPERTIES CXX_CPPCHECK "${CPPCHECK};-D__cppcheck__")
endif()