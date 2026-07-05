# refsuite: zref-clever And azcref

## When To Use

Use `zref-clever` integration for semantic references. Use `\azcref` when writing
Russian text under LuaLaTeX and the grammatical case should be inferred from
nearby prepositions.

## Required Setup

TeX configuration:

```latex
\usepackage{refsuite}
\SetReferencesConfiguration{
  zref-clever = true,
  zref-clever/setup = { lang = russian },
  azcref = true
}
```

Lua configuration:

```latex
\usepackage{refsuite}
\LoadLuaReferencesConfiguration{lua-flow-conf.lua}
```

with:

```lua
zrefclever = {
  enable = true,
  setup = { lang = 'russian' },
  azcref = true,
}
```

## Commands

### `\azcref{<zref label>}`

Lua-assisted wrapper around `\zcref`. It inspects nearby previous words and, if a
known Russian preposition is found, emits `\zcref[d=<case>]{<label>}`.

```latex
\begin{theorem}\zlabel{thm:auto-case}
Тестовое утверждение.
\end{theorem}

Без предлога: \azcref{thm:auto-case}.
по \azcref{thm:auto-case}.
к \azcref{thm:auto-case}.
в силу \azcref{thm:auto-case}.
из-за \azcref{thm:auto-case}.
```

## Built-In Preposition Cases

The Lua helper currently recognizes:

- `по` -> dative (`d`)
- `к` -> dative (`d`)
- `в силу` -> genitive (`g`)
- `из-за` -> genitive (`g`)
- `как показывает` -> nominative (`n`)

## Extending azcref In Lua

```lua
zrefclever = {
  enable = true,
  setup = { lang = 'russian' },
  azcref = true,
  azcref_config = {
    prepositions = {
      ['согласно'] = 'd',
    },
    max_words = 2,
  },
}
```

## External zref-clever Commands

These are provided by the external `zref-clever` package loaded by `refsuite`:

- `\zlabel{<label>}`
- `\zcref{<label>}`
- `\zcsetup{<keys>}`

## Rules

- `\azcref` requires LuaLaTeX.
- Enable `azcref` only when `zref-clever` references are used.
- Use `\zlabel`, not ordinary `\label`, for labels intended for `\zcref` or `\azcref`.
- Keep the preposition immediately before `\azcref` for automatic case detection.

## Avoid

```latex
по слову \azcref{thm:auto-case}
```

The helper checks nearby previous words, so extra words can prevent the intended
preposition phrase from matching.
