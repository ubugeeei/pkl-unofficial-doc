---
title: Types and Constraints
section: Learn
description: Primitive annotations, nullable values, unions, classes, callables, and numeric predicates.
order: 50
---

# Types and Constraints

Pkl annotations make configuration safer to edit. Use them to document shape,
catch invalid values, and keep reusable modules honest.

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

Null guards narrow the value at the point where a non-null value is required.

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

Collection annotations make the shape of repeated values explicit.

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

Simple type aliases keep repeated annotations readable across values, object
members, and callable boundaries.

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

User-defined predicate factories keep threshold-dependent rules close to the
domain language.

```pkl
const function above(n) = (x) -> x > n
replicas: Int(above(0)) = 3
```

The same pattern applies to richer String, Float, Regex, Duration, DataSize, and
collection-element constraints.
