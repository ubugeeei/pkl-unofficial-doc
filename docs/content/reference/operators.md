---
title: Operators Reference
section: Reference
description: Expression operators, precedence, narrowing behavior, and implementation notes.
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
| additive | `+`, `-` | numeric addition and string-like supported concatenation |
| comparison | `<`, `<=`, `>`, `>=` | numeric and implemented comparable values |
| equality | `==`, `!=` | value equality for implemented primitives |
| type test | `is`, `as` | narrowing and casts for supported types |
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

The current evaluator supports the core integer arithmetic path used by the
spec scenarios. Duration and DataSize arithmetic are roadmap work.

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

`is` guards participate in union narrowing for the implemented subset.

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
element is absent. Safe access support is parser-visible, with semantic depth
growing alongside nullable work.
