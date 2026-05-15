---
title: Classes and Methods
section: Learn
description: Class contracts, defaults, typed objects, inheritance, methods, and current support.
order: 55
---

# Classes and Methods

Classes are contracts for objects. They are the strongest way to make reusable
configuration safe because they put shape, defaults, and validation in one
place.

## Class Properties

```pkl
class Server {
  host: String
  port: Int(isBetween(1, 65535)) = 8080
}
```

A property without a default must be supplied by the object. A property with a
default can be omitted by a typed object expression.

## Typed Objects

```pkl
server: Server = new Server {
  host = "localhost"
}
```

The implementation checks supplied members against the class contract and
materializes class defaults during evaluation for the implemented subset.

## Defaults as Documentation

Defaults should be boring and production-safe.

```pkl
class Retry {
  attempts: Int(isBetween(1, 10)) = 3
  backoffMs: Int(isPositive) = 250
}
```

If a default is surprising, omit it and force each caller to choose.

## Inheritance

Use inheritance for a stable family of object contracts.

```pkl
class Endpoint {
  host: String
}

class HttpEndpoint extends Endpoint {
  port: Int(isBetween(1, 65535)) = 80
}
```

Pkl merges inherited property contracts and defaults through the class model. Use
the official reference for exhaustive behavior around generic classes and
external class integration.

## Methods

Methods attach behavior to a class contract.

```pkl
class Service {
  name: String

  function label(prefix: String): String = prefix + "-" + name
}

service = new Service {
  name = "api"
}

label = service.label("prod")
```

Method declarations are kept separate from object value members. Method calls
bind the receiver and arguments at the call boundary.

## Imported Contracts

Imported modules can carry class declarations. Use qualified names when a
contract lives in another module.

```pkl
import "library.pkl" as library

person: library.Person = new library.Person {
  name = "Ada"
}
```

This is an important source-graph feature: tools should make every imported
source reachable before checking or evaluating a module.

## Current Boundaries

Core model:

- class property annotations and defaults
- typed object checking
- typed object default materialization
- inheritance for property contracts and defaults
- imported class metadata for supported qualified names
- method declarations and calls

Topics that deserve deeper examples:

- generic class parameters
- broader stdlib class integration
- deeper external class semantics
- richer constructor-like patterns
