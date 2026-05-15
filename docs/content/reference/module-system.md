---
title: Module System Reference
section: Reference
description: Module declarations, imports, amends, extends, source graphs, and package boundaries.
order: 112
---

# Module System Reference

The module system is the boundary between one Pkl source file and the rest of a
configuration graph.

## Module Declaration

```pkl
module app.config
```

A declaration names the module. Tools can use the module name for diagnostics,
package documentation, and generated artifacts.

## Import Declarations

```pkl
import "database.pkl" as db
databaseHost = db.host
```

Relative imports resolve from the importing source path. `pkl:` imports refer to
standard modules.

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

Use `extends` when the relationship is closer to inheritance than environment
specialization.

## Source Graph

The source graph is the set of modules needed to evaluate, test, document, or
package a module.

```pkl
import "base.pkl" as base
name = base.name
```

Tools should track this graph so diagnostics point to the importing module, the
imported module, and the package boundary involved in the failure.

## Built-in Modules

Built-in modules use the `pkl:` URI scheme. They should be treated like public
package APIs: import only the module you need and keep examples explicit.

## Failure Modes

Module diagnostics should distinguish:

- missing source
- cyclic imports
- unsupported `pkl:` module
- imported module parse/typecheck/eval failure
- qualified type resolution failure
