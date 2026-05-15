---
title: Module System Reference
section: Reference
description: Module declarations, imports, amends, extends, source graphs, and cache boundaries.
order: 112
---

# Module System Reference

The module system is the boundary between one Pkl source file and the rest of a
configuration graph.

## Module Declaration

```pkl
module app.config
```

A declaration names the module. Pkl preserves module
names for parsing and diagnostics while evaluating the module to its top-level
object value.

## Import Declarations

```pkl
import "database.pkl" as db

databaseHost = db.host
```

Relative imports resolve from the importing source path. `pkl:` imports are
handled by the built-in resolver for the implemented stdlib surface.

## Import Expressions

```pkl
database = import("database.pkl")
host = database.host
```

Import expressions and import declarations share the same source graph. Use
declarations for named dependencies and expression imports when the imported
module value participates in another expression.

## Amends

```pkl
amends "base.pkl"

port = 9000
```

`amends` starts from a parent module value, then applies the child module's
members. It is the primary template specialization mechanism.

## Extends

```pkl
extends "template.pkl"
```

`extends` is parsed and evaluated for the implemented subset. Use it when the
relationship is closer to inheritance than environment specialization.

## Source Graph

Host tools provide source text through `AnalysisSession`.

```moonbit
let session = @pkl.AnalysisSession::new()
session.set_source("main.pkl", "import \"base.pkl\" as base\nbase.name")
let checked = session.typecheck_path("main.pkl")
```

The session is the cache boundary for parse, typecheck, and evaluation queries.
When a source changes, only dependent paths should recompute.

## Built-in Modules

The resolver can synthesize selected `pkl:` modules as MoonBit-owned Pkl source.
This keeps imports uniform: stdlib support grows as source and evaluator support
grow, not as a separate foreign runtime.

## Failure Modes

Module diagnostics should distinguish:

- missing source
- cyclic imports
- unsupported `pkl:` module
- imported module parse/typecheck/eval failure
- qualified type resolution failure
