---
id: 9zio5f0cupqvkw4j4g1m5fx
title: Opensource
desc: ''
updated: 1772791586161
created: 1752630436332
---
# Description
Some of the opensource projects collected.

- [fmt](https://github.com/fmtlib/fmt) - A modern formatting library.
- [spdlog](https://github.com/gabime/spdlog) - Fast C++ logging library.
- [gtest](https://github.com/google/googletest) - Google Test - Google's C++ test framework.
- [nanobench](https://github.com/martinus/nanobench/tree/master) - Simple, fast, accurate single-header microbenchmarking library for C++.
- [Catch2](https://github.com/catchorg/Catch2) - A modern, C++-native, header-only, test framework for unit-tests.
- [doctest](https://github.com/doctest/doctest) - A modern, C++-native, header-only, test framework for unit-tests.
- [gmock](https://github.com/google/googletest) - Google Mock - Google's C++ mocking framework.
- [nlohmannJson](https://github.com/nlohmann/json) - JSON for Modern C++, header-only.
- [rapidjson](https://github.com/Tencent/rapidjson) - A fast JSON parser/generator for C++ with both SAX/DOM style API.
- [protobuf](https://github.com/protocolbuffers/protobuf) - Protocol Buffers - Google's data interchange format.
- [flatbuffers](https://github.com/google/flatbuffers) - FlatBuffers is an efficient cross platform serialization library.
- [CLI11](https://github.com/CLIUtils/CLI11) - CLI11 is a command line parser for C++11, header-only.
- [concurrentqueue](https://github.com/cameron314/concurrentqueue) - A fast multi-producer, multi-consumer lock-free concurrent queue for C++11.
- [libzmq](https://github.com/zeromq/libzmq) - ZeroMQ core engine in C++, implemented as a C++03 library.
- [nghttp2](https://github.com/nghttp2/nghttp2) - HTTP/2 C Library.
- [hiredis](https://github.com/redis/hiredis) - A minimalistic C client for the Redis database.
- [redis-plus-plus](https://github.com/sewenew/redis-plus-plus) - A C++ client for Redis.
- [openssl](https://github.com/openssl/openssl) - OpenSSL is a cross-platform library for TLS and SSL protocols, including SSLv2 and SSLv3.
- [rocksdb](https://github.com/facebook/rocksdb) - A library that provides an embeddable, persistent key-value store for fast storage.
- [boost](https://github.com/boostorg/boost) - Boost is a library of peer-reviewed, free-standing libraries for C++.
- [c-ares](https://github.com/c-ares/c-ares) - c-ares is a C library for asynchronous DNS requests.
- [curl](https://github.com/curl/curl) - A command line tool and library for transferring data with URLs.
- [grpc](https://github.com/grpc/grpc) - A high performance, open-source, general-purpose RPC framework.
- [lua](https://github.com/lua/lua) - Lua is a powerful, efficient, lightweight, embeddable scripting language.
- [Optional](https://github.com/akrzemi1/Optional) - A single-header header-only library for representing optional (nullable) objects for C++14.
- [protozero](https://github.com/mapbox/protozero) - A super fast serialization/deserialization library for C++.
- [sqlite](https://github.com/sqlite/sqlite) - SQLite is a C library that implements a self-contained, serverless, zero-configuration, transactional SQL database engine.
- [zlib](https://github.com/madler/zlib) - A compression library for C.
- [abseil](https://github.com/abseil/abseil-cpp) - Abseil is a collection of libraries for C++.
- [robin-hood-hashing](https://github.com/martinus/robin-hood-hashing) - A fast hash map implementation for C++.
- [libevent](https://github.com/libevent/libevent) - An event notification library for C.


# Installation
## spdlog installation:
```bash
1. git clone --depth 1 -b v1.15.3 https://github.com/gabime/spdlog.git spdlog_1_15_3
2. cd spdlog_1_15_3
3. mkdir build && cd build
4. cmake -DCMAKE_INSTALL_PREFIX=${HOME}/cpplib/spdlog_1_15_3_custom ..
5. make -j4
6. make install
```

## Using spdlog in CMakeLists.txt:
```cmake
find_package(spdlog 1.15.3 QUIET)
if(NOT spdlog_FOUND)
    # If not found, set custom paths and try again
    message(STATUS "spdlog cmake not found in default path, try to use custom spdlog cmake path")
    message(STATUS "spdlog custom cmake path: $ENV{HOME}/cpplib/spdlog_1_15_3_custom/share/cmake/spdlog")
    set(spdlog_DIR "$ENV{HOME}/cpplib/spdlog_1_15_3_custom/share/cmake/spdlog")
    find_package(spdlog 1.15.3 REQUIRED)
else()
    message(STATUS "spdlog found in default path")
    find_package(spdlog 1.15.3 REQUIRED)
endif()

target_link_libraries(${TARGET} spdlog::spdlog)
```

## nlohmann_json installation:
```bash
1. git clone --depth 1 -b v3.12.0 https://github.com/nlohmann/json.git nlohmann_json_3_12_0
2. cd nlohmann_json_3_12_0
3. mkdir build && cd build
4. cmake -DCMAKE_INSTALL_PREFIX=${HOME}/cpplib/nlohmann_json_3_12_0_custom ..
5. make -j4
6. make install
```
## Using nlohmann_json in CMakeLists.txt:
```cmake
find_package(nlohmann_json 3.12 QUIET)
if(NOT nlohmann_json_FOUND)
    # If not found, set custom paths and try again
    message(STATUS "nlohmann_json cmake not found in default path, try to use custom nlohmann_json cmake path")
    message(STATUS "nlohmann_json custom cmake path: $ENV{HOME}/cpplib/nlohmann_json_3_12_0_custom/share/cmake/nlohmann_json")
    set(nlohmann_json_DIR "$ENV{HOME}/cpplib/nlohmann_json_3_12_0_custom/share/cmake/nlohmann_json")
    find_package(nlohmann_json 3.12 REQUIRED)
else()
    message(STATUS "nlohmann_json found in default path")
    find_package(nlohmann_json 3.12 REQUIRED)
endif()

target_link_libraries(${TARGET} nlohmann_json::nlohmann_json)
```

## doctest installation:
```bash 
1:git clone --depth 1 -b v2.4.12 https://github.com/doctest/doctest.git doctest_2_4_12
2:cd doctest_2_4_12
3:mkdir build && cd build
4:cmake -DCMAKE_INSTALL_PREFIX=${HOME}/cpplib/doctest_2_4_12_custom ..
5:make -j4 && make install
```

## Using doctest in CMakeLists.txt:
```cmake
find_package(doctest 2.4 QUIET) 
if(NOT doctest_FOUND)
    # If not found, set custom paths and try again
    message(STATUS "doctest cmake not found in default path, try to use custom doctest cmake path")
    message(STATUS "doctest custom cmake path: $ENV{HOME}/cpplib/doctest_2_4_12_custom/share/cmake/doctest")
    set(doctest_DIR "$ENV{HOME}/cpplib/doctest_2_4_12_custom/lib/cmake/doctest")
    find_package(doctest 2.4 REQUIRED)
else()
    message(STATUS "doctest found in default path")
    find_package(doctest 2.4 REQUIRED)
endif()

target_link_libraries(${TARGET} doctest::doctest)
```

## flatbuffers installation:
```bash
1: git clone --depth 1 -b v1.12.1 https://github.com/google/flatbuffers.git flatbuffers_1_12_1
2: cd flatbuffers_1_12_1
3: mkdir buildcmake && cd buildcmake
4: cmake -DCMAKE_INSTALL_PREFIX=${HOME}/cpplib/flatbuffers_1_12_1_custom -DFLATBUFFERS_BUILD_TESTS=OFF -DCMAKE_CXX_FLAGS="-Wno-error=unused-but-set-variable
5: make -j4
6: make install
```

## Using flatbuffers in CMakeLists.txt:
```cmake
find_package(flatbuffers 1.12.1 QUIET)
if(NOT flatbuffers_FOUND)
    # If not found, set custom paths and try again
    message(STATUS "flatbuffers cmake not found in default path, try to use custom flatbuffers cmake path")
    message(STATUS "flatbuffers custom cmake path: $ENV{HOME}/cpplib/flatbuffers_1_12_1_custom/lib/cmake/flatbuffers")
    set(flatbuffers_DIR "$ENV{HOME}/cpplib/flatbuffers_1_12_1_custom/lib/cmake/flatbuffers")
    find_package(flatbuffers 1.12.1 REQUIRED)
else()
    message(STATUS "flatbuffers found in default path")
    find_package(flatbuffers 1.12.1 REQUIRED)
endif()

target_link_libraries(${TARGET} flatbuffers::flatbuffers)
```

## zlib installation:
```bash
1. git clone --depth 1 -b v1.3.1 https://github.com/madler/zlib.git zlib_1_3_1
2. cd zlib_1_3_1
3. mkdir build && cd build
4. cmake -DCMAKE_INSTALL_PREFIX=${HOME}/cpplib/zlib_1_3_1_custom ..
5. make -j4
6. make install
```
## Using zlib in CMakeLists.txt:
```cmake
find_package(PkgConfig REQUIRED)
find_package(ZLIB 1.3.1 QUIET)
if(NOT ZLIB_FOUND)
    message(STATUS "ZLIB not found in default path, try to use custom ZLIB path")
    message(STATUS "ZLIB custom path: $ENV{HOME}/cpplib/zlib_1_3_1_custom")
    set(ZLIB_ROOT "$ENV{HOME}/zlib_1_3_1_custom")
       
    # Set PKG_CONFIG_PATH for pkgconfig to find zlib.pc
    set(ENV{PKG_CONFIG_PATH} "$ENV{HOME}/cpplib/zlib_1_3_1_custom/share/pkgconfig:$ENV{PKG_CONFIG_PATH}")
    
    # Try with pkg-config first
    pkg_check_modules(PC_ZLIB QUIET zlib)
    if(PC_ZLIB_FOUND)
        set(ZLIB_INCLUDE_DIRS ${PC_ZLIB_INCLUDE_DIRS})
        set(ZLIB_LIBRARIES ${PC_ZLIB_LIBRARIES})
        set(ZLIB_LIBRARY_DIRS ${PC_ZLIB_LIBRARY_DIRS})
        set(ZLIB_FOUND TRUE)
        message(STATUS "Found ZLIB via pkg-config: ${ZLIB_LIBRARIES}")
    else()
        # Fallback to manual discovery
        find_path(ZLIB_INCLUDE_DIR zlib.h HINTS $ENV{HOME}/cpplib/zlib_1_3_1_custom/include)
        find_library(ZLIB_LIBRARY NAMES z zlib HINTS $ENV{HOME}/cpplib/zlib_1_3_1_custom/lib)
        
        if(ZLIB_INCLUDE_DIR AND ZLIB_LIBRARY)
            set(ZLIB_INCLUDE_DIRS ${ZLIB_INCLUDE_DIR})
            set(ZLIB_LIBRARIES ${ZLIB_LIBRARY})
            set(ZLIB_FOUND TRUE)
            message(STATUS "Found ZLIB manually: ${ZLIB_LIBRARY}")
        else()
            message(FATAL_ERROR "Could not find ZLIB in custom path")
        endif()
    endif()
    
    # Create imported target if it doesn't exist
    if(ZLIB_FOUND AND NOT TARGET ZLIB::ZLIB)
        add_library(ZLIB::ZLIB UNKNOWN IMPORTED)
        set_target_properties(ZLIB::ZLIB PROPERTIES
            IMPORTED_LOCATION "${ZLIB_LIBRARY}"
            INTERFACE_INCLUDE_DIRECTORIES "${ZLIB_INCLUDE_DIRS}")
    endif()
else()
    message(STATUS "ZLIB found in default path")
endif()

target_link_libraries(${TARGET} ZLIB::ZLIB)
```

## libsodium installation:
```bash
1: download the libsodium source code from https://github.com/jedisct1/libsodium/releases
2: cd libsodium-1.0.18
3: ./configure --prefix=/Users/zhfjia/cpplib/libsodium-1.0.18_custom
4: make && make install
```

## Using libsodium in CMakeLists.txt:
```cmake
pkg_check_modules(SODIUM libsodium)
if(NOT SODIUM_FOUND)
    message(STATUS "libsodium not found in default path, trying custom path")
    set(ENV{PKG_CONFIG_PATH} "$ENV{HOME}/cpplib/libsodium-1.0.18_custom/lib/pkgconfig:$ENV{PKG_CONFIG_PATH}")
    pkg_check_modules(SODIUM REQUIRED libsodium)
else()
    message(STATUS "libsodium found in default path")
endif()

target_link_libraries(${TARGET} SODIUM::SODIUM)
```

## zeromq installation:
```bash
1. download the zeromq source code from https://github.com/zeromq/libzmq/releases
2. cd libzmq-4.3.5
3. mkdir build && cd build
4. cmake -DCMAKE_INSTALL_PREFIX=${HOME}/cpplib/libzmq-4.3.5_custom \
      -DBUILD_STATIC=ON \
      -DBUILD_SHARED=OFF \
      -DWITH_DOCS=OFF \
      -DBUILD_TESTS=OFF \
      -DENABLE_DRAFTS=ON \
      -DWITH_LIBSODIUM=ON \
      -DWITH_LIBSODIUM_STATIC=ON \
      -DENABLE_CURVE=ON \
      -DENABLE_WS=OFF \
      -DENABLE_RADIX_TREE=OFF \
      -DCMAKE_PREFIX_PATH=${HOME}/cpplib/libsodium-1.0.18_custom ..
5. make -j4
6. make install
```

## Using zeromq in CMakeLists.txt:
```cmake
find_package(ZeroMQ 4.3.5 QUIET)
if(NOT ZeroMQ_FOUND)
    # If not found, set custom paths and try again
    message(STATUS "ZeroMQ cmake not found in default path, try to use custom ZeroMQ cmake path")
    message(STATUS "ZeroMQ custom cmake path: $ENV{HOME}/cpplib/libzmq-4.3.5_custom/lib/cmake/ZeroMQ")
    set(ZeroMQ_DIR "$ENV{HOME}/cpplib/libzmq-4.3.5_custom/lib/cmake/ZeroMQ")
    find_package(ZeroMQ 4.3.5 REQUIRED)
else()
    message(STATUS "ZeroMQ found in default path")
    find_package(ZeroMQ 4.3.5 REQUIRED)
endif()

target_link_libraries(${TARGET} ZeroMQ::ZeroMQ)
```

## cppzmq installation:
```bash
1. git clone --branch v4.10.0 --depth 1 https://github.com/zeromq/cppzmq.git cppzmq-4.10.0
2. cd cppzmq-4.10.0
3. mkdir -p cppzmq-4.10.0/build && cmake -S cppzmq-4.10.0 -B cppzmq-4.10.0/build \
      -DCMAKE_INSTALL_PREFIX=/Users/zhfjia/cpplib/cppzmq-4.10.0_custom \
      -DCPPZMQ_BUILD_TESTS=OFF \
      -DZeroMQ_DIR=/Users/zhfjia/cpplib/libzmq-4.3.5_custom/lib/cmake/ZeroMQ
    
4. cmake --install cppzmq-4.10.0/build
```

## Using cppzmq in CMakeLists.txt:
```cmake
find_package(cppzmq 4.10.0 QUIET)
if(NOT cppzmq_FOUND)
    message(STATUS "cppzmq not found in default path, trying custom path")
    set(cppzmq_DIR "$ENV{HOME}/cpplib/cppzmq-4.10.0_custom/lib/cmake/cppzmq")
    find_package(cppzmq 4.10.0 REQUIRED)
else()
    message(STATUS "cppzmq found in default path")
endif()

target_link_libraries(${TARGET} cppzmq::cppzmq)
```