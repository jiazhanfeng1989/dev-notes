---
id: 2d6cos1pfwffb9u3haim6o7
title: Profile
desc: ''
updated: 1751508937811
created: 1751507724300
---

# Description
There are 2 main ways profiling code can be done, by sampling or by instrumenting code.<br>
There are various advantage and disadvantages to both approaches.

## Sampling approach:
### Advantages:
- “Works out of the box” and does not require instrumenting the code with additional instructions.
- “Full” code coverage for free.
- Generally low overhead, depending on sampling rate.
### Disadvantages:
- Does not have to ability to show a timeline based profiling information, making it less useful when investigating flow dependent load times, etc.
- Because of its statistical nature, it can miss certain calls.
- Generally unable to filter out uninteresting functions, often more difficult to follow the stack traces.
- Inability to add markers/descriptions to functions (such as this functions was called with these params), which can often help debugging why a function/scope is slow in various situations.

## Instrumented code:
### Advantages:
- Allows for timeline visualizing, which provides a lot of additional context to the profiling data. <br>
It’s especially useful when spotting interlocking code or investigating flow dependent load times.
- Ability to add markers/descriptions to functions (such as this functions was called with these params), which can often help debugging why a function/scope is slow in various situations.
- Since the scopes are handpicked, we can filter them out however we want, making visualizing the data much easier

### Disadvantages:
- Requires manual instrumentation, by adding scopes to functions/scopes of interest.
- Instrumentation incurs a cost meaning that scopes which take a small amount of time (<1ms) but get called often will artificially inflate the cost of the parent scope (making it seem slower than it really is).

Examples of similar instrumented code profilers include [orbit](https://github.com/google/orbit) from google, [framepro](https://www.puredevsoftware.com/framepro/index.htm), [tracy](https://github.com/wolfpld/tracy). <br>
All of these have some pretty advanced features, most of which cannot be achieved with the regular sampled approach.

# References
[profilerpedia](https://profilerpedia.markhansen.co.nz/)<br>
[c++ profilers](https://hackingcpp.com/cpp/tools/profilers.html)<br>
[perfetto](https://perfetto.dev/docs/getting-started/system-tracing)
