---
title: Import Patterns
section: Learn
description: Practical patterns for source-backed module graphs and cache-aware edits.
order: 60
---

# Import Patterns

This page turns the module model into practical patterns for a docs reader or
tooling author.

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

## Cache Boundary

`AnalysisSession` is the cache boundary. A host tool supplies sources, asks for a
path, and gets typecheck/evaluation results.

```moonbit
let session = @pkl.AnalysisSession::new()
session.set_source("base.pkl", "name = \"api\"")
session.set_source("main.pkl", "import \"base.pkl\" as base\nname = base.name")
let result = session.eval_path("main.pkl")
```

When a source changes, ripple-backed queries recompute affected paths while
preserving unrelated work.

## Cycles and Missing Sources

The session reports unresolved imports and cyclic imports as diagnostics. That
behavior is important for editors: a document can stay open and analyzable even
while a neighboring file is missing or temporarily invalid.

