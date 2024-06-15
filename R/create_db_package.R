create_db_package_dir <- function(path) {
  if(!dir.exists(path)) {
    dir.create(path, recursive = TRUE)
    dir.create(file.path(path, "R"))
  }

  invisible()
}

create_db_package_desc <- function(package_name, path) {
  description_path <- file.path(path, "DESCRIPTION")

  description_content <- paste0(
    "Package: ", package_name, "\n",
    "Version: 0.1.0\n",
    "Title: Temporary DB Package\n",
    "Description: A package built with dbpkgr as an interface to a database connection.\n",
    "Encoding: UTF-8\n",
    "Depends: R (>= 3.5.0)\n",
    "Imports: dbpkgr, DBI, dbplyr"
  )

  writeLines(description_content, con = description_path)

  invisible()
}

create_db_package_path <- function(package_name, project_is_package) {
  if (project_is_package) {
    getwd()
  } else {
    file.path("dkpkgr", package_name)
  }
}
