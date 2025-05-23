---
id: i436wgdh2hvjlals4wdk1r6
title: Boost
desc: ''
updated: 1747990627467
created: 1747988275452
---

# Description
[boost](https://www.boost.org/doc/user-guide/index.html) is a collection of libraries that extend the functionality of C++. It provides a wide range of features, including smart pointers, regular expressions, and multi-threading support. Boost is widely used in the C++ community and serves as a foundation for many other libraries and frameworks.

## Installation
Install Boost 1.84.0
- 1. git clone --depth 1 -b boost-1.84.0 https://github.com/boostorg/boost.git boost_1_84_0
- 2. cd boost_1_84_0
- 3. ./bootstrap.sh
- 4. ./b2 install --prefix=${HOME}/boost_1_84_0_custom
   - optional1 ./b2 --show-libraries // list all libraries
   - optional2 ./b2 --with-xxx // build specific library
   - optional3 ./b2 -j4 // build with 4 threads
   - optional4 ./b2 install --prefix=${HOME}/boost_1_84_0_custom --without-thread --without-test -j4
