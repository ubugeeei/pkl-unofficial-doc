---
title: Import Patterns
section: Learn
description: Practical patterns for module graphs, templates, imports, and missing sources.
order: 60
---

# Import Patterns

This page turns the module model into practical patterns for readers who need
more than one file.

## Template plus Environment

Use a base file for defaults and an environment file for overrides.

```pkl
// base.pkl
name = "api"
port = 8080
replicas = 1
```

```pkl
// prod.pkl
amends "base.pkl"
replicas = 4
```

The CLI loads the imported source graph before typechecking or evaluation.

## Named Imports

Use named imports when the imported module is a dependency, not a base template.

```pkl
import "database.pkl" as db
service {
  host = db.host
  port = db.port
}
```

## Expression Imports

Use `import("...")` when a module value should be assigned or passed around.

```pkl
database = import("database.pkl")
port = database.port
```

## Import Graphs

Treat imports as a graph of reviewed source files. Keep shared constants,
classes, and templates in small modules, then import them from the modules that
own rendered output.

```pkl
// shared.pkl
defaultPort = 8080
```

```pkl
// service.pkl
import "shared.pkl" as shared
port = shared.defaultPort
```

## Cycles and Missing Sources

Unresolved imports and cyclic imports should be treated as source-graph errors.
Fix the graph first, then debug types or output.
