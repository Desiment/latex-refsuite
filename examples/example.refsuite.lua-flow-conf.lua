-- Custom configuration file for the Lua refsuite flow.

local CustomConfig = {
  hyperref = {
    enable = true,
    loadtime_opts = {},
    shortref = {
      { csname = 'picref', reftext = 'Fig.' },
      { csname = 'tabref', reftext = 'Table' },
      { csname = 'secref', reftext = 'Section' },
      { csname = 'lstref', reftext = 'Listing' },
    },
    hypersetup = {
      breaklinks = true,
      hyperindex = true,
      colorlinks = true,
      hidelinks = false,
      unicode = true,
      pdfauthor = {'John Doe'},
      pdfsubject = {'Lua RefSuite Package Demonstration'},
      pdfkeywords = {'LaTeX, LuaTeX, bibliography, indexes'},
      pdftitle = {'RefSuite Lua Flow Demonstration'},
      bookmarksopen = true,
      linktocpage = true,
      plainpages = false,
      pdfpagelabels = true,
      urlcolor = 'blue',
      linkcolor = 'red',
      filecolor = 'magenta',
      citecolor = 'green',
    },
  },

  zrefclever = {
    enable = true,
    setup = { lang = 'russian' },
    azcref = true,
  },

  bibtex = {
    enable = true,
    loadtime_opts = { backend = 'biber', style = 'numeric', defernumbers = true },
    path = '.',
    style = 'numeric',
    bibliographies = {
      {
        name = 'main',
        title = 'References',
        files = 'example.refsuite.lua-main.bib',
      },
      {
        name = 'online',
        title = 'Online Resources and Repositories',
        files = 'example.refsuite.lua-online.bib',
      },
    },
  },

  indexes = {
    enable = true,
    loadtime_opts = { 'makeindex', 'noautomatic' },
    list = {
      {
        name = 'notation',
        title = 'List of Notations',
        intoc = true,
        columns = 2,
        columnsep = '20pt',
      },
      {
        name = nil,
        title = 'Subject Index',
        intoc = true,
        columns = 3,
        columnsep = '15pt',
      },
    },
  },
}

return CustomConfig
