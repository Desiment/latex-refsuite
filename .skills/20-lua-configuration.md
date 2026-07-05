# refsuite: Lua Configuration

## When To Use

Use Lua configuration when reference setup should live in a Lua table, be shared
with external tooling, or generate TeX setup programmatically.

## Required Setup

Compile with LuaLaTeX.

```latex
\usepackage{refsuite}
\LoadLuaReferencesConfiguration{lua-flow-conf.lua}
```

## Lua Table Shape

Return a table from the configuration file:

```lua
return {
  hyperref = { ... },
  zrefclever = { ... },
  bibtex = { ... },
  indexes = { ... },
}
```

## Hyperref Configuration

Supported fields:

- `enable`: boolean.
- `loadtime_opts`: table of load-time options.
- `shortref`: list of `{ csname = ..., reftext = ... }` records.
- `hypersetup`: accepted by the table shape, but current Lua setup primarily emits load-time options and short-reference commands. Use TeX configuration for full `\hypersetup` behavior.

Example:

```lua
hyperref = {
  enable = true,
  loadtime_opts = {},
  shortref = {
    { csname = 'picref', reftext = 'Fig.' },
    { csname = 'tabref', reftext = 'Table' },
  },
}
```

## Zref-Clever Configuration

Supported fields:

- `enable`: boolean.
- `loadtime_opts` or `options`: load-time options.
- `setup`: keys passed to `\zcsetup`.
- `azcref`: boolean.
- `azcref_config`: optional table for automatic case detection.

`azcref_config` fields:

- `prepositions`: map from preceding phrase to zref-clever declension code.
- `max_words`: number of previous words to inspect.

Example:

```lua
zrefclever = {
  enable = true,
  setup = { lang = 'russian' },
  azcref = true,
  azcref_config = {
    prepositions = { ['согласно'] = 'd' },
    max_words = 2,
  },
}
```

## Bibliography Configuration

The Lua flow uses `bibtex` as the table key while loading `biblatex` in TeX.

Supported fields:

- `enable`: boolean.
- `loadtime_opts`: table passed to `biblatex` as load-time options.
- `path`: resource path prefix.
- `style`: accepted by the table shape; include style in `loadtime_opts` for loading behavior.
- `bibliographies`: list of bibliography groups.

Bibliography group fields:

- `name`
- `title`
- `files`: string or table of strings.

Example:

```lua
bibtex = {
  enable = true,
  loadtime_opts = { backend = 'biber', style = 'numeric', defernumbers = true },
  path = '.',
  bibliographies = {
    { name = 'main', title = 'References', files = 'main.bib' },
    { name = 'online', title = 'Online Resources', files = 'online.bib' },
  },
}
```

## Index Configuration

Supported fields:

- `enable`: boolean.
- `loadtime_opts`: options passed to `imakeidx`.
- `list`: list of index option tables.

Index table fields are emitted as `\makeindex[...]` options. Common fields:

- `name`
- `title`
- `intoc`
- `columns`
- `columnsep`

Example:

```lua
indexes = {
  enable = true,
  loadtime_opts = { 'makeindex', 'noautomatic' },
  list = {
    { name = 'notation', title = 'List of Notations', intoc = true },
    { name = nil, title = 'Subject Index', intoc = true },
  },
}
```

## Rules

- Compile Lua configuration with LuaLaTeX.
- Put Lua config files where the build can find them through `LUAINPUTS` or the examples directory.
- Use strings for TeX file names and titles unless a boolean or number is intended.
- Use TeX configuration if you need fully explicit `\hypersetup` handling.
