---
title: Modules and Imports
section: Learn
description: How Pkl files compose through declarations, imports, amends, and extends.
order: 30
---

# Modules and Imports

A Pkl file evaluates as a module. The module can declare a name, import other
modules, expose top-level properties, define local helpers, and reuse another
module through `amends` or `extends`.

```pkl
module app.config

import "base.pkl" as base

local defaultPort = 8080

name = base.name
port: Int(isBetween(1, 65535)) = defaultPort
```

## Module Declaration

`module app.config` names the module. Pkl preserves the
module name for parsing and diagnostics; evaluation still returns the module's
object-shaped value.

Use a module declaration when the file is meant to be imported or checked as a
stable contract.

## Imports

Imports bind another module's evaluated exports under an alias.

```pkl
import "database.pkl" as db

url = db.host + ":" + db.port
```

Relative import paths are resolved from the importing file. `AnalysisSession`
stores each source by path and caches parse, typecheck, and evaluation work
against that source graph.

## `import()` Expressions

The expression form is useful when a module value is part of another expression.

```pkl
database = import("database.pkl")
label = database.name
```

Implementation note: both import declarations and `import()` expressions resolve
through the same source graph in the CLI and `AnalysisSession`.

## Amends and Extends

`amends` and `extends` reuse another module as a base object.

```pkl
amends "base.pkl"

port = 9000
```

`amends` is the common configuration-specialization path: start with a template,
override the pieces this module owns, and keep the rest from the base.

`extends` is the other base-module relation. Use **Coverage Status** when a
more advanced inheritance case needs clearer documentation in this site.

## Local Bindings

`local` bindings are available to expressions in the same module but are not part
of rendered output.

```pkl
local host = "127.0.0.1"
address = host + ":8080"
```

Implementation note: module-level `local` bindings are supported. Object-body
`hidden` / `local` rendering distinctions are tracked separately because they
affect every renderer.
