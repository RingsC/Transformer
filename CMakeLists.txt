cmake_minimum_required(VERSION 2.8)

# some project info
project(Transformer)
enable_language(CXX)

message(STATUS "PROJECT_SOURCE_DIR: ${PROJECT_SOURCE_DIR}")
if (COMMAND cmake_policy)
    cmake_policy(SET CMP0003 NEW)
    cmake_policy(SET CMP0005 NEW)
    cmake_policy(SET CMP0015 NEW)
endif (COMMAND cmake_policy)

# define CMAKE_VERSION if it isn't defined
if (NOT CMAKE_VERSION)
    set(CMAKE_VERSION "${CMAKE_MAJOR_VERSION}.${CMAKE_MINOR_VERSION}.${CMAKE_PATCH_VERSION}")
    message(STATUS "CMAKE_VERSION was not defined, setting to ${CMAKE_VERSION}")
endif (NOT CMAKE_VERSION)
message(STATUS "CMake version is -- ${CMAKE_VERSION}")

# platform info
message(STATUS "Building for: ${CMAKE_SYSTEM_NAME}-${CMAKE_SYSTEM_PROCESSOR}")

# prohibit in-source-builds
if (${CMAKE_BINARY_DIR} STREQUAL ${CMAKE_SOURCE_DIR})
    message(STATUS "In-source-builds are not allowed")
    message(FATAL_ERROR "Create a separate build directory (e.g. \"build\") and execute \"cmake <path_to_sources>\" from it")
endif (${CMAKE_BINARY_DIR} STREQUAL ${CMAKE_SOURCE_DIR})

# set default build type if it's supported
if (NOT CMAKE_CONFIGURATION_TYPES AND NOT CMAKE_BUILD_TYPE)
   message(STATUS "Build type is not defined -- assuming Release")
   set(CMAKE_BUILD_TYPE Release CACHE STRING "Choose the type of build, options are: None(CMAKE_CXX_FLAGS or CMAKE_C_FLAGS used) Debug Release RelWithDebInfo MinSizeRel." FORCE)
endif (NOT CMAKE_CONFIGURATION_TYPES AND NOT CMAKE_BUILD_TYPE)

if (NOT CMAKE_CONFIGURATION_TYPES)
    message(STATUS "Build type is set to -- ${CMAKE_BUILD_TYPE}")
endif (NOT CMAKE_CONFIGURATION_TYPES)

# path to find additional cmake modules
set(CMAKE_MODULE_PATH "${CMAKE_SOURCE_DIR}/cmake" ${CMAKE_MODULE_PATH})
message(STATUS "project module path is: " ${CMAKE_MODULE_PATH} )

#set TRANS_EXPORT 
if (NOT CMAKE_CREATE_DLL)
	message(STATUS "TRANS_CREATE_DLL macro is not defined -- assuming yes")
	add_definitions(-DTRANS_CREATE_DLL)
endif (NOT CMAKE_CREATE_DLL)

# display system name
message(STATUS "System name is determined -- ${CMAKE_SYSTEM_NAME}")
if (UNIX)
    message(STATUS "System is of UNIX type -- yes")
    set(CMAKE_CXX_COMPILER g++)
else (UNIX)
    message(STATUS "System is of UNIX type -- no")
endif (UNIX)

include(AddToConfig)

# Determine features and options to be used
#More options you can added to configure the project.
option(FD_ENABLE_GCOV "Enable gcov coverage tests" OFF)
option(FD_ENABLE_GPROF "Enable gprof coverage tests" OFF)

#set the root dir.
SET(ROOT_DIR ${PROJECT_SOURCE_DIR})

#set the configuration file.
CONFIGURE_FILE(
  "Version.h.in"
  "${CMAKE_SOURCE_DIR}/src/include/common/Version.h"
)


# set Trans_BUILD and Trans_VERSION
if (EXISTS ${CMAKE_SOURCE_DIR}/ver AND NOT IS_DIRECTORY ${CMAKE_SOURCE_DIR}/ver)
    file(READ ${CMAKE_SOURCE_DIR}/ver TRANSFORMER_VERSION)
    message(STATUS "Transformer release version is -- ${TRANSFORMER_VERSION}")
else (EXISTS ${CMAKE_SOURCE_DIR}/ver AND NOT IS_DIRECTORY ${CMAKE_SOURCE_DIR}/ver)
    message(FATAL_ERROR "Cannot determine Transformer release version to build -- cannot find ${CMAKE_SOURCE_DIR}/ver file")
endif (EXISTS ${CMAKE_SOURCE_DIR}/ver AND NOT IS_DIRECTORY ${CMAKE_SOURCE_DIR}/ver)

if (EXISTS ${CMAKE_SOURCE_DIR}/buildno AND NOT IS_DIRECTORY ${CMAKE_SOURCE_DIR}/build)
    file(READ ${CMAKE_SOURCE_DIR}/buildno TRANSFORMER_BUILD)
    message(STATUS "TRANSFORMER build version is -- ${TRANSFORMER_BUILD}")
else (EXISTS ${CMAKE_SOURCE_DIR}/buildno AND NOT IS_DIRECTORY ${CMAKE_SOURCE_DIR}/build)
    message(STATUS "TRANSFORMER build version is undefined -- assume 0")
    set(TRANSFORMER_BUILD 0)
endif (EXISTS ${CMAKE_SOURCE_DIR}/buildno AND NOT IS_DIRECTORY ${CMAKE_SOURCE_DIR}/build)

set(TRANSFORMER_BUILD_VERSION ${TRANSFORMER_VERSION}.${TRANSFORMER_BUILD})
#message(STATUS "Full Transformer version is -- ${TRANSFORMER_BUILD_VERSION}")


# don't use RPATH since we don't have an install target for now
set(CMAKE_SKIP_BUILD_RPATH ON)
SET(CMAKE_ARCHIEVE_OUTPUT_DIRECTORY "bin/${CMAKE_SYSTEM_NAME}")
# ACTIVE_CONFIGURATION is used by some source files (notable se_trn to enable/disable manual se_trn)
AddDefinitionDebRel(ACTIVE_CONFIGURATION \"Debug\" \"Release\")

#add_definitions(-DTRANSFORMER_VERSION="${TRANSFORMER_VERSION}")
#add_definitions(-DTRANSFORMER_BUILD="${TRANSFORMER_BUILD}")
#add_definitions(-DBOOST_ALL_DYN_LINK)

# include directories
set(include_dir 
	./src
)
include_directories(
        ${include_dir}/include
        ${include_dir}/include/common
        ${include_dir}/include/memory
        ${include_dir}/include/query
		${include_dir}/include/storage_interface
        ${include_dir}/include/query/optimizer
		${include_dir}/include/query/optimizer/cost
		${include_dir}/include/query/optimzier/path
		${include_dir}/include/query/optimizer/plan
        ${include_dir}/include/query/parser
		#{include_dir}/include/query/misc
        ${include_dir}/include/query/parser/lex
        ${include_dir}/include/query/parser/keywords
		${include_dir}/include/execution
		${include_dir}/include/execution/gpu
		${include_dir}/include/execution/llvm
		${include_dir}/include/execution/simd
        ${include_dir}/include/system/
		${include_dir}/include/system/catalog
		src/include/system/statistics
		src/include/types
        )

#set the pthreads libs on windows platform.
#if(MSVC)
#include_directories(src/include/pthread)
#endif(MSVC)
#link directories

if(CMAKE_SIZEOF_VOID_P EQUAL 8 )
    set(ARCH_NAME x64)
else(CMAKE_SIZEOF_VOID_P EQUAL 8 )
    set(ARCH_NAME x86)
endif (CMAKE_SIZEOF_VOID_P EQUAL 8 )

message(STATUS "ARCH_NAME is ${ARCH_NAME}")

#set(BOOST_UNIT_TEST )
#if(NOT MSVC)
#set(BOOST_UNIT_TEST boost_unit_test_framework)
#endif(NOT MSVC)

#set(CMAKE_LINK_PATH "3rd_party/lib/${CMAKE_SYSTEM_NAME}/${ARCH_NAME}" ${CMAKE_LINK_PATH})
#set(XMLLIB_LINK_PATH "code/src/xxxxx/lib/${CMAKE_SYSTEM_NAME}/${ARCH_NAME}" ${TRANSFORMER_LIB_LINK_PATH})
#link_directories(${CMAKE_LINK_PATH}/boost
#                 ${CMAKE_LINK_PATH}/gettext
#                 ${CMAKE_LINK_PATH}/log4cxx
#                 ${CMAKE_LINK_PATH}/zlib
#                 ${CMAKE_LINK_PATH}/openssl
#                 ${CMAKE_LINK_PATH}/apache
#                 ${CMAKE_LINK_PATH}/icu
#                 ${CMAKE_LINK_PATH}/odbc
#                 ${CMAKE_LINK_PATH}/coredumper
#                 ${XMLLIB_LINK_PATH}
#                 ${CMAKE_LINK_PATH}/pcre)

# perform some platform specific definitions setup
#include(CMakeDefinitions.cmake)

# perform some system libraries stuff configuration
#include(CMakeLibraries.cmake)

# perform some compiler configuration
include(CMakeCompilers)

# custom script to build "tree"-like libraries
include(RecurseSrcs)

# script to configure binary tree
include(ConfigOutput)

#cpack config
include(CPackConfig)


# then start bulduing Transformer 
add_subdirectory(src)
message(STATUS "Adding the subdirectory src.")

# configure some files
ConfigOutputTree()

#set property folder.
set_property(GLOBAL PROPERTY USE_FOLDERS ON)
set_property(TARGET Executor                                        PROPERTY FOLDER "ExecutionEngine")
set_property(TARGET Query                                           PROPERTY FOLDER "QueryEngine")


#if (MSVC)
#    set_property(TARGET pthread                             PROPERTY FOLDER "Common")
#endif (MSVC)

if(FD_ENABLE_SERVER_TEST)
#set_property(TARGET ResultCombineTest                       PROPERTY FOLDER "Server")
endif(FD_ENABLE_SERVER_TEST)

# installing some additional files
# data and cfg dirtectories
#install(DIRECTORY DESTINATION docs COMPONENT help)
#install(DIRECTORY DESTINATION data COMPONENT core)
#install(DIRECTORY DESTINATION server COMPONENT core)
#install(DIRECTORY DESTINATION server/certification COMPONENT core)

#set boost file names.
set (boost_file_names chrono date_time filesystem program_options system thread  regex)
if(NOT FD_ENABLE_DISTRIBUTION)
set (boost_file_names unit_test_framework serialization ${boost_file_names})
endif(NOT FD_ENABLE_DISTRIBUTION)
MESSAGE(STATUS "boost_file_names:${boost_file_names}")


if (MSVC)
    set (ext ".dll")
    set (dic ".dic")
    file(GLOB gettextfiles  ${CMAKE_LINK_PATH}/gettext/*${ext})
    file(GLOB zlibfiles  ${CMAKE_LINK_PATH}/zlib/*${ext})
    foreach ( f ${boost_file_names})
        set (boostfiles ${boostfiles} ${CMAKE_LINK_PATH}/boost/boost_${f}-vc90-mt-1_57${ext})
        set (boostfilesdebug ${boostfilesdebug} ${CMAKE_LINK_PATH}/boost/boost_${f}-vc90-mt-gd-1_57${ext})
    endforeach(f)
    
	install(FILES ${gettextfiles}
            ${zlibfiles}
           CONFIGURATIONS Debug
           DESTINATION bin
            COMPONENT core
           )
    install(FILES ${gettextfiles}
           ${zlibfiles}
           CONFIGURATIONS Release|RelWithDebInfo|MinSizeRel
           DESTINATION bin
           COMPONENT core
           )
else (MSVC)
    set(ext ".so*")
    set (dic ".dic")
    file(GLOB gettextfiles  ${CMAKE_LINK_PATH}/gettext/*${ext})
    file(GLOB zlibfiles  ${CMAKE_LINK_PATH}/zlib/*${ext})
    file(GLOB coredumpfiles  ${CMAKE_LINK_PATH}/coredumper/*${ext})
    
	foreach ( f ${boost_file_names})
        file(GLOB boostcatfiles  ${CMAKE_LINK_PATH}/boost/*${f}${ext})
        set (boostfiles ${boostfiles} ${boostcatfiles})
    endforeach(f)
    
	install(FILES ${gettextfiles}
            ${zlibfiles}
            ${coredumpfiles}
            DESTINATION bin
            COMPONENT core
            )
endif (MSVC)

#install others for distribute and package
#if(FD_ENABLE_DISTRIBUTION) 
#endif(FD_ENABLE_DISTRIBUTION)

