---
title: Functions and Control Flow
section: Learn
description: Conditionals, operators, function declarations, lambdas, calls, and callable values.
order: 45
---

# Functions and Control Flow

Pkl expressions are used to derive configuration values. Keep functions small:
they should explain a rule or normalize a value, not hide a second program
inside the configuration.

## Conditionals

`if` expressions choose between values.

```pkl
environment = "prod"
replicas = if (environment == "prod") 4 else 1
```

Both branches should produce values that satisfy the surrounding annotation.

```pkl
port: Int =
  if (environment == "prod") 443 else 8080
```

## Boolean and Comparison Operators

Use comparisons for validation-like derived values and booleans for feature
flags.

```pkl
port = 8080
isPublic = port == 443 || port == 80
isEphemeral = port > 49152
```

The implementation supports arithmetic, comparison, boolean, coalescing, `is`,
and unary operators in the core expression path.

## Null Handling

Nullable annotations allow absence while keeping non-null values typed.

```pkl
label: String? = null
displayName =
  if (label != null) label else "unnamed"
```

Use a null guard when the expression needs a definite value. The typechecker
understands the implemented null guard path.

## Function Declarations

Function declarations name reusable rules.

```pkl
function clampPort(port: Int): Int =
  if (port < 1) 1 else if (port > 65535) 65535 else port
port = clampPort(9000)
```

Parameter and return annotations are checked for the implemented primitive,
union, alias, callable, and numeric constraint subset.

## Lambdas

Lambdas are anonymous callable values.

```pkl
above = (n: Int): (Int) -> Boolean -> (x) -> x > n
```

Prefer declarations for shared rules. Prefer lambdas when the function is local
to a constraint or a small transformation.

## Callable Values

Callable values can be stored and passed around in the implemented runtime.

```pkl
function checkPort(p: Int(isBetween(1, 65535))): Int = p
selected = checkPort
port = selected(8080)
```

The evaluator preserves lexical captures for scalar, object, and callable
bindings in the current callable slice.

## Control Flow Discipline

When a rule becomes hard to read:

- move repeated predicates into named functions
- keep environment selection at the module edge
- keep validation in annotations when possible
- avoid mixing output formatting with business rules

This keeps Pkl modules inspectable as configuration, not opaque code.
