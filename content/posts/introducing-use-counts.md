---
title: "Introducing Use-Counts"
date: "2018-09-01"
tags: [ "Tier" ]
categories: [ "Concepts" ]
authors: [ "Nicolas B. Pierron" ]
---

One of the paper I like about Just-In-Time compiler is about dealing with a
choice between multiple optimization toogles. The research paper [Adapative
Optimization in the Jalapeño
JVM](https://www.researchgate.net/publication/2808142_Adaptive_Optimization_in_the_Jalapeno_JVM)
describes how a JIT should decide which optimization it should select when
compiling.

The first thing this paper defines is that for each method we associate an
expected time `T`. This time is an estimate of the time the function is expected
to run later on. A simple and intuitive way to define this time, is to assume
that functions are going run as much time as we have seen the method run until
now, i-e. `T(t) = t`.

Then, given the estimated time remaining to be executed, the question which we
are trying to solve is if it would be better to spend time `C` to compile the
function in order to gain an estimated speed-up `S` from it. Literally answering
the following equation `C + T / S < T`.

If you have a choice between multiple compilers, or between multiple
optimization toggles, then you want to choose the configuration which minimize
the remaining time, i-e `min_i( C_i + T / S_i ) < T`. The research paper stops
at this point.

This equation is interesting, but it would be better if the compiler time and
speed-up estimate (expected to be strictly larger than 1) were on the same side.
We can do that by moving all `T` to the right, factoring by `T`, and moving the
speed-up `S` back next to the compilation time `C`, resulting in the following
inegality `C * S / (S - 1) < T`.

The nice property about this inequality is that the left hand side that we are
trying to minimize no longer depends on the expected time. However, the
compilation time depends on the size of the method, maybe as a function of the
number of operations `O`. Thus instead of considering the expected time of a
method, we could consider the expected average time per operation. `C * S / (O *
(S - 1)) < T / O`.

The average expected time per operation is even more interesting when the
compilation time is linear with the number of operations as the left-hand side
becomes a constant, such as expected with a fast JIT compiler or a simple trace
compiler. What this implies is that we can trigger such compilation by comparing
the number of time a given operation got executed, also named use-count, with a
constant. A use-count indirectly count time by counting the number of times a
given instruction has been executed.

In the general case, for compilers which compilation time is not linear with the
number of operations, then we would have to compute `C(O) / O * S / (S - 1)` to
decide when is a good time for compiling when comparing it against the use-count
of the method.
