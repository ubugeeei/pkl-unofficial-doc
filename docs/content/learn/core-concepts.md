---
title: Core Concepts
section: Learn
description: The smallest useful model of the Pkl language.
order: 20
---

# Core Concepts

## Modules

A module is the top-level unit. Top-level properties evaluate to an
object-shaped value, and imports let one module reuse the values exported by
another.

```pkl
module demo
name = "api"
port = 8080
```

## Objects

Objects are named member collections. Member lookup works for both explicit
object literals and module results.

```pkl
bird = new {
  name = "hawk"
}
bird.name
```

## Constraints

Pkl supports constraints as part of typed module design,
including `isBetween`, `isPositive`, `isGreaterThan`, `isLessThan`, negation, and
plain-function predicate factories.

```pkl
const function above(n) = (x) -> x > n
class Service {
  replicas: Int(above(0))
}
```

## Imports

Imports connect modules into a source graph. Keep imported modules small enough
that the relationship is obvious from the importing file.
