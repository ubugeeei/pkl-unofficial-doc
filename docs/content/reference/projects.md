---
title: Projects Reference
section: Reference
description: PklProject, dependency resolution, package metadata, local dependencies, and publishing flow.
order: 117
---

# Projects Reference

Projects give the CLI and tools a stable boundary around a directory of modules.

## PklProject

`PklProject` amends `pkl:Project`. It can define evaluator settings,
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

## Dependency Resolution

Project dependencies are gathered from direct and transitive declarations.
Pkl's resolver keeps the newest compatible minor version for each dependency,
then writes deterministic resolution output.

## Package Metadata

| Field | Meaning |
| --- | --- |
| `name` | Display name |
| `baseUri` | Package URI without version |
| `version` | Package version |
| `packageZipUrl` | Download URL for package contents |

## Local Dependencies

Local project dependencies let a monorepo test packages together before
publishing.

```pkl
amends "pkl:Project"
dependencies {
  ["platform"] = import("../platform/PklProject")
}
```

## Publishing Flow

`pkl project package` prepares package artifacts. Uploading package ZIP and
metadata files to an HTTPS location is a hosting step outside the language.
