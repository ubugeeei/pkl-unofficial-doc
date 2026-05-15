---
title: Advanced Reference
section: Reference
description: Advanced Pkl syntax for library authors and template maintainers.
order: 119
---

# Advanced Reference

Advanced features are useful when authoring reusable templates, package APIs, or
large module families.

## Meaning of `new`

`new` amends a contextual value. With explicit type information, it amends that
type's default value. Without explicit type information, the contextual type
decides what is being amended.

## Let Expressions

`let` introduces a local binding inside an expression. Use it to keep derived
values close to their use site.

## Type Tests and Casts

`is` checks whether a value conforms to a type. Casts should be close to the
boundary where an unknown value becomes known.

## Lists, Sets, Maps, and Regex

The advanced reference distinguishes language-level object collections
(`Listing`, `Mapping`, dynamic objects) from standard-library collection values
such as `List`, `Set`, `Map`, and `Regex`.

## Type Aliases and Annotations

Type aliases name reusable contracts. Annotations attach metadata that tools,
renderers, and documentation generators can inspect.

## Anonymous Functions

Anonymous functions are useful for callbacks, renderer converters, and compact
predicates. Move them into named functions when behavior becomes shared.

## Amending Null Values

Nullable values can be amended when the type context supplies a default. Keep
that behavior explicit in templates because it can surprise readers.

## When Generators

`when` generators conditionally include members inside object bodies.

## For Generators

`for` generators create elements or entries from iterable values. They cannot
create properties.

## Spread Syntax

Spread syntax copies members from an iterable or object into an enclosing
object. Nullable spread uses `...?value`.

## Member Predicates

Member Predicates use `[[...]]` to select members for amendment or replacement.
They are most useful when elements do not have stable keys.

## Receiver Keywords

`this`, `outer`, `super`, and `module` control name lookup across nested objects,
amends chains, classes, and modules.

## Glob Patterns

Glob patterns are used by globbed imports and reads. `*`, `**`, `?`, character
classes, and sub-patterns all affect which modules or resources enter the graph.

## Doc Comments, Name Resolution, and Reserved Names

Doc comments feed documentation tools. Name resolution decides which member or
binding an identifier refers to. Reserved keywords and blank identifiers should
be treated as syntax tools, not ordinary names.
