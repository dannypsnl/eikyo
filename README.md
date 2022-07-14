# eikyo(影响)

eikyo is an experimental programming language, try to explore a mark system with usual polymorphic type, I will try to explain the idea informally in the following section.

First of all, polymorphic type means parameteric polymorphism here. For each type, they can have a set of marks. For example, `int positive` is a type `int` with a mark `positive`. A mark can be operated, for example, the following code shows a ownership system.

```kt
fun use(t : T -owned) : ()
  # ...

fun main() : ()
  let t : T +owned = # ...
  use(t)
  use(t) # error: t is not owned
```

The reason that works, is because `-mark` is saying I expected the argument has that mark, and will don't have that mark at caller environment after position get evaluated. This is important, because we might also write the following.

```kt
fun use1(a : A -owned) : B
  # ...

fun use2(a : A -owned, b : B -owned) : ()
  # ...

fun main() : ()
  let t : T +owned = # ...
  use2(t, use1(t)) # error: t is not owned at `use1`
```

This example shows the type of `t` get affected exactly at the position `use2(t, ...)` evaluated. Another part is `+owned`, the semantic of this is adding mark to the type if don't have.

A mark can associate with a contract, for example, we can have below code.

```kt
contract positive(n : int) : bool
  n > 0

fun main() : ()
  let a : int +positive = 1
```

The code will be expanded to

```kt
fun positive(n : int) : bool
  n > 0

fun main() : ()
  let a : int = 1
  @assert a.positive()
```

Thus, we can make sure the mark is correct, because the runtime will block invalid code.

All mark operations are

- `+`
- `-`
- `?+`
- `?-`
- require, when we didn't write any operation with mark, it requires the mark exists.

### Plan

1. A full compiler from source code to generated code, now having some problems
   - Haskell on m1(my computer) is unusable
   - llvm-hs has problem with brew installed llvm@12
2. Build s-expr version in racket as the prototype for digging

### Invite

We invite developers to participate, please contact (dannypsnl@gmail.com) if you are interested. A description of the semantics and syntax is developing. Due to the semantics and development content, there may be many unclear or undefined matters in the issue, and you are welcome to provide valuable comments.

Developers are expected to be proficient in FP(e.g. Haskell, Racket, SML) and able to develop independently in at least one of the following situations

1. parser: we use megaparsec to handle indented grammars
2. type system: based on Hindley-Milner, with additional "mark" system
3. macro system: macro based on syntax tree modification
4. llvm: some understanding of coding higher-order abstractions with llvm
5. package system: good experience in implementation, able to design or maintain system for package upload, installation, and compilation
6. standard library: interested in learning new languages and writing high-quality programs

Hopefully this note has really given you an idea of what you can contribute.

The principle of an issue is that it can be completed within a week (bug related is not limited to this)
If it cannot be completed within this time, which means that it is not clearly achievable, it will be referred to https://github.com/dannypsnl/eikyo/discussions. It's okay to open the wrong issue, the maintainer will let you know and move the content to the relevant location for you.
