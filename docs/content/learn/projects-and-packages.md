---
title: Projects and Packages
section: Learn
description: Organize modules with PklProject, dependencies, package URIs, and package publishing boundaries.
order: 68
---

# Projects and Packages

A single `.pkl` file is enough for learning, but real configuration usually
needs project settings, dependency boundaries, and packages that can be reused
across repositories.

## PklProject

A project is a directory marked by a `PklProject` file. That file amends
`pkl:Project` and gives the CLI a place to resolve evaluator settings,
dependencies, and package metadata.

```pkl
amends "pkl:Project"
package {
  name = "service-config"
  baseUri = "package://example.com/service-config"
  version = "1.0.0"
  packageZipUrl = "https://example.com/service-config@\(version).zip"
}
```

## Dependencies

Dependencies are named so modules can import package content without hardcoding
every source location.

```pkl
amends "pkl:Project"
dependencies {
  ["platform"] = import("../platform/PklProject")
}
```

## Package Imports

After a dependency is resolved, modules import it through dependency notation or
`package://` URIs.

```pkl
import "@platform/templates/Service.pkl"
```

## Publishing Boundary

Packaging prepares artifacts; hosting those artifacts is a separate concern.
Keep examples clear about which step belongs to Pkl and which step belongs to
your registry, HTTP server, or CI pipeline.

## When to Introduce a Project

Add `PklProject` when you need shared evaluator settings, package dependencies,
local package testing, or published reusable modules. Keep standalone modules
standalone until those pressures appear.
