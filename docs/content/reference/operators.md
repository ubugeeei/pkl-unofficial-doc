---
title: Operators Reference
section: Reference
description: Expression operators, precedence, narrowing behavior, and readable conditions.
order: 107
---

# Operators Reference

Operators are expression syntax. They should stay readable because Pkl modules
are configuration first.

## Precedence Ladder

From tightest to loosest:

| Level | Shape | Notes |
| --- | --- | --- |
| access | `a.b`, `a?.b`, `a[i]`, `f(x)` | member, safe access, subscript, call |
| unary | `!x`, `-x` | boolean negation and numeric negation |
| multiplicative | `*`, `/`, `%` | numeric expressions |
| additive | `+`, `-` | numeric addition and string-like concatenation |
| comparison | `<`, `<=`, `>`, `>=` | comparable values |
| equality | `==`, `!=` | value equality |
| type test | `is`, `as` | narrowing and casts |
| boolean and | `&&` | conjunction |
| boolean or | `||` | disjunction |
| coalescing | `??` | fallback for nullable values |
| conditional | `if (...) ... else ...` | explicit branch selection |

Parentheses are recommended whenever a rule is hard to scan.

## Arithmetic

```pkl
workers = 2 + 2
limit = workers * 10
```

Keep arithmetic close to the values it derives. Use named intermediate
properties when units or precedence are not obvious.

## Equality and Comparison

```pkl
isProd = environment == "prod"
tooHigh = port > 65535
```

Comparison operators are used heavily by user-defined numeric predicates.

## Boolean Logic

```pkl
public = enabled && (port == 80 || port == 443)
```

Prefer intermediate properties when boolean expressions grow past one line.

## Type Tests

```pkl
function asPort(x: String | Int): Int =
  if (x is Int) x else 0
```

`is` guards participate in union narrowing and make later expressions easier to
type.

## Null Coalescing

```pkl
name = suppliedName ?? "default"
```

Use this for simple fallback values. Use `if` when the fallback needs more
context.

## Access Operators

```pkl
host = server.host
first = ports[0]
```

Member and subscript access should fail loudly when the expected member or
element is absent. Use safe access when absence is part of the model rather than
an error.
