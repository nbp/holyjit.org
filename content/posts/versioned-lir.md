---
title: "Optimizing for Deoptimizations"
date: "2018-06-01"
tags: [ "IR", "Tier" ]
categories: [ "Concepts" ]
authors: [ "Nicolas B. Pierron" ]
draft: true
---

When would Just-In-Time compilers definitely win over Ahead-Of-Time compilers?
One thing which is even stranger to me, is that Today's JIT compilers are
designed like AOT compilers.

How can you win, if you have the same design as the other, but less time to make
it happen? In case of optimizing compilers, the design would be the SSA form, or
the Sea-Of-Nodes representation.

JIT compilers are not the ordinary AOT compilers. They are implementing the same
language as the one which is interpreted, but they use information collected at
the execution to optimize the code. They do so by monitoring the information
during the previous tier of executions, by using Inline Caches or some other
forms of memoization.

# Deoptimization Cost

A JIT compiler still has to follow the original semantics and it has to
keep some deoptimization code paths around to fallback on lower tiers of
executions.

In 2016, I wondered if it was possible to evaluate the "cost" of a
deoptimization. I we could reduce the cost of a deoptimization, then we could do
more eager optimizations, which might not even be proovable, but which we could
guard against.

The first thing to notice is that the cost of a deoptimization, is not only the
time needed for replacing the stack and resuming the execution. The cost is the
extra time spent running in a lower execution tier and the recompilation time.

The extra time in a lower execution tier depends on rules for restarting the
compilation. If we assume that we reset the expected execution time, and use the
expected time described in the Adaptive Optimization in the Jalapeño JVM paper,
then the deoptimizations cost `D_j` can be express as being between the
compilation time `C_j` and the minimal estimated runtime which triggers a
recompilation (`2 * (C_j + T_j)`), in case of a resetted expectation.

Thus optimizing for deoptimization, corresponds to optimizing the compilation
time.

# Reduce the Cost

## Avoid the Snowball Effect

JIT engineers, afraid of deoptimizations, might cause a snowball effect. By
attempting to avoid deoptimizations, JIT engineers will implement costly
algorithm to proove the generated code. Thus making the compilation time larger,
and the deoptimization cost higher. This snowball effect causes JIT compiler
design to look more like AOT compilers.

While I agree, that guards might become expensive in highly optimized code, they
might be cheaper than prooving the same property. One option to optimize
optimizing JIT would be to add more guards driven optimizations. As opposed to
AOT, JIT compilers can safely do eager optimizations as long as they have a way
to fallback when the unexpected case happens.

<!-- TODO: Add some examples -->

## Cheaper Recompilation

The cost of a deoptimization is proportional to time of the recompilation.
Today, static compilers are making use of incremental compilation to reduce the
time needed to recompile a project.

Unfortunately, what AOT are calling incremental compilation is recompiling
entire methods. This kind of recompilation does not add any value to method JIT
compilers. Trace compilation and basic block versionning are forms of
incremental compilation where the increments are linear sequences of code.

Would it be possible to have an incremental compilation at a granularity smaller
than a method while keeping a method compilation approach? The answer is yes,
but this would be the topic of another post.



<!--
The paper about Adaptive Optimization in the Jalapeño JVM (now renamed to Jikes
RVM) give us the vocabulary to express the deoptimization cost:
 - `T_i`, the expected remaining time running the method `m`.
 - `C_i`, the time needed for compiling the method `m` at the tier `i`.
 - `S_i`, the speed-up of the code of the method `m` compiled at the tier `i`,
   compared to default tier of execution.

Choosing a compilation tier is made by looking for the compilation tier which
minimize the compilation time of the tier `j` with the time remaining at the
tier `j`, which should at least be lower than the remaining time `T_i` at the current
tier to gain performances later on. (`C_j + T_j < T_i`)

Going a bit futher than the paper, we can define the remaining time in function
of the default tier as `T_j = T_0 / S_j`. Thus we can rewrite the previous
condition as `C_j < T_0 * (1 / S_i - 1 / S_j)`

Now we have the vocabulary, we can express the deoptimization cost as the time `t_i`
spent while running a lower tier `i`, waiting to get back to the optimized tier `j`. The
time spent while running in lower tier, is exactly the time waiting for the
result of the next compilation. `D_{i,j} = t_i + C_j`

Adaptive Optimization: https://www.researchgate.net/publication/2808142_Adaptive_Optimization_in_the_Jalapeno_JVM
Jikes RVM: https://en.wikipedia.org/wiki/Jikes_RVM
-->



<!--
the speed-up without increasing the exepected remaining time.


Today performances highlight that JIT compilers are able to learn how to
generate a program equivalent to what a programmer would do in a AOT compiled
language, by specializing types.


JIT compilers are definitely providing more optimizations. When faced with an interpreted language, your can expect HUGE speed-ups depending on the comple


Why are optimizing Just-In-Time compilers similar to ordinary Ahead-Of-Time compilers? There is a different


# Optimizing Compilers

Today


definitely win over: https://benchmarksgame-team.pages.debian.net/benchmarksgame/which-programs-are-fast.html
SSA form: https://en.wikipedia.org/wiki/Static_single_assignment_form
Sea of nodes: http://www.oracle.com/technetwork/java/javase/tech/c2-ir95-150110.pdf
Inline Caches: https://en.wikipedia.org/wiki/Inline_caching
-->
