# refsuite: TeX Configuration Keys

## When To Use

Use `\SetReferencesConfiguration` when reference setup should live directly in
the LaTeX preamble.

## Required Setup

```latex
\usepackage{refsuite}
\SetReferencesConfiguration{<keys>}
```

## Hyperref Keys

- `hyperref = true|false`: enables or disables `hyperref` setup.
- `hyperref/options = {<options>}`: passes load-time options to `hyperref`.
- `hyperref/setup = {<keys>}`: passes keys to `\hypersetup`.
- `hyperref/hypersetup = {<keys>}`: alias for `hyperref/setup`.
- `shortrefs = { <csname> = <text>, ... }`: replaces the short-reference map.
- `shortrefs+ = { <csname> = <text>, ... }`: adds to the short-reference map.

Example:

```latex
\SetReferencesConfiguration{
  hyperref = true,
  hyperref/options = { unicode, hyperindex, pdfpagelabels },
  hyperref/setup = {
    colorlinks,
    linkcolor = red,
    citecolor = blue
  },
  shortrefs = {
    picref = Fig.,
    tabref = Table,
    secref = Section
  }
}
```

## Zref-Clever Keys

All aliases target the same feature group.

- `zref-clever = true|false`
- `zrefclever = true|false`
- `zcref = true|false`
- `zref-clever/options = {<options>}`
- `zrefclever/options = {<options>}`
- `zcref/options = {<options>}`
- `zref-clever/setup = {<keys>}`
- `zrefclever/setup = {<keys>}`
- `zcref/setup = {<keys>}`
- `azcref = true|false`
- `zref-clever/azcref = true|false`
- `zrefclever/azcref = true|false`
- `zcref/azcref = true|false`

Example:

```latex
\SetReferencesConfiguration{
  zref-clever = true,
  zref-clever/setup = { lang = russian },
  azcref = true
}
```

## Bibliography Keys

`biblatex` and `bibtex` are aliases in this package.

- `biblatex = true|false`
- `bibtex = true|false`
- `biblatex/options = {<options>}`
- `bibtex/options = {<options>}`
- `biblatex/loadtime_opts = {<options>}`
- `bibtex/loadtime_opts = {<options>}`
- `biblatex/path = <path>`
- `bibtex/path = <path>`
- `biblatex/style = <style>`
- `bibtex/style = <style>`
- `biblatex/resources = {<files>}`
- `bibtex/resources = {<files>}`
- `biblatex/resource = <file>`
- `bibtex/resource = <file>`
- `biblatex/bibliographies = { {<group>}, ... }`
- `bibtex/bibliographies = { {<group>}, ... }`
- `biblatex/bibliography = {<group>}`
- `bibtex/bibliography = {<group>}`

Bibliography group keys:

- `name = <name>`
- `title = <title>`
- `files = {<files>}`
- `file = <file>`
- `resources = {<files>}`
- `resource = <file>`

Example:

```latex
\SetReferencesConfiguration{
  biblatex = true,
  biblatex/options = { backend = biber, style = numeric, defernumbers = true },
  biblatex/path = .,
  biblatex/bibliographies = {
    { name = main, title = References, files = main.bib },
    { name = online, title = {Online Resources}, files = online.bib }
  }
}
```

## Index Keys

`indexes` and `imakeidx` are aliases in this package.

- `indexes = true|false`
- `imakeidx = true|false`
- `indexes/options = {<options>}`
- `imakeidx/options = {<options>}`
- `indexes/list = { {<index options>}, ... }`
- `imakeidx/list = { {<index options>}, ... }`
- `index = {<index options>}`

Index option lists are passed to `\makeindex` from `imakeidx`. If an index has a
`name`, `refsuite` also creates a generated print command.

Example:

```latex
\SetReferencesConfiguration{
  indexes = true,
  indexes/options = { makeindex, noautomatic },
  indexes/list = {
    { name = notation, title = {List of Notations}, intoc },
    { title = {Subject Index}, intoc }
  }
}
```

## Rules

- Use braces around nested key lists.
- Set `biblatex/path = .` when `.bib` files live beside example sources.
- Use `backend = biber` when using Biber with `biblatex`.
- Use `indexes/options = { makeindex, noautomatic }` when examples should control index generation explicitly.
