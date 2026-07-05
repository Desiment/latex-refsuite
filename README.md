# refsuite.sty

`refsuite` is a personal LaTeX package for reference-related setup: `hyperref`,
short reference commands, grouped bibliographies, indexes, `zref-clever`, and a
Lua-assisted automatic reference command for Russian case selection.

The package supports two configuration flows:

- TeX-side expl3 keys with `\SetReferencesConfiguration`.
- Lua-side table configuration with `\LoadLuaReferencesConfiguration`.

## Features

- Centralized `hyperref` loading and `\hypersetup` configuration.
- Generated short-reference commands such as `\picref`, `\tabref`, `\secref`,
  and their capitalized forms.
- `biblatex` setup with grouped bibliography resources and generated printing
  commands such as `\printbibliographymain`.
- `imakeidx` setup with named index printing commands such as
  `\printindexnotation`.
- Optional `zref-clever` setup.
- LuaLaTeX-only `\azcref` helper that picks a `zref-clever` case from nearby
  Russian prepositions.

## TeX Configuration

```latex
\usepackage{refsuite}
\SetReferencesConfiguration{
  hyperref = true,
  shortrefs = {
    picref = Fig.,
    tabref = Table,
    secref = Section
  },
  biblatex = true,
  biblatex/options = { backend = biber, style = numeric },
  biblatex/path = .,
  biblatex/bibliographies = {
    { name = main, title = References, files = main.bib }
  },
  indexes = true,
  indexes/list = {
    { name = notation, title = {List of Notations}, intoc }
  }
}
```

## Lua Configuration

```latex
\usepackage{refsuite}
\LoadLuaReferencesConfiguration{lua-flow-conf.lua}
```

Lua configuration is useful when the same reference setup should be generated or
shared outside TeX. It requires LuaLaTeX.

## Examples

Build both examples from the `examples/` directory:

```sh
cd examples
latexmk -r latexmkrc expl3-flow.tex
latexmk -r latexmkrc lua-flow.tex
```

The build writes auxiliary files to `examples/.build/` and final PDFs directly
to `examples/`. The bibliography paths in the examples point at `.` because the
`.bib` files live beside the example sources.

`biblatex` examples require `biber`. Index examples require `makeindex` through
`imakeidx`. Lua examples require LuaLaTeX.

## Repository Layout

```text
refsuite/
├── refsuite.sty
├── code/
│   ├── refsuite.core.code.tex
│   └── refsuite.code.lua
└── examples/
    ├── expl3-flow.tex
    ├── lua-flow.tex
    └── latexmkrc
```

## ToDo

- [ ] More `zref-clever` automation for richer reference names.
- [ ] Export/import workflow for `knowledge`-style references.
- [ ] Knowledge normalizer, possibly backed by external language tooling.
- [ ] Revisit short references after the `zref-clever` feature set stabilizes.
