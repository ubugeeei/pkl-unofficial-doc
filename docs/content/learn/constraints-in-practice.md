---
title: Constraints in Practice
section: Learn
description: Practical patterns for numeric constraints, type aliases, predicate factories, and diagnostics.
order: 65
---

# Constraints in Practice

Constraints are executable documentation. Use them where a wrong value would be
accepted by the base type but rejected by the domain.

## Start with Built-ins

```pkl
port: Int(isBetween(1, 65535)) = 8080
replicas: Int(isPositive) = 3
```

This is more precise than a comment and easier to reuse than an ad hoc check in
every environment file.

## Name Repeated Rules

Use type aliases when the same constrained shape appears repeatedly.

```pkl
typealias Port = Int(isBetween(1, 65535))
http: Port = 8080
admin: Port = 9090
```

Type aliases should preserve the validation meaning of the constrained type so
aliases do not silently erase the contract.

## Predicate Factories

Predicate factories are useful when the threshold is part of the rule.

```pkl
const function above(min) = (x) -> x > min
workers: Int(above(0)) = 4
```

Use predicate factories when the rule is still simple enough to read at the
annotation site.

## Class Property Constraints

Put constraints at the class property when the rule belongs to the object
contract.

```pkl
class Pool {
  size: Int(isBetween(1, 32)) = 4
}
pool = new Pool {}
```

Defaults and overrides should both satisfy the same class rule.

## Callable Boundaries

Use parameter and return annotations when a function is part of the public
contract of a module.

```pkl
function normalize(port: Int(isBetween(1, 65535))): Int(isPositive) = port
```

Parameter and return annotations should fail at the call boundary when the
function is used incorrectly.

## Good Constraint Messages

When a constraint fails, readers should be able to answer:

- which property or call boundary failed
- which value was rejected
- which predicate rejected it
- whether the failure happened during typecheck or evaluation

Diagnostics are still plain messages, but the docs keep constraints close to
the values they protect so failures are easier to localize.

## Boundaries

Numeric constraints are the easiest place to start. Once a package grows, also
document String, Regex, Float, Duration, DataSize, Listing, and Mapping
constraints near the public type aliases or classes that rely on them.
