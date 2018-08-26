---
title: "About"
date: 2018-08-25
---

Making a Just-In-Time compiler is complex, a large source of security
issues, and is a price which is frequently paid to have better performance
results.

HolyJit is made to remove this trade-off! Simplicity and security should no
longer be sacrificed for performance reasons.

# HolyJit

HolyJit is a high-level Just-In-Time compiler. It extends the Rust compiler
to convert the code of an interpreter written in Rust to tune a JIT compiler
to handle the same interpreted language.

HolyJit aims at being:

 * Easy.
 * Safe.
 * Fast.

### Easy

HolyJit extends the Rust compiler to copy its internal representation of
functions and convert it into a representation which can be consumed by the
JIT compiler provided by HolyJit library.

As a user, this implies that to inline a function in JIT compiled code, one
just need to annotate it with the `jit!` macro:

```rust
jit!{
    fn eval(script: &Script, args: &[Value]) -> Result<Value, Error>
    = eval_impl
    in script.as_ref()
}

fn eval_impl(script: &Script, args: &[Value]) -> Result<Value, Error> {
    // ...
    // ... A few hundred lines of ordinary Rust code later ...
    // ...
}

fn main() {
    let script = ...;
    let args = ...;
    // Call it as any ordinary function.
    let res = eval(&script, &args);
    println!("Result: {}", res);
}
```

Thus, you basically have to write an interpreter, and annotate it properly
to teach the JIT compiler what can be optimized by the compiler.

No assembly knowledge is required to start instrumenting your code to make
it available to the JIT compiler's set of known functions.

### Safe

Security issues from JIT compilers arise from:
  * Duplication of the runtime into a set of MacroAssembler functions.
  * Correctness of the compiler optimizations.

As HolyJit extends the Rust compiler to extract the effective knowledge of
the compiler, there is no more risk of having correctness issues caused by
the duplication of code.

Moreover, the code which is given to the JIT compiler is as safe as the code
users wrote in the Rust language.

As HolyJit aims at being a JIT library which can easily be embedded into
other projects, correctness of the compiler optimizations should be caught
by the community of users and fuzzers, thus leaving less bugs for you to
find.

### Fast

Fast is a tricky question when dealing with a JIT compiler, as the cost of
the compilation is part of the equation.

HolyJit aims at reducing the start-up time, based on annotations made out of
macros, to guide the early tiers of the compilers for unrolling loops and
generating inline caches.

For final compilation tiers, it uses special types/traits to wrap the data
in order to instrument and monitor the values which are being used, such
that guards can later be converted into constraints.

# HolyJit Website

For most people JIT are obscure beast. The more people understand them, the more
chances we have to catch issues in the logic of JIT compilers.

This website is a blog, which focus on 3 main categories to improve the
awareness of JIT users:

 * [Concepts](/categories/concepts/) are entries which are addressing one
   specific subject related to JIT compilers. You should not expect any code
   there, but some high level description of problems and solutions. This is a
   good way for a reader to know the subject.

 * [Implementations](/categories/implementations/) are entries which are
   trying to show case an implementation. Likely going along one concept
   described in a previous entry, and describing how the concept is translated
   into code. This is good way for a reader to get into contributing to an
   implementation, or just to satisfy the inherent curiosity of reading about
   the concepts.

 * [Usage](/categories/usage/) are entries which are focused on explaining how
   to use a JIT compiler, where to apply it, how to tune it and give example of
   how to apply it.
