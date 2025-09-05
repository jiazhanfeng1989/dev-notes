---
id: on2qz3a6abodbpou4pp2mxk
title: Best Practices
desc: ''
updated: 1756802939093
created: 1756358433773
---

# Description
Some best practices for programming and C++.

# Documents
- [Awesome Cpp](https://awesomecpp.com/) A curated list of awesome C++ libraries, frameworks, and resources.
- [Cpp Core Guidelines](https://isocpp.github.io/CppCoreGuidelines/CppCoreGuidelines) The C++ Core Guidelines are a set of guidelines.
- [Bjarne Stroustrup C++ Pointer](https://www.stroustrup.com/C++.html) - Bjarne Stroustrup C++ blog.
- [Modern C++](http://www.modernescpp.com/) A blog about modern C++.
- [A Unified Executors Proposal](https://www.open-std.org/jtc1/sc22/wg21/docs/papers/2020/p0443r13.html) A proposal for a unified executors library.

# Books
Some recommended books about programming and C++, consider the copyright, there wil be no book link.
- Refactoring: Improving the Design of Existing Code (重构：改善既有代码的设计)
- Clean Code (代码整洁之道)
- Clean Architecture (架构整洁之道)
- Introduction to Algorithms (算法导论)
- Domain-Driven Design: Tackling Complexity in the Heart of Software (领域驱动设计：软件核心复杂性应对之道)
- Effective STL (STL高效编程)
- Effective Modern C++ (Effective Modern C++)
- Exceptional C++: 47 Engineering Puzzles, Programming Problems, and Solutions (C++异常编程)
- C++ Concurrency in Action (C++并发编程)
- Optimized C++ (C++性能优化指南)
- Functional Programming in C++ (C++函数式编程)
  - [C++ 函数编程笔记](https://github.com/helywin/functional_programming_practice?tab=readme-ov-file)
- C++ Templates: The Complete Guide (C++模板编程)
- 程序员的自我修养
  - [程序员的自我修养-链接封装与库](https://ochicken.net/library/Computer_System/%E7%A8%8B%E5%BA%8F%E5%91%98%E7%9A%84%E8%87%AA%E6%88%91%E4%BF%AE%E5%85%BB%E2%80%94%E9%93%BE%E6%8E%A5%E3%80%81%E8%A3%85%E8%BD%BD%E4%B8%8E%E5%BA%93.pdf)
  - [程序员的自我修养-总结笔记](https://blog.csdn.net/fengbingchun/article/details/102230252)

# Best Practices
## Function C++ Comparison Table
1. Map
FP 概念：map(f, xs) → 对每个元素应用函数 f
C++ 概念：std::transform(first, last, result, unary_op) → 对每个元素应用函数 unary_op
```cpp
std::vector<int> xs = {1, 2, 3, 4, 5};
std::vector<int> ys = std::transform(xs.begin(), xs.end(), xs.begin(), [](int x) { return x * 2; });
```
2. Filter
FP 概念：filter(p, xs) → 对每个元素应用函数 p，返回满足条件的元素
C++ 概念：std::copy_if(first, last, result, pred) → 对每个元素应用函数 pred，返回满足条件的元素
```cpp
std::vector<int> xs = {1, 2, 3, 4, 5};
std::vector<int> ys = std::copy_if(xs.begin(), xs.end(), xs.begin(), [](int x) { return x % 2 == 0; });
```
3. Reduce & Fold
FP 概念：reduce(f, xs) → 对每个元素应用函数 f，返回累加结果
C++ 概念：std::accumulate(first, last, init) → 对每个元素应用函数 f，返回累加结果
```cpp
std::vector<int> xs = {1, 2, 3, 4, 5};
int sum = std::accumulate(xs.begin(), xs.end(), 0, [](int acc, int x) { return acc + x; });
```
4. Count
FP 概念：count(p, xs) → 对每个元素应用函数 p，返回满足条件的元素个数
C++ 概念：std::count_if(first, last, pred) → 对每个元素应用函数 pred，返回满足条件的元素个数
```cpp
std::vector<int> xs = {1, 2, 3, 4, 5};
int count = std::count_if(xs.begin(), xs.end(), [](int x) { return x % 2 == 0; });
```
5. Find
FP 概念：find(p, xs) → 对每个元素应用函数 p，返回满足条件的元素
C++ 概念：std::find_if(first, last, pred) → 对每个元素应用函数 pred，返回满足条件的元素
```cpp
std::vector<int> xs = {1, 2, 3, 4, 5};
int find = std::find_if(xs.begin(), xs.end(), [](int x) { return x % 2 == 0; });
```
6. Any
FP 概念：any(p, xs) → 对每个元素应用函数 p，返回满足条件的元素
C++ 概念：std::any_of(first, last, pred) → 对每个元素应用函数 pred，返回满足条件的元素
```cpp
std::vector<int> xs = {1, 2, 3, 4, 5};
bool any = std::any_of(xs.begin(), xs.end(), [](int x) { return x % 2 == 0; });
```
7. All
FP 概念：all(p, xs) → 对每个元素应用函数 p，返回满足条件的元素
C++ 概念：std::all_of(first, last, pred) → 对每个元素应用函数 pred，返回满足条件的元素
```cpp
std::vector<int> xs = {1, 2, 3, 4, 5};
bool all = std::all_of(xs.begin(), xs.end(), [](int x) { return x % 2 == 0; });
```
8. Sort
FP 概念：sort(xs) → 对每个元素应用函数 p，返回满足条件的元素
C++ 概念：std::sort(first, last, comp) → 对每个元素应用函数 comp，返回满足条件的元素
```cpp
std::vector<int> xs = {1, 2, 3, 4, 5};
std::sort(xs.begin(), xs.end(), [](int x, int y) { return x < y; });
```
9. Range / Generate
FP 概念：range(start, end) → 生成一个从 start 到 end 的序列
C++ 概念：std::iota(first, last, value) → 生成一个从 value 到 value + (last - first) 的序列
```cpp
std::vector<int> xs = {1, 2, 3, 4, 5};
std::iota(begin(xs), end(xs), start);          // 生成等差序列
std::generate(begin(xs), end(xs), generator);  // 按函数生成
```