---
title: Collections Reference
section: Reference
description: Listing and Mapping syntax, typing, subscript access, rendering shape, and current gaps.
order: 108
---

# Collections Reference

Pkl has ordered collections, keyed collections, and object-like member
collections. This page focuses on the collection values currently documented by
the port.

## Listing

```pkl
ports = new Listing {
  8080
  9090
}
```

Implemented behavior:

- explicit `new Listing { ... }`
- ordered element storage
- element type checking for `Listing<T>`
- numeric subscript access for the supported path
- PCF rendering for top-level and nested listings

Roadmap:

- listing methods such as `length`, `map`, `filter`, `fold`, `join`, and
  `reverse`
- constrained element propagation such as `Listing<Int(isPositive)>`
- object-body generators that produce listing elements

## Mapping

```pkl
labels = new Mapping {
  ["api"] = "public"
  ["admin"] = "private"
}
```

Implemented behavior:

- explicit `new Mapping { ... }`
- string and implemented scalar keys
- key/value type checking for `Mapping<K, V>`
- subscript access for supported key paths
- PCF rendering for nested mapping values

Roadmap:

- mapping methods such as `keys`, `values`, `containsKey`, `getOrNull`, and
  `fold`
- broader key coercion rules
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

PCF output follows Apple Pkl's brace conventions for the implemented value
graph. At the module boundary, object members render without an enclosing
`new { ... }`. Nested objects render as blocks, and listing/mapping elements use
Pkl-style indentation.

## Type Boundaries

The parser can accept more collection-shaped syntax than the evaluator supports.
Use this page together with **Coverage Status** when a collection example
comes from upstream Apple Pkl docs.
