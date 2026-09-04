---
id: sw4qdrl2xa04761xg89kcmj
title: CMake
desc: ''
updated: 1788492731669
created: 1788492263403
---

# Description

[CMake](https://cmake.org/) is a cross-platform build system generator. It reads `CMakeLists.txt` files and produces build files for Ninja, Make, Xcode, Visual Studio, and other backends.

# References

- [CMake documentation](https://cmake.org/cmake/help/latest/)
- [CMakeLists.txt reference](https://cmake.org/cmake/help/latest/manual/cmake-language.7.html)

# Usage

## Configure

Generate build files in an out-of-source build directory:

```shell
cmake -S . -B build [options]
```

Legacy form (run inside `build/`):

```shell
cmake -DCMAKE_INSTALL_PREFIX=${HOME}/cpplib/spdlog_1_15_3_custom ..
```

Here `..` is the source directory (parent of the current build dir), and `CMAKE_INSTALL_PREFIX` sets where `cmake --install` puts headers and libraries.

| Option | Meaning |
|--------|---------|
| `-S <dir>` | Source directory |
| `-B <dir>` | Build directory |
| `-G Ninja` | Generate a Ninja project (fast) |
| `-G "Unix Makefiles"` | Generate Makefiles |
| `-G Xcode` | Generate an Xcode project |
| `-DVAR=value` | Set a CMake cache variable |
| `-DCMAKE_BUILD_TYPE=Debug` | `Debug` / `Release` / `RelWithDebInfo` / `MinSizeRel` |
| `-DCMAKE_EXPORT_COMPILE_COMMANDS=ON` | Write `compile_commands.json` (for clangd) |
| `-DCMAKE_TOOLCHAIN_FILE=<file>` | Cross-compilation or platform toolchain |
| `-DCMAKE_PREFIX_PATH=<dir>` | Prefix for `find_package` search |
| `-DCMAKE_INSTALL_PREFIX=<dir>` | Install prefix (default: `/usr/local`) |
| `-DCMAKE_C_COMPILER=clang` | C compiler |
| `-DCMAKE_CXX_COMPILER=clang++` | C++ compiler |
| `-DCMAKE_POLICY_VERSION_MINIMUM=3.5` | Compatibility flag when configuring older projects with CMake 4 |
| `--fresh` | Drop old cache and re-configure (3.24+) |
| `-L` / `-LAH` | List cache variables |
| `--debug-find` | Debug `find_package` / library lookup failures |
| `-Wdev` / `-Wno-dev` | Toggle developer warnings |

`-D` can be repeated:

```shell
cmake -S . -B build -G Ninja \
  -DCMAKE_BUILD_TYPE=Debug \
  -DCMAKE_EXPORT_COMPILE_COMMANDS=ON
```

## Build and install

After configure succeeds:

```shell
cmake --build build -j 8
cmake --build build --target <target_name>
cmake --install build
```

| Option | Meaning |
|--------|---------|
| `--build <dir>` | Build in the given directory (invokes ninja/make/xcodebuild) |
| `-j N` / `--parallel` | Parallel job count |
| `--target foo` | Build a single target |
| `--config Debug` | Select configuration for multi-config generators (VS, Xcode) |
| `--clean-first` | Clean before building |
| `--install <dir>` | Install to `CMAKE_INSTALL_PREFIX` |

## Clean

```shell
cmake --build build --target clean
# Or remove the build directory and re-run cmake -S … -B …
```

## Typical workflow

```shell
# 1. Configure
cmake -S . -B build -G Ninja \
  -DCMAKE_BUILD_TYPE=Debug \
  -DCMAKE_EXPORT_COMPILE_COMMANDS=ON

# 2. Build
cmake --build build -j

# 3. Install (optional)
cmake --install build
```

Install a dependency to a custom prefix (example: spdlog):

```shell
cmake -S . -B build \
  -DCMAKE_INSTALL_PREFIX=${HOME}/cpplib/spdlog_1_15_3_custom
cmake --build build -j
cmake --install build
```

Other projects can then find it via:

```shell
cmake -S . -B build -DCMAKE_PREFIX_PATH=${HOME}/cpplib/spdlog_1_15_3_custom
```
