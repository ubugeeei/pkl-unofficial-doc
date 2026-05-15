---
title: Types and Constraints
section: Learn
description: Primitive annotations, nullable values, unions, classes, callables, and numeric predicates.
order: 50
---

# Types and Constraints

Pkl annotations make configuration safer to edit. This implementation supports a
large part of the type-and-constraint path, but the support is intentionally
called out so readers can tell what is language model and what is port maturity.

## Primitive Annotations

```pkl
name: String = "api"
port: Int = 8080
enabled: Boolean = true
```

The typechecker rejects values that do not match the declared type.

## Nullable Types

Append `?` to allow `null`.

```pkl
description: String? = null
```

Null guards and non-null assertions are understood by the typechecker for the
implemented subset.

```pkl
function label(x: String?): String =
  if (x != null) x else "none"
```

## Collection Types

```pkl
ports: Listing<Int> = new Listing {
  8080
  9000
}
labels: Mapping<String, String> = new Mapping {
  ["api"] = "public"
}
```

The implementation checks element types for explicit `Listing` and `Mapping`
values. Constraint propagation inside collection element annotations is still a
roadmap item.

## Union Types

```pkl
value: String | Int = "8080"
```

`is` guards narrow unions in conditionals:

```pkl
function asPort(x: String | Int): Int =
  if (x is Int) x else 0
```

## Type Aliases

```pkl
typealias Port = Int(isBetween(1, 65535))
port: Port = 8080
```

Simple type aliases flow through value annotations, object members, callable
returns, and parts of the callable constraint path.

## Classes

Classes describe object contracts.

```pkl
class Service {
  name: String
  port: Int = 8080
}
service: Service = new {
  name = "api"
}
```

Pkl supports class properties, defaults, typed object construction, inheritance,
and method declarations / invocations. Use the official reference for the full
generic class model.

## Callables

Functions and lambdas can carry parameter and return annotations.

```pkl
function add(x: Int, y: Int): Int = x + y
inc = (x: Int): Int -> x + 1
```

Runtime validation applies at function/lambda returns and class method returns
when annotations require it.

## Numeric Constraints

Supported numeric predicates include:

| Predicate | Example |
| --- | --- |
| `isBetween` | `Int(isBetween(1, 65535))` |
| `isPositive` | `Int(isPositive)` |
| `isGreaterThan` | `Int(isGreaterThan(0))` |
| `isLessThan` | `Int(isLessThan(10))` |
| negation | `Int(!isPositive)` |

Multiple numeric constraints can be listed in one annotation.

```pkl
replicas: Int(isPositive, isLessThan(10)) = 3
```

User-defined numeric predicate factories are supported for plain and
modifier-qualified function declarations.

```pkl
const function above(n) = (x) -> x > n
replicas: Int(above(0)) = 3
```

String, Float, Regex, and collection-element constraints are Pkl concepts that
deserve dedicated examples as this site grows.
