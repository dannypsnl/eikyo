# eikyo(影响)

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
