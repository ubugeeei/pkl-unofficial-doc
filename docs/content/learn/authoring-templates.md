---
title: Authoring Templates
section: Learn
description: How to design reusable Pkl templates, environment overlays, and extension points.
order: 35
---

# Authoring Templates

Templates are the point where Pkl starts to feel different from plain data.
Instead of copying a complete configuration per environment, write a base module
that declares the shape and defaults, then use smaller modules to amend it.

## Template Contract

A good template tells readers three things:

- which members are required
- which members have safe defaults
- which members are intended extension points

```pkl
// service.pkl
class Service {
  name: String
  port: Int(isBetween(1, 65535)) = 8080
  replicas: Int(isPositive) = 1
}
service: Service = new Service {
  name = "api"
}
```

The class is the contract. The `service` value is the default instance. A
specialized module can amend the value without restating the whole object.

## Environment Overlays

Use `amends` when the child module is still the same configuration with a
smaller set of differences.

```pkl
// prod.pkl
amends "service.pkl"
service {
  replicas = 4
}
```

The implementation merges module members from the parent, then applies the
child's overrides. This is the same mental model as object amendment, lifted to
the module boundary.

## Library Modules

Use imports when a module is a library rather than a parent template.

```pkl
// ports.pkl
api = 8080
admin = 9090
```

```pkl
import "ports.pkl" as ports
service {
  port = ports.api
}
```

This keeps reusable constants or class declarations separate from the module
that owns the rendered output.

## Extension Points

Prefer explicit nested objects for areas users are expected to change.

```pkl
service {
  name = "api"
  runtime {
    image = "example/api"
    args = new Listing {}
  }
}
```

Then the child module has a stable target:

```pkl
amends "service.pkl"
service {
  runtime {
    args = new Listing {
      "--log-level=debug"
    }
  }
}
```

## Avoid Template Drift

Avoid copying the entire base module into every environment. Once values are
copied, the base template stops being useful and readers must diff files by
hand.

Instead:

- put required shape in a class
- put shared defaults in the base module
- keep environment files small
- use type aliases for repeated constraints
- keep host-tool-specific output concerns out of the template when possible

## Current Implementation Notes

Pkl's core template path includes module `amends`, module
`extends`, object amendments, typed object expressions, class property defaults,
and numeric constraints. Broad stdlib helpers, generators, and non-PCF output
formats are still roadmap work, so examples in this site stay on the supported
subset unless marked otherwise.
