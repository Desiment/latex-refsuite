---
name: refsuite-30-shortrefs-bib-index
description: Use refsuite short references, bibliography helpers, and index commands in LaTeX documents.
license: MIT
compatibility: opencode
metadata:
  package: refsuite
  topic: shortrefs-bib-index
---

# refsuite: Short References, Bibliographies, And Indexes

## When To Use

Use this skill after configuring `refsuite` to understand the commands generated
from short-reference, bibliography, and index configuration.

## Generated Short Reference Commands

Each short-reference entry maps a command name to printed text:

```latex
shortrefs = {
  picref = Fig.,
  tabref = Table,
  secref = Section
}
```

For each entry, `refsuite` creates two commands:

- Lowercase command: `\<csname>{<label>}`.
- Capitalized command: `\<Capitalized csname>{<label>}`.

Examples:

```latex
\picref{fig:sample}
\Picref{fig:sample}
\tabref{tab:sample}
\Tabref{tab:sample}
\secref{sec:intro}
\Secref{sec:intro}
```

Default short-reference command names from `\DefaultReferencesConfiguration`:

- `\picref`, `\Picref`
- `\tabref`, `\Tabref`
- `\lstref`, `\Lstref`
- `\digref`, `\Digref`
- `\secref`, `\Secref`

## Bibliography Commands

If multiple bibliography groups are configured, `refsuite` assigns group
keywords through a sourcemap and generates printing commands for named groups.

For bibliography group:

```latex
{ name = main, title = References, files = main.bib }
```

Generated command:

```latex
\printbibliographymain
\printbibliographymain[heading=bibintoc]
```

For group name `online`:

```latex
\printbibliographyonline
```

Rules:

- Generated `\printbibliography<name>` commands are created only for named groups when multiple bibliography groups are configured.
- The optional argument is appended to the underlying `\printbibliography` options.
- Use ordinary `\cite{...}` commands from `biblatex` after setup.

## Index Commands

For each named index, `refsuite` creates a print command:

```latex
indexes/list = {
  { name = notation, title = {List of Notations}, intoc }
}
```

Generated command:

```latex
\printindexnotation
```

Use ordinary `imakeidx` indexing commands to populate indexes:

```latex
\index[notation]{$\alpha$} Alpha notation
\index{LaTeX} Typesetting system

\printindexnotation
\printindex
```

Rules:

- Use `\printindex<name>` only for indexes with a `name` key.
- Use ordinary `\printindex` for the default unnamed index.
- Index examples may require MakeIndex through `imakeidx`.

## Collision Behavior

`refsuite` warns and skips generated commands when a command already exists:

- short-reference command collision
- bibliography printing command collision
- index printing command collision

Choose unique `shortrefs`, bibliography group names, and index names.
