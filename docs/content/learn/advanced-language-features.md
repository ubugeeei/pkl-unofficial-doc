---
title: Advanced Language Features
section: Learn
description: Generators, spreads, predicates, receiver keywords, annotations, glob patterns, and name resolution.
order: 69
---

# Advanced Language Features

Advanced Pkl features are mostly for template and library authors. Reach for
them when repeated object structure becomes harder to maintain than the feature
itself.

## Generators

`for` generators create elements or entries from an iterable. `when` generators
include members conditionally.

```pkl
ports = new Listing {
  for (offset in List(0, 1, 2)) {
    8080 + offset
  }
}
settings {
  when (environment == "prod") {
    replicas = 3
  }
}
```

## Spread Syntax

Spread syntax copies members from an iterable or object into the enclosing
object. Use nullable spread when the source may be absent.

```pkl
defaults {
  timeout = 30.s
}
service {
  ...defaults
  replicas = 2
}
```

## Member Predicates

Member predicates amend matching members in a listing, mapping, or dynamic
object. They are powerful, but they should read like a query rather than a
hidden side effect.

```pkl
containers {
  new { name = "api"; memory = 256.mb }
  new { name = "worker"; memory = 256.mb }
}
tuned = (containers) {
  [[name == "api"]] {
    memory = 512.mb
  }
}
```

## Receiver Keywords

Use `this` for the current receiver, `outer` for the immediately enclosing
object, `super` for the amended parent, and `module` for the module receiver or
module self type. Prefer local names when nested receiver lookup becomes hard
to read.

## Type Tests and Casts

`is`, `as`, and nullable access help narrow values near the point of use. Keep
casts close to the boundary that made the value uncertain.

## Glob Patterns

Glob patterns appear in globbed imports and reads. Keep them specific enough
that a new file cannot silently change the module graph.
