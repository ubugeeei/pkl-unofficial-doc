---
title: Contributor Workflow
section: Ecosystem
description: How to update Markdown, generated HTML, source links, and coverage notes together.
order: 220
---

# Contributor Workflow

This site is easiest to keep good when each change updates prose, source links,
generated HTML, and coverage notes together.

## Change Shape

For a documentation change, update in this order:

1. Decide the reader job: learn, reference, language rule, or ecosystem surface.
2. Check the official source when behavior or tool details can change.
3. Add or update the Markdown page.
4. Update Coverage Status if the change closes or reveals a gap.
5. Regenerate `docs/dist`.
6. Verify the local site in a browser.

This keeps docs from becoming a wishlist detached from actual reader needs.

## Commands

The static site generator is written in MoonBit. These commands are for site
contributors, not for installing or using Pkl.

```bash
moon fmt
moon check --deny-warn --target js
moon test --target js
moon info
moon run docsgen/main --target js -- docs/content docs/dist
```

In the standalone repository, use the wrapped commands:

```bash
pnpm check
pnpm build
```

## Documentation Updates

When behavior changes, update at least one page in each affected area:

- Learn page for the reader workflow
- Reference page for exact syntax, CLI usage, API surface, or semantics
- Ecosystem page for editor support, Pkldoc, package docs, or source alignment
- Coverage Status for known gaps and follow-up work

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

The branch should tell a reviewer which reader job changed and how the generated
site follows that change.
