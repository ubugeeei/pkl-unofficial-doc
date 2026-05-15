---
title: Objects and Collections
section: Learn
description: Object bodies, member lookup, listings, mappings, amendments, and PCF shape.
order: 40
---

# Objects and Collections

Pkl is easiest to read as structured data plus rules for deriving that data.
Objects are the center of that model.

```pkl
service = new {
  name = "api"
  port = 8080
}

label = service.name
```

## Object Members

Object members are named values. A module's top-level properties form the module
object, and nested `new { ... }` expressions form object values inside that
module.

```pkl
server {
  host = "localhost"
  port = 8080
}
```

The object-body shorthand above is equivalent to assigning an object value to
`server`. It is the idiomatic shape for configuration trees.

## Member Lookup

Member lookup uses dot access:

```pkl
server {
  host = "localhost"
}

hostname = server.host
```

Pkl's type model tracks object members enough to reject missing fields in
the implemented subset.

## Object Amendments

An amendment starts with a base object and overrides or adds members.

```pkl
base = new {
  name = "api"
  port = 8080
}

dev = (base) {
  port = 9000
  debug = true
}
```

Use amendments when a configuration has a known base shape but needs a small
environment-specific delta.

## Listings

Listings are ordered collections.

```pkl
tags = new Listing {
  "moonbit"
  "pkl"
}

first = tags[0]
```

Current implementation status: explicit `new Listing { ... }` values and
subscript access are supported. Broad `pkl:base` collection methods such as
`map`, `filter`, `fold`, and `join` are roadmap work.

## Mappings

Mappings are key/value collections.

```pkl
ports = new Mapping {
  ["api"] = 8080
  ["admin"] = 9000
}

apiPort = ports["api"]
```

Current implementation status: explicit `new Mapping { [key] = value }` values
and subscript access are supported. Mapping methods such as `keys`, `values`,
`containsKey`, and `getOrNull` are not complete yet.

## Rendering Shape

The current renderer emits PCF-style output. Module objects render without an
outer `new { ... }` wrapper; nested objects render as blocks.

```pkl
name = "api"
server {
  port = 8080
}
```

JSON, YAML, plist, and Java properties output are tracked as renderer roadmap
items.
