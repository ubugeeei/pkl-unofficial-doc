---
title: Syntax Reference
section: Reference
description: A compact map of Pkl syntax accepted by the parser and implemented semantically.
order: 105
---

# Syntax Reference

The parser accepts a broad Pkl syntax slice, including constructs that are ahead
of evaluator or typechecker support. Treat this page as the compact syntax map;
use Coverage Status for documentation depth.

## Module Forms

```pkl
module app.config

amends "base.pkl"
extends "template.pkl"

import "db.pkl" as db
```

Supported module forms:

- module declarations
- `amends` and `extends`
- import declarations with aliases
- top-level properties
- module-level `local` bindings
- class declarations
- function declarations
- typealias declarations

## Literals and Values

```pkl
name = "api"
count = 3
enabled = true
missing = null
```

Common string escapes such as `\n`, `\t`, `\r`, `\"`, and `\\` are decoded and
rendered.

## Expressions

Accepted expression families include:

- identifiers and member access
- safe member access
- subscript access
- arithmetic and comparison operators
- boolean operators
- null coalescing
- `is` and `as` type operands
- `if (...) ... else ...`
- object literals
- typed object literals
- listings and mappings
- calls and lambdas
- `import("...")`
- non-null assertions
- object amendments

## Object Bodies

```pkl
server {
  host = "localhost"
  port = 8080
}
```

The object-body shorthand is accepted for module and object members. More
advanced object-body generators such as `for` and `when` are roadmap work for
evaluation.

## Callable Syntax

```pkl
function add(x: Int, y: Int): Int = x + y
inc = (x: Int): Int -> x + 1
```

Modifier-qualified function declarations such as `const function` parse as
function declarations in the implemented subset.

## Type Syntax

```pkl
name: String = "api"
maybeName: String? = null
ports: Listing<Int> = new Listing { 8080 }
value: String | Int = "api"
```

Type text is preserved in annotations and then interpreted by the typechecker
for the supported subset.
