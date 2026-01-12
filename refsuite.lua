-- tooling/lua/references.lua
-- Lua configuration module for reference management in LaTeX
local ReferencesConfigurator = {}
local LuaTable = require('luatableprint')
local function dump(tbl)
   if type(tbl) == 'table' then
      local str = '{ '
      for key, value in pairs(tbl) do
         if type(key) ~= 'number' then key = '"'..tostring(key)..'"' end
         str = str .. '['..key..'] = ' .. dump(value) .. ','
      end
      return str .. '} '
   else
      return tostring(tbl)
   end
end

-- Initialize the configuration module with default values
function ReferencesConfigurator.init()
  ReferencesConfigurator.mode = 'debug'
  ReferencesConfigurator.configuration = require('refconf/defaults.lua')
  ReferencesConfigurator.tex_source_configuration = {}
  return ReferencesConfigurator
end

-- Override default configuration with user-provided configuration table
function ReferencesConfigurator.set_configuration(path_to_table)
  if path_to_table == '' then
	print('\n===========================')
	print('Using default configuration')
	print('===========================\n')
	return ReferencesConfigurator
  end
  ReferencesConfigurator.configuration = require(path_to_table)
  return ReferencesConfigurator
end


-- Retrieve hyperref package options from configuration
function ReferencesConfigurator.get_hyperref_options()
	local configuration = ReferencesConfigurator.configuration
	return LuaTable.printtbl(configuration.hyperref.loadtime_opts)
end

-- Retrieve imakeidx package options from configuration
function ReferencesConfigurator.get_imakeidx_options()
	local configuration = ReferencesConfigurator.configuration
	return LuaTable.printtbl(configuration.indexes.loadtime_opts)
end

-- Retrieve biblatex package options from configuration
function ReferencesConfigurator.get_biblatex_options()
	local configuration = ReferencesConfigurator.configuration
	return LuaTable.printtbl(configuration.bibtex.loadtime_opts)
end


-- Configure hyperref package with custom settings and create reference commands
function ReferencesConfigurator.setuphyperref()
	local hyperconf = ReferencesConfigurator.configuration.hyperref
	if not hyperconf.enable then
	  return
	end

	local csstream = ReferencesConfigurator.tex_source_configuration
	table.insert(csstream, "\\PassOptionsToPackage{" .. ReferencesConfigurator.get_hyperref_options() .."}{hyperref}")
	table.insert(csstream, "\\RequirePackage{hyperref}")
    -- Apply hypersetup configuration to LaTeX document
	local options = LuaTable.printtbl(hyperconf.hypersetup)
	table.insert(csstream, "\\hypersetup{" .. LuaTable.printtbl(options) .. "}")
	table.insert(csstream, "\\hypersetup{" .. LuaTable.printtbl(options) .. "}")

    -- Create short reference commands (e.g., \picref, \Picref)
    local shortref_conf = hyperconf.shortref
    for _, ref_config in ipairs(shortref_conf) do
        local csname = ref_config.csname
        local reftext = ref_config.reftext

        -- Create capitalized version (e.g., \Picref)
        local capitalized_csname = csname:sub(1,1):upper() .. csname:sub(2)
		table.insert(csstream, string.format("\\NewDocumentCommand\\%s{m}{%s~\\ref{#1}}", csname, reftext))
		table.insert(csstream, string.format("\\NewDocumentCommand\\%s{m}{\\MakeUppercase %s~\\ref{#1}}", capitalized_csname, reftext))
    end
	ReferencesConfigurator.tex_source_configurations = csstream
end

-- Configure imakeidx package for multiple index generation
function ReferencesConfigurator.setupimakeidx()
	local indexconf = ReferencesConfigurator.configuration.indexes
	if not indexconf.enable then
	  return
	end

	local csstream = ReferencesConfigurator.tex_source_configuration
	table.insert(csstream, "\\PassOptionsToPackage{" .. ReferencesConfigurator.get_imakeidx_options() .."}{imakeidx}")
	table.insert(csstream, "\\RequirePackage{imakeidx}")
	--- Indexes declaration
    if indexconf.enable then
		for _, index in ipairs(indexconf.list) do
		  local options = LuaTable.printtbl(index)
		  table.insert(csstream, string.format("\\makeindex[%s]", options))
		
		  if index.name ~= nil then	
			  -- Declare command for named index
			  table.insert(csstream, string.format("\\NewDocumentCommand\\printindex%s{}{\\printindex[%s]}", index.name, index.name))
		  end
		end
    end
	ReferencesConfigurator.tex_source_configurations = csstream
end

-- Configure biblatex for multiple bibliographies with source mapping
function ReferencesConfigurator.setupbiblatex()
    local bibconf = ReferencesConfigurator.configuration.bibtex
	if not bibconf.enable then
	  return
	end

	local csstream = ReferencesConfigurator.tex_source_configuration
  	table.insert(csstream, "\\PassOptionsToPackage{" .. ReferencesConfigurator.get_biblatex_options() .."}{biblatex}")
	table.insert(csstream, "\\RequirePackage{biblatex}")
    -- Source mapping for multiple bibliographies (keyword-based filtering)
    if #bibconf.bibliographies > 1 then
		local macro = ''
        macro = macro .. "\\DeclareSourcemap{"
        macro = macro .. "\\maps[datatype=bibtex, overwrite]{"

        for _, bib in ipairs(bibconf.bibliographies) do
            local files = type(bib.files) == "table" and bib.files or {bib.files}
            for _, file in ipairs(files) do
                local keyword = "bib" .. bib.name
				local full_path = bibconf.path .. "/" .. file
                macro = macro .. "\\map{" .. string.format("\\perdatasource{%s}", full_path)
				macro = macro .. "\\step[fieldset=keywords, fieldvalue={, }, appendstrict]"
				macro = macro .. string.format("\\step[fieldset=keywords, fieldvalue=%s, append]}", keyword)
            end
        end
		macro = macro .. "}}"
		table.insert(csstream, macro)
    end

    -- Add bibliography resources to document
    for _, bib in ipairs(bibconf.bibliographies) do
        local files = type(bib.files) == "table" and bib.files or {bib.files}
        for _, file in ipairs(files) do
            local full_path = bibconf.path .. "/" .. file
            table.insert(csstream, string.format("\\addbibresource{%s}", full_path))
        end
    end

    -- Create commands to print individual bibliographies
    if #bibconf.bibliographies > 1 then
        for _, bib in ipairs(bibconf.bibliographies) do
            local keyword = "bib" .. bib.name
			local bibopts = string.format("title={%s}, keyword=%s", bib.title, keyword)
            table.insert(csstream, string.format("\\NewDocumentCommand\\printbibliography%s{o}", bib.name) ..
			  "{\\IfNoValueTF{#1}{\\printbibliography["..bibopts ..
							  "]}{\\printbibliography["..bibopts..", #1]}}")
        end
    end
	ReferencesConfigurator.tex_source_configurations = csstream
end

-- Print configuration in various modes (TeX, debug, stdout)
function ReferencesConfigurator.configure()
  ReferencesConfigurator.setuphyperref()
  ReferencesConfigurator.setupbiblatex()
  ReferencesConfigurator.setupimakeidx()

  local csstream = ReferencesConfigurator.tex_source_configuration
  if ReferencesConfigurator.mode == 'tex' or ReferencesConfigurator.mode == 'debug' then
	tex.sprint(csstream)
  end
  if ReferencesConfigurator.mode == 'stdout' or ReferencesConfigurator.mode == 'debug' then
	-- TODO: add packages and options
	print(dump(csstream))
  end

  if ReferencesConfigurator.mode == 'debug' then
	print(dump(ReferencesConfigurator.configuration))
  end
end


return ReferencesConfigurator
