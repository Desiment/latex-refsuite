---
name: refsuite-00-loading
description: Load refsuite and choose the correct configuration path for references, bibliographies, and indexes.
license: MIT
compatibility: opencode
metadata:
  package: refsuite
  topic: loading
---

# refsuite: Loading

## When To Use

Use `refsuite` for centralized reference setup: `hyperref`, generated short
reference commands, grouped bibliographies, indexes, `zref-clever`, and the
Lua-assisted Russian `\azcref` helper.

## Required Setup

```latex
\usepackage{refsuite}
```

Then apply exactly one configuration command in the preamble:

```latex
\DefaultReferencesConfiguration
```

or:

```latex
\SetReferencesConfiguration{...}
```

or under LuaLaTeX:

```latex
\LoadLuaReferencesConfiguration{config.lua}
```

## Public Configuration Commands

### `\DefaultReferencesConfiguration`

Applies built-in defaults: `hyperref` enabled and default short references.

### `\SetReferencesConfiguration{<keys>}`

Applies TeX-side expl3 key configuration.

### `\LoadLuaReferencesConfiguration{<file>}`

Loads a Lua table and lets `refsuite.code.lua` emit equivalent TeX setup. This
requires LuaLaTeX.

## One-Shot Rule

Configuration is one-shot. Do not call more than one configuration command in a
document. Reconfiguration is rejected because package loading and generated
commands must remain deterministic.

## Rules

- Configure `refsuite` in the preamble.
- Use TeX configuration for full key-value control from LaTeX.
- Use Lua configuration when setup should live in a Lua table or be generated externally.
- Use LuaLaTeX for Lua configuration and `\azcref`.

## Avoid

```latex
\DefaultReferencesConfiguration
\SetReferencesConfiguration{hyperref = true}
```

Use only one configuration flow.
