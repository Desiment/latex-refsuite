# Contributing

This package follows the shared suite convention used by `flsuite`, `refsuite`,
and `tssuite`: each package has a small hub file, optional implementation
modules under `code/`, and runnable documentation under `examples/`.

## Layout

```text
refsuite/
├── refsuite.sty
├── code/
│   ├── refsuite.core.code.tex
│   └── refsuite.code.lua
├── examples/
│   ├── expl3-flow.tex
│   ├── lua-flow.tex
│   ├── latexmkrc
│   └── .build/
├── README.md
├── CONTRIBUTING.md
└── LICENSE
```

## Build Examples

Run example builds from the `examples/` directory:

```sh
cd examples
latexmk -r latexmkrc expl3-flow.tex
latexmk -r latexmkrc lua-flow.tex
```

The build convention is:

```perl
$aux_dir = '.build';
$out_dir = '.';
ensure_path('TEXINPUTS', '..//');
ensure_path('LUAINPUTS', './/');
ensure_path('LUAINPUTS', '..//');
```

Auxiliary files belong in `examples/.build/`. Final PDFs belong directly in
`examples/`, not in `.build/` or a package-level `build/` directory.

## Package Structure

- Keep `refsuite.sty` as the hub for engine detection, Lua bridge setup, and
  loading the core implementation.
- Keep TeX-side configuration in `code/refsuite.core.code.tex`.
- Keep Lua-side configuration and `azcref` support in `code/refsuite.code.lua`.
- Keep the expl3 key interface and Lua table interface behavior aligned.
- Document any feature that changes compilation requirements, especially
  `biblatex`/`biber`, `imakeidx`, and LuaLaTeX-only behavior.

## Comments

Comments should explain package structure and non-obvious behavior. Prefer:

- A short file header explaining the module purpose.
- Section dividers for major blocks such as configuration state, key parsing,
  feature application, and public commands.
- Doc comments before public commands and complex internal helpers.
- Short rationale comments for LuaTeX-only behavior and generated commands.

Avoid comments that merely restate the next line of code.

## README And Examples

- Keep `README.md` usable as the first point of reference.
- Keep both examples compilable and explanatory.
- Show both configuration flows: `\SetReferencesConfiguration` and
  `\LoadLuaReferencesConfiguration`.
- If a path is shown in an example, it must match the `examples/` output
  convention.

## Verification

Before considering a change complete, compile the example that covers the edited
feature. If a build cannot be run because a TeX dependency is unavailable, note
the missing dependency in the change summary.
