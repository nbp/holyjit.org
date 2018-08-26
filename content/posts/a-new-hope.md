---
title: "A New Hope"
date: "2017-10-20"
tags: [ "Mozilla", "JavaScript" ]
categories: [ "Annoucement" ]
authors: [ "Nicolas B. Pierron" ]
---

This blog post was [originaly posted](https://blog.mozilla.org/javascript/2017/10/20/holyjit-a-new-hope/) on [Mozilla's JavaScript blog](https://blog.mozilla.org/javascript/) by Nicolas B. Pierron.

tl;dr: We believe there is a safer and easier way of writing a Jit.

# Current State

Today, all browsers’ Jits share a similar design. This design makes extending
the language or improving its performance time-consuming and complex, especially
while avoiding security issues.

For instance, at the time of this writing, our Jit relies upon ~15000 lines of
carefully crafted, hand-written assembly code (~36000 in Chromium’s v8). The Jit
directory represents 5% of all the C++ code of Firefox, and contains 3 of the
top 20 largest files of Firefox, all written by hand.

Interestingly, these files all contain code that is derived by hand from the
Interpreter and a limited set of built-in functions of the JavaScript engine.
But why do it by hand, when we could automatize the process, saving time and
risk? HolyJit is exploring this possibility.

# Introducing HolyJit (prototype)

This week, during the JS Team meetup, we have demonstrated the first prototype
of a Rust meta-Jit compiler, named HolyJit. If our experiment proves successful,
we believe that employing a strategy based on HolyJit will let us avoid many
potential bugs and let us concentrate on strategic issues. This means more time
to implement JavaScript features quickly and further improve the speed of our
Jit.

![HolyJit library instrumenting the Rust compiler to add a meta-Jit for Rust
code.](https://nbp.github.io/slides/HolyJit/JitTeamIntro/pictures/hj-overview.svg)

For instance, in [a recent
change](https://hg.mozilla.org/mozilla-central/rev/8b1881ead0b6), we extended
the support of optimizations to Array.prototype.push. What should have been a
trivial modification required diving into safety-critical code and adding 135
lines of code, and reading even more code to check that we were not accidentally
breaking invariants.

With HolyJit, what should have been a trivial change would effectively have been
a trivial change. The following change to a hypothetical JS Jit built with
HolyJit does exactly the same thing as [the previous
patch](https://hg.mozilla.org/mozilla-central/rev/8b1881ead0b6), i.e. allowing
the Jit to inline the Array.prototype.push function when it is being called with
more than one argument.

```diff
 fn array_push(args: &CallArgs) -> Result<JSValue, Error> {
-    jit_inline_if!(args.len() == 1);
+    jit_inline_if!(args.len() >= 1);
     …
 }
```

By making changes self-contained and simple, we hope that HolyJit will improve
the safety of our Jit engine, and let us focus on optimizations.

HolyJit Repository: https://github.com/nbp/holyjit

Thanks to David Teller, Jason Orendorff, Sean Stangl, Jon Coppeard for proof
reading this blog post.
