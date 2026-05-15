---
title: Collections Reference
section: Reference
description: Listing and Mapping syntax, typing, subscript access, and rendering shape.
order: 108
---

# Collections Reference

Pkl has ordered collections, keyed collections, and object-like member
collections. Keep those shapes separate when designing output.

## Listing

```pkl
ports = new Listing {
  8080
  9090
}
```

Useful behavior:

- explicit `new Listing { ... }`
- ordered element storage
- element type checking for `Listing<T>`
- numeric subscript access
- rendering as ordered output

Common operations to look up in package docs:

- listing methods such as `length`, `map`, `filter`, `fold`, `join`, and
  `reverse`
- constrained element annotations such as `Listing<Int(isPositive)>`
- object-body generators that produce listing elements

## Mapping

```pkl
labels = new Mapping {
  ["api"] = "public"
  ["admin"] = "private"
}
```

Useful behavior:

- explicit `new Mapping { ... }`
- string and scalar keys
- key/value type checking for `Mapping<K, V>`
- subscript access
- rendering as keyed output

Common operations to look up in package docs:

- mapping methods such as `keys`, `values`, `containsKey`, `getOrNull`, and
  `fold`
- constrained value propagation

## Object Members vs Collection Elements

Objects have named members:

```pkl
server {
  host = "localhost"
}
```

Listings have ordered elements, and mappings have keyed entries. Keeping these
separate makes renderer behavior easier to reason about.

## Rendering Shape

PCF output follows Pkl's brace conventions. At the module boundary, object
members render without an enclosing
`new { ... }`. Nested objects render as blocks, and listing/mapping elements use
Pkl-style indentation.

## Type Boundaries

Use **Object Model** when the question is about properties, elements, entries,
or amendments. Use package docs when the question is about method signatures.
