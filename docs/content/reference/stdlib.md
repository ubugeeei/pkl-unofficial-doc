---
title: Standard Library
section: Reference
description: How to navigate Pkl standard modules, core built-ins, and package documentation.
order: 125
---

# Standard Library

Pkl's standard library is the set of `pkl:` modules and built-in types that make
the language useful beyond raw object literals. This page is a reading map, not
a replacement for exhaustive signatures in the official package docs.

## Reading Map

| Area | Start With | Use For |
| --- | --- | --- |
| Core types | `pkl:base` | strings, numbers, booleans, collections, conversions |
| Math | `pkl:math` | numeric helpers and constants |
| Reflection | `pkl:reflect` | inspecting modules, classes, and values |
| Formats | `pkl:json`, `pkl:yaml`, `pkl:xml` | format-specific helpers and render behavior |
| Testing | `pkl:test` | assertions, examples, and package checks |
| Versions | `pkl:semver` | version parsing and compatibility rules |

## Base Module

`pkl:base` is where primitive values and common collection behavior become
practical. When a method feels like it should exist on `String`, `Int`,
`Listing`, or `Mapping`, look in the base module before writing a helper.

```pkl
name = "api"
labels = new Listing {
  "public"
  "stable"
}
```

Keep examples conservative when teaching the language model. Reach for standard
library methods after the object shape is already clear.

## Format Modules

Format modules matter when output has to line up with another system. Use
**Output Formats** for renderer behavior, then consult the relevant `pkl:`
module when values need format-specific construction or escaping.

## Testing Module

Use `pkl:test` to turn package expectations into executable documentation.

```bash
pkl test tests/*.pkl
```

Tests are especially useful for templates because they show which amendments are
supported and which constraints are intentionally enforced.

## Reflection

Reflection is for tools and package authors. Use it when generating
documentation, checking package contracts, or writing helpers that need to
inspect declarations rather than only evaluate values.

## Versioning

`pkl:semver` belongs near package boundaries. Use semantic version logic when a
package must compare dependency ranges, release channels, or generated artifact
versions.

## Documentation Rule

For this unofficial site:

- teach the language concept in Learn pages
- summarize the module family here
- link to package documentation when exhaustive function signatures matter
- keep runnable examples small enough to evaluate
