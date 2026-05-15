---
title: Values Reference
section: Reference
description: Scalar value syntax, comments, strings, null handling, Duration, and DataSize.
order: 104
---

# Values Reference

This page is a compact checklist for value-level syntax.

## Comments

| Form | Use |
| --- | --- |
| `//` | Line comment |
| `/* ... */` | Nestable block comment |
| `///` | Doc comment for generated documentation |

## Numbers

| Surface | Notes |
| --- | --- |
| `Int` | 64-bit signed integer |
| `Float` | 64-bit double-precision value |
| `0xff`, `0b1010`, `0o755` | Hex, binary, and octal integer literals |
| `1_000_000` | Underscores improve readability |
| `NaN`, `Infinity` | Standard-library float values |

## Booleans

Boolean values are `true` and `false`. Core operators are `!`, `&&`, and `||`;
the standard library also exposes Boolean methods such as `xor` and `implies`.

## Strings

Strings are Unicode text. They support escapes, interpolation with `\(expr)`,
multiline string literals, and custom delimiters for backslash-heavy text.

```pkl
name = "api"
label = "\(name)-prod"
pattern = #"\d+\.\d+"#
```

## Null Values

`null` is not implicit for every type. Use `?` for nullable annotations, `??`
for defaults, `?.` for null-safe access, and `!!` only when failure is the right
result.

## Durations

`Duration` combines a numeric value with a unit. Common units include `ns`,
`us`, `ms`, `s`, `min`, `h`, and `d`.

```pkl
timeout = 30.s
retryAfter = 250.ms
retention = 7.d
```

## DataSize

`DataSize` combines a numeric value with a byte unit. Use it for memory, disk,
and transfer budgets instead of plain strings.

```pkl
memory = 512.mb
disk = 20.gb
```
