---
title: Standard Library
section: Reference
description: How to approach pkl: modules and core built-ins.
order: 125
---

# Standard Library

Pkl's standard library is large. This page gives a compact reading map and keeps
examples focused on the `pkl:` modules readers are most likely to meet early.

## Common Surfaces

| Area | Use |
| --- | --- |
| `pkl:base` | core values, collection behavior, and methods available by default |
| `pkl:math` | numeric constants and math helpers |
| `pkl:test` | test modules and assertions |
| `pkl:reflect` | reflection-oriented helpers |
| renderer modules | JSON, YAML, XML, and adjacent output integrations |

## `pkl:math`

Import `pkl:math` when a module needs named numeric helpers or constants.

```pkl
import "pkl:math" as math

max = math.maxInt32
```

## `pkl:test`

Use `pkl:test` for test modules and assertion-oriented workflows. Keep tests
near examples when documenting validation-heavy config.

## Base Methods

The base module is where readers will meet common value and collection methods:

| Area | Examples |
| --- | --- |
| Listing | `length`, `map`, `filter`, `fold`, `join`, `reverse` |
| Mapping | `keys`, `values`, `containsKey`, `getOrNull` |
| String | `length`, `split`, `replaceAll`, `contains`, `startsWith` |
| Int / Float | `abs`, `toString`, `toFloat`, numeric projections |

When a method-heavy example matters, link to the official stdlib reference for
the exhaustive contract.

## I/O Built-ins

`read`, `read?`, `trace`, and `throw` are important because they cross from pure
configuration into host interaction and diagnostics. Explain the policy impact
before using them in a Learn page.

## Data Types

Regex, Duration, DataSize, and Bytes deserve examples that show both literal
syntax and conversion behavior. Add those examples when this site grows beyond
the compact guide.
