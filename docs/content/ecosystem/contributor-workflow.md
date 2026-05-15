---
title: Contributor Workflow
section: Contributing
description: How to update Markdown, generated output, and source-alignment notes together.
order: 220
---

# Contributor Workflow

This project is easiest to keep correct when each change updates source notes,
reader-facing copy, and generated output together.

## Change Shape

For a language topic, update in this order:

1. Identify the official source: docs, examples, release notes, or CLI behavior.
2. Update the Learn page if the topic changes a reader workflow.
3. Update the Reference page if exact syntax or semantics changed.
4. Update Compatibility or Coverage Status if the source boundary changed.
5. Regenerate generated outputs.

This keeps docs from becoming a wishlist detached from Pkl behavior.

## Commands

These commands are for maintaining this documentation repo. They are not the Pkl
language installation path.

```bash
moon fmt
moon check --deny-warn --target js
moon test --target js
moon check --deny-warn --target native
moon test --target native
moon info
```

## Documentation Updates

When behavior or wording changes, update at least one page in each affected
area:

- Learn page for the reader workflow
- Reference page for exact syntax or semantics
- Coverage Status for documentation gaps
- Compatibility or Source Alignment when the source boundary changes

## Generated Docs

The static site is checked in under `docs/dist`.

```bash
moon run docsgen/main --target js -- docs/content docs/dist
moon run docsserve/main --target native -- docs/dist 4173
```

Do not edit `docs/dist` by hand. Change Markdown or `docsgen`, then regenerate.

## Commit Hygiene

Keep commits reviewable:

- one concept per commit
- conventional commit messages
- no unrelated formatting churn
- generated files committed with the source change that produced them

The branch should tell a reviewer which contract changed and how the docs follow
that change.
