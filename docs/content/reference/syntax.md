---
title: Syntax Reference
section: Reference
description: A compact map of common Pkl syntax for modules, expressions, objects, and types.
order: 105
---

# Syntax Reference

This is a compact syntax map for reading and authoring Pkl. It is not a full
grammar listing; use the official language reference when exact grammar details
matter.

## Module Forms

```pkl
module app.config
amends "base.pkl"
extends "template.pkl"
import "db.pkl" as db
```

Common module forms:

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

Common string escapes include `\n`, `\t`, `\r`, `\"`, and `\\`.

## Expressions

Common expression families include:

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

Object bodies are the center of Pkl authoring. Use **Object Model** for
amendments, late binding, and receiver keywords.

## Callable Syntax

```pkl
function add(x: Int, y: Int): Int = x + y
inc = (x: Int): Int -> x + 1
```

Move anonymous functions into named declarations once the logic becomes shared.

## Type Syntax

```pkl
name: String = "api"
maybeName: String? = null
ports: Listing<Int> = new Listing { 8080 }
value: String | Int = "api"
```

Type annotations make object contracts visible to readers, editor tools, and
host-language integrations.
