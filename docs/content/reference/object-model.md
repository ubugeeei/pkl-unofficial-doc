---
title: Object Model
section: Reference
description: Objects, amendments, late binding, receivers, and member shape in Pkl.
order: 103
---

# Object Model

Pkl objects are more than nested dictionaries. They are amendable values with
properties, elements, entries, type context, and late-bound member lookup.

## Object Members

Object bodies can contain three broad member shapes:

| Member | Shape | Output Role |
| --- | --- | --- |
| Property | `name = value` | named field |
| Element | `"value"` | ordered listing item |
| Entry | `["key"] = value` | mapping entry |

```pkl
service {
  name = "api"
  ports = new Listing {
    8080
    8443
  }
  metadata = new Mapping {
    ["team"] = "platform"
  }
}
```

## Type Context

`new` uses type context when one exists. A typed property, class property, or
amended value can decide what kind of object is being constructed.

```pkl
class Endpoint {
  host: String
  port: Int(isBetween(1, 65535)) = 443
}
endpoint: Endpoint = new {
  host = "api.example.com"
}
```

The body only provides `host`; the class default supplies `port`.

## Amendments

Amendments copy an existing value and replace or add members in a new object.
This is the core shape behind environment overlays and reusable templates.

```pkl
base = new {
  host = "localhost"
  port = 8080
}
production = (base) {
  host = "api.example.com"
}
```

Amendments should stay small. If an overlay replaces most of the base object,
the base contract is probably too broad.

## Late Binding

Late Binding means a member can observe amended values rather than only the
original values present when the base object was written.

```pkl
base = new {
  host = "localhost"
  url = "https://\(host)"
}
production = (base) {
  host = "api.example.com"
}
```

`production.url` resolves through the amended `host`. This is why reusable base
modules can define derived values while overlays only replace the primitive
inputs.

## Receiver Keywords

Receiver keywords make name lookup explicit in nested bodies.

| Receiver | Meaning |
| --- | --- |
| `this` | the current object |
| `outer` | the surrounding object |
| `super` | the value being amended |
| `module` | the module object |

```pkl
service {
  name = "api"
  endpoint {
    path = "/v1"
    url = "https://\(outer.name).example.com\(this.path)"
  }
}
```

Use receivers when a nested object has a member with the same name as an outer
object. Explicit lookup is cheaper for the next reader than guessing.

## `super`

`super` is useful when an amendment wants to derive from the previous value
instead of replacing it completely.

```pkl
base = new {
  retries = 2
}
production = (base) {
  retries = super.retries + 1
}
```

Keep `super` expressions close to the amended member so the inheritance line is
easy to audit.

## Design Rules

- Put required shape in classes.
- Put environment-specific values in amendments.
- Use late-bound derived values for URLs, file names, and labels.
- Use `this`, `outer`, and `super` when a reader might otherwise misread lookup.
- Keep collection elements and mapping entries visually separate from named
  properties.
