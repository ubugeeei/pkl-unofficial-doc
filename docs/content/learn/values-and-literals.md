---
title: Values and Literals
section: Learn
description: Comments, scalar values, strings, null, durations, and data sizes.
order: 25
---

# Values and Literals

Pkl starts with ordinary values. Before object modeling or module composition,
make sure scalar syntax is boring in a good way: comments document intent,
numbers stay readable, strings can derive labels, and units keep operational
values explicit.

## Comments

Pkl has line comments, block comments, and doc comments. Use doc comments for
members that should be visible to generated documentation.

```pkl
/// Public port exposed by the service.
port: Int = 8080
// Internal toggle for this deployment.
debug = false
```

## Numbers and Booleans

Integers support decimal, hexadecimal, binary, and octal notation. Underscores
can group digits without changing the value. Floats use decimal notation, and
booleans use `true` and `false`.

```pkl
retries = 3
mask = 0xff
enabled = true
ratio = 0.95
budget = 1_000_000
```

## Strings

Strings support escapes, interpolation, multiline literals, and custom
delimiters. Prefer interpolation when a label depends on another value.

```pkl
service = "api"
label = "\(service)-production"
message = """
service: \(service)
mode: production
"""
```

## Null

`null` is explicit. Add `?` to a type when absence is meaningful, then use
`??`, `?.`, or `!!` intentionally.

```pkl
description: String? = null
summary = description ?? "No description"
summaryLength = description?.length ?? 0
```

## Durations and Data Sizes

Use units instead of encoding operational quantities as plain strings.

```pkl
timeout = 30.s
cacheTtl = 5.min
memory = 512.mb
disk = 20.gb
```

## Reading Order

Read this page before **Types and Constraints**. Values are the surface syntax;
types and constraints explain how those values are accepted, rejected, or
refined.
