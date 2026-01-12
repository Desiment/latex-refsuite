--- Tooling for references
ReferencesConfiguration = {
	hyperref = {
	  enable = true,
	  loadtime_opts = {},
	  shortref = {
		{csname = 'picref', reftext = 'pic.'},
		{csname = 'tabref', reftext = 'tab.'},
		{csname = 'lstref', reftext = 'listing'},
		{csname = 'digref', reftext = 'diag.'},
		{csname = 'secref', reftext = 'sec.'}
	  },
	  hypersetup = {
		breaklinks=true,
		hyperindex=true,
		colorlinks=true,
		unicode=true,
		linktocpage=true,
		pdfpagelabels=true,
		-- Link colors
		urlcolor='blue',
		linkcolor='red',
		filecolor='red',
		citecolor='blue'
	  }
	},
    -- Bibliography sources configuration
    bibtex = {
		-- Disable bibliography
        enable = false,
    },
    -- Index generation configuration (imakeidx package)
    indexes = {
        -- Disable index generation
        enable = false,
    }
}

return ReferencesConfiguration
