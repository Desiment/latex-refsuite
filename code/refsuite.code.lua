-- code/refsuite.code.lua

local refsuite = {}

-- Baseline configuration used when the Lua flow is initialized without an
-- external table. The shape mirrors the public TeX key interface closely enough
-- that both flows can document the same concepts.
local default_configuration = {
  hyperref = {
    enable = true,
    loadtime_opts = {},
    shortref = {
      { csname = 'picref', reftext = 'pic.' },
      { csname = 'tabref', reftext = 'tab.' },
      { csname = 'lstref', reftext = 'listing' },
      { csname = 'digref', reftext = 'diag.' },
      { csname = 'secref', reftext = 'sec.' },
    },
    hypersetup = {
      breaklinks = true,
      hyperindex = true,
      colorlinks = true,
      unicode = true,
      linktocpage = true,
      pdfpagelabels = true,
      urlcolor = 'blue',
      linkcolor = 'red',
      filecolor = 'red',
      citecolor = 'blue',
    },
  },
  zrefclever = {
    enable = false,
    loadtime_opts = {},
    setup = {},
    azcref = false,
  },
  bibtex = { enable = false },
  indexes = { enable = false },
}

local glyph_id = node.id('glyph')
local glue_id = node.id('glue')
local kern_id = node.id('kern')

-- Mapping from Russian prepositions to zref-clever declension codes. Users can
-- extend this table through azcref_config in the Lua configuration file.
local azcref_prep_case = {
  ['по'] = 'd',
  ['к'] = 'd',
  ['в силу'] = 'g',
  ['из-за'] = 'g',
  ['как показывает'] = 'n',
}

local azcref_max_words = 2
local azcref_installed = false

-- Walk backward through the current LuaTeX node list and collect the nearest
-- words before \azcref. Glue and kern nodes are skipped so ordinary spaces and
-- font kerning do not break detection.
local function read_previous_words(n)
  local words = {}
  local p = n

  while p and p.id == glue_id do
    p = p.prev
  end

  while p and #words < azcref_max_words do
    while p and p.id == kern_id do
      p = p.prev
    end

    local chars = {}
    while p and (p.id == glyph_id or p.id == kern_id) do
      if p.id == glyph_id then
        table.insert(chars, 1, utf8.char(p.char))
      end
      p = p.prev
    end

    if #chars == 0 then
      break
    end

    table.insert(words, 1, table.concat(chars))

    while p and (p.id == glue_id or p.id == kern_id) do
      p = p.prev
    end
  end

  return words
end

-- Choose a zref-clever case by matching the longest known preposition phrase
-- immediately before \azcref. An empty string means "use zref-clever default".
local function detect_azcref_case()
  local nest = tex.nest[tex.nest.ptr]
  if not nest or not nest.tail then
    return ''
  end

  local words = read_previous_words(nest.tail)
  for k = math.min(azcref_max_words, #words), 1, -1 do
    local start = #words - k + 1
    local chunk = {}

    for i = start, #words do
      chunk[#chunk + 1] = words[i]
    end

    local case = azcref_prep_case[table.concat(chunk, ' ')]
    if case then
      return case
    end
  end

  return ''
end

-- Install or update automatic case-detection settings once per document.
function refsuite.install_azcref(config)
  if azcref_installed then
    return
  end

  config = config or {}
  if type(config.prepositions) == 'table' then
    for phrase, case in pairs(config.prepositions) do
      azcref_prep_case[phrase] = case
    end
  end
  if type(config.max_words) == 'number' then
    azcref_max_words = config.max_words
  end

  azcref_installed = true
end

-- Print the final \zcref call. TeX owns the label syntax; Lua only decides
-- whether an explicit declension option is needed.
function refsuite.azcref(label)
  local case = detect_azcref_case()
  if case == '' then
    tex.sprint('\\zcref{' .. label .. '}')
  else
    tex.sprint('\\zcref[d=' .. case .. ']{' .. label .. '}')
  end
end

-- Convert a Lua table to TeX key-value syntax. Boolean values can be printed as
-- bare keys for package options or explicit key=true pairs when needed.
local function printtbl(luatbl, printbools)
  printbools = printbools or false
  if type(luatbl) ~= 'table' then
    return tostring(luatbl)
  end

  local parts = {}
  for key, value in pairs(luatbl) do
    if type(value) == 'boolean' then
      if printbools then
        table.insert(parts, tostring(key) .. '=' .. tostring(value))
      elseif value then
        table.insert(parts, tostring(key))
      end
    elseif type(value) == 'table' then
      local nested = '{' .. printtbl(value, printbools) .. '}'
      if type(key) == 'number' then
        table.insert(parts, nested)
      else
        table.insert(parts, tostring(key) .. '=' .. nested)
      end
    elseif type(key) == 'number' then
      table.insert(parts, tostring(value))
    else
      table.insert(parts, tostring(key) .. '=' .. tostring(value))
    end
  end
  return table.concat(parts, ',')
end

-- Resolve configuration files from the common build locations used by the
-- examples, then fall back to kpathsea and Lua's require mechanism.
local function load_configuration(path)
  local candidates = { path, './' .. path, '.build/' .. path, '../examples/' .. path }
  for _, candidate in ipairs(candidates) do
    local loader = loadfile(candidate)
    if loader then
      return loader()
    end
  end

  local found = kpse.find_file(path, 'lua') or kpse.find_file(path)
  if found then
    return assert(loadfile(found))()
  end

  return require(path)
end

-- Create an isolated configuration instance. The emitted TeX setup is buffered
-- in tex_source_configuration and printed only after all feature groups run.
function refsuite.init()
  local instance = {
    configuration = default_configuration,
    tex_source_configuration = {},
  }
  return setmetatable(instance, { __index = refsuite })
end

-- Replace the default configuration with an external Lua table when requested.
function refsuite:set_configuration(path_to_table)
  if path_to_table ~= '' then
    self.configuration = load_configuration(path_to_table)
  end
  return self
end

function refsuite:get_hyperref_options()
  return printtbl(self.configuration.hyperref.loadtime_opts)
end

function refsuite:get_imakeidx_options()
  return printtbl(self.configuration.indexes.loadtime_opts)
end

function refsuite:get_biblatex_options()
  return printtbl(self.configuration.bibtex.loadtime_opts)
end

-- Hyperref setup emits package loading and short-reference commands. Full
-- \hypersetup support remains in the TeX key flow for now.
function refsuite:setuphyperref()
  local hyperconf = self.configuration.hyperref
  if not hyperconf.enable then
    return
  end

  local csstream = self.tex_source_configuration
  local hyperref_options = self:get_hyperref_options()
  if hyperref_options ~= '' then
    table.insert(csstream, '\\PassOptionsToPackage{' .. hyperref_options .. '}{hyperref}')
  end
  table.insert(csstream, '\\RequirePackage{hyperref}')
  -- Hyperref setup remains available through the TeX key interface.

  for _, ref_config in ipairs(hyperconf.shortref) do
    local csname = ref_config.csname
    local reftext = ref_config.reftext
    local capitalized_csname = csname:sub(1, 1):upper() .. csname:sub(2)
    table.insert(csstream, string.format('\\NewDocumentCommand\\%s{m}{%s~\\ref{#1}}', csname, reftext))
    table.insert(csstream, string.format('\\NewDocumentCommand\\%s{m}{\\MakeUppercase{%s}~\\ref{#1}}', capitalized_csname, reftext))
  end
end

-- zref-clever setup is optional. When azcref is requested, Lua installs the
-- detector and emits a TeX command that calls back into this module.
function refsuite:setupzrefclever()
  local zrefconf = self.configuration.zrefclever or self.configuration.zcref
  if not zrefconf then
    return
  end
  if zrefconf.azcref then
    zrefconf.enable = true
  end
  if not zrefconf.enable then
    return
  end

  local csstream = self.tex_source_configuration
  local zrefclever_options = printtbl(zrefconf.loadtime_opts or zrefconf.options or {})
  if zrefclever_options ~= '' then
    table.insert(csstream, '\\PassOptionsToPackage{' .. zrefclever_options .. '}{zref-clever}')
  end
  table.insert(csstream, '\\RequirePackage{zref-clever}')

  local zrefclever_setup = printtbl(zrefconf.setup or {})
  if zrefclever_setup ~= '' then
    table.insert(csstream, '\\zcsetup{' .. zrefclever_setup .. '}')
  end

  if zrefconf.azcref then
    refsuite.install_azcref(zrefconf.azcref_config)
    table.insert(csstream, "\\NewDocumentCommand\\azcref{m}{\\directlua{require('code.refsuite.code').azcref(\"\\luaescapestring{#1}\")}}")
  end
end

-- imakeidx setup creates indexes and generated printing commands for named
-- indexes, matching the TeX-side \printindex<name> convention.
function refsuite:setupimakeidx()
  local indexconf = self.configuration.indexes
  if not indexconf.enable then
    return
  end

  local csstream = self.tex_source_configuration
  local imakeidx_options = self:get_imakeidx_options()
  if imakeidx_options ~= '' then
    table.insert(csstream, '\\PassOptionsToPackage{' .. imakeidx_options .. '}{imakeidx}')
  end
  table.insert(csstream, '\\RequirePackage{imakeidx}')

  for _, index in ipairs(indexconf.list) do
    table.insert(csstream, string.format('\\makeindex[%s]', printtbl(index)))
    if index.name ~= nil then
      table.insert(csstream, string.format('\\NewDocumentCommand\\printindex%s{}{\\printindex[%s]}', index.name, index.name))
    end
  end
end

-- biblatex setup supports grouped bibliographies by adding a keyword sourcemap
-- and generated \printbibliography<name> commands.
function refsuite:setupbiblatex()
  local bibconf = self.configuration.bibtex
  if not bibconf.enable then
    return
  end

  local csstream = self.tex_source_configuration
  local biblatex_options = self:get_biblatex_options()
  if biblatex_options ~= '' then
    table.insert(csstream, '\\PassOptionsToPackage{' .. biblatex_options .. '}{biblatex}')
  end
  table.insert(csstream, '\\RequirePackage{biblatex}')

  if #bibconf.bibliographies > 1 then
    local macro = '\\DeclareSourcemap{\\maps[datatype=bibtex, overwrite]{'
    for _, bib in ipairs(bibconf.bibliographies) do
      local files = type(bib.files) == 'table' and bib.files or { bib.files }
      for _, file in ipairs(files) do
        local keyword = 'bib' .. bib.name
        local full_path = bibconf.path .. '/' .. file
        macro = macro .. '\\map{' .. string.format('\\perdatasource{%s}', full_path)
        macro = macro .. '\\step[fieldset=keywords, fieldvalue={, }, appendstrict]'
        macro = macro .. string.format('\\step[fieldset=keywords, fieldvalue=%s, append]}', keyword)
      end
    end
    macro = macro .. '}}'
    table.insert(csstream, macro)
  end

  for _, bib in ipairs(bibconf.bibliographies) do
    local files = type(bib.files) == 'table' and bib.files or { bib.files }
    for _, file in ipairs(files) do
      table.insert(csstream, string.format('\\addbibresource{%s/%s}', bibconf.path, file))
    end
  end

  if #bibconf.bibliographies > 1 then
    for _, bib in ipairs(bibconf.bibliographies) do
      local keyword = 'bib' .. bib.name
      local bibopts = string.format('title={%s}, keyword=%s', bib.title, keyword)
      table.insert(csstream, string.format('\\NewDocumentCommand\\printbibliography%s{o}', bib.name)
        .. '{\\IfNoValueTF{#1}{\\printbibliography[' .. bibopts
        .. ']}{\\printbibliography[' .. bibopts .. ', #1]}}')
    end
  end
end

-- Emit the buffered TeX setup after every feature group has contributed its
-- package loading, resource declarations, and generated commands.
function refsuite:configure()
  self:setuphyperref()
  self:setupzrefclever()
  self:setupbiblatex()
  self:setupimakeidx()
  for _, line in ipairs(self.tex_source_configuration) do
    tex.sprint(0, line)
    tex.sprint(0, ' ')
  end
end

return refsuite
