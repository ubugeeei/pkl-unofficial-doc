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

The implementation preserves constrained typealias metadata for the supported
numeric path so aliases do not silently erase validation.

## Predicate Factories

Predicate factories are useful when the threshold is part of the rule.

```pkl
const function above(min) = (x) -> x > min

workers: Int(above(0)) = 4
```

The current evaluator and typechecker support user-defined numeric predicate
factories in the implemented constrained annotation paths.

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

The implementation checks constrained parameter and return annotations for the
supported numeric predicates.

## Good Constraint Messages

When a constraint fails, readers should be able to answer:

- which property or call boundary failed
- which value was rejected
- which predicate rejected it
- whether the failure happened during typecheck or evaluation

Diagnostics are still plain messages, but the docs keep constraints close to
the values they protect so failures are easier to localize.

## Boundaries

This page starts with numeric constraints because they are easy to read and
common in configuration. Future examples should also cover String length and
Regex predicates, Float predicates, Duration and DataSize rules, and constrained
element types inside Listing and Mapping values.
