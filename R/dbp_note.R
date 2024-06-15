dbp_version <- readLines("DESCRIPTION")

dbp_version <- dbp_version[grepl("Version", dbp_version)]

dbp_version <- substr(dbp_version, 10, nchar(dbp_version))

dbp_note <- paste0(
  "Created with  package \\code{\\href{https://github.com/davidfoord1/dbpkgr}{dbpkgr}} version ",
  dbp_version)


# "#' @section Note:\n",
# "#' ", dbp_note, "\n",
