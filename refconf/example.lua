	--- Tooling for references
ReferencesConfiguration = {
	hyperref = {
	  enable = true,
	  loadtime_opts = {},
	  shortref = {
		{csname = 'picref', reftext = 'рис.'},
		{csname = 'tabref', reftext = 'табл.'},
		{csname = 'lstref', reftext = 'листинг'},
		{csname = 'digref', reftext = 'диаг.'},
		{csname = 'secref', reftext = 'разд.'}
	  },
	  hypersetup = {
		breaklinks=true,
		hyperindex=true,
		colorlinks=true,
		hidelinks=false,
		unicode=true,
		pdfauthor={'Unknown Author'},
		pdfsubject={'Document Subject'},
		pdfkeywords={'keyword1, keyword2'},
		pdftitle={'Document Title'},
		bookmarksopen=false,
		linktocpage=true,
		plainpages=false,
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
        enable = true,
		loadtime_opts = {backend = 'biber'},
        -- Base path for bibliography files
        path = 'assets/references',
        -- Global bibliography style
		style = 'numeric',
        -- List of bibliography databases with display names
        bibliographies = {
            {
                name = 'main',  -- Main literature bibliography
                title = 'Список литературы',  -- Main literature bibliography
                files = 'main.bib',
            },
            {
                name = 'git',  -- Software/online sources
                title = 'Репозитории, трекеры, обсуждения',  -- Software/online sources
                files = { 'repos.bib', 'issues.bib' },
            }
        }
    },
    -- Index generation configuration (imakeidx package)
    indexes = {
        enable = true,
		loadtime_opts = {'makeindex'},
        -- Configure individual indexes
        list = {
			-- Symbol index
            {
			  name = 'notation',
			  title = 'Список обозначений',
			  intoc = true,
			  --columns = 2,
			  --columnsep = '15pt',
			  --columnseprule = true,
			},
			-- Main subject index
            {
			  name = nil,
			  title = 'Предметный указатель',
			  intoc = true,
			}
        }
    }
}

return ReferencesConfiguration
