https://adventofcode.com/

Doing each day in a different language

- [x] Day 1: Haskell
- [x] Day 2: OCaml
- [x] Day 3: Nim
- [ ] Day 4: Crystal
- [ ] Day 5: Scala
- [ ] Day 6: Clojure
- [ ] Day 7: Gleam
- [ ] Day 8: Idris
- [ ] Day 9: Kotlin
- [ ] Day 10: Swift
- [ ] Day 11: Zig
- [ ] Day 12: Roc

Languages to maybe switch out with
- https://vale.dev/
- https://hylo-lang.org/ (research language... maybe not?)
- https://raku.org/
- https://www.ponylang.io/
- https://www.unison-lang.org/
- https://koka-lang.github.io/koka/doc/index.html

Why you might ask? Honestly just to see if any of them seem like a fun hobby language or if any of them really spark joy. So far my favorite is Rust.

# Haskell

Fun once you learn the concepts. Very satisfying code to write. Very hard to learn (as in a huge up front cost)

Pros:
- Really cool type system
- Love how everything is a function
- Seems very elegant
- Hoogle is soooo cool!

Neutral:
- Finding "how do I do this in Haskell" is kind of hard

Cons:
- Very different to the style of programming that I'm used to
- Slow to compile
- Build story was challenging. Stack seems to download A LOT of things and cabal is just very foreign

# OCaml

Fun and pretty easy to get going. Much easier than Haskell just to get going. May try to make a project on this one to get used to thinking in functional terms and then move to Haskell.

Pros:
- Somewhat easier to understand than Haskell (despite being very similar. Probably fewer special symbols used)
- Docs are great. Website is great
- Pretty easy to find "how do I do this"

Neutral:
- Build & package management present and works. No other opinion beyond that

Cons:
- Single pass compiler so there's an order to declarations (not the worst thing)
- C-style printf (kind of annoying to print out lists. Probably a way to deal with this that I just don't know about)

# Nim

Also fun and easy to get going. Would be interested to try to make a project with it

Pros:
- Familiar enough that it's easy to get started
- Can do functional style computation even if it looks like the docs are geared towards OOP folks
- Test syntax is nice
- Feels like a scripting language. Haven't tried type inference though

Cons:
- `nimble` segfaults in devenv for some reason
- Compiler errors for macros look pretty terrible
- Compiler errors generally are kind of a miss. Probably would be fine once gotten used to
- Documentation isn't as nice as Haskell or OCaml

# Crystal

Cons:
- No official treesitter grammar (though an unofficial one exists [here](https://github.com/crystal-lang-tools/tree-sitter-crystal))
