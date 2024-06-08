create_temp_package_dir <- function(path) {
  if(!dir.exists(path)) {
    dir.create(path, recursive = TRUE)
    dir.create(file.path(path, "R"))
  }

  invisible()
}

create_temp_package_desc <- function(package_name, path) {
  description_path <- file.path(path, "DESCRIPTION")

  description_content <- paste(
    "Package: ", package_name, "\n",
    "Version: 0.1.0\n",
    "Title: Temporary DB Package\n",
    "Description: A package built with dbpkgr as an interface to a database connection.\n",
    "Depends: R (>= 3.5.0)\n",
    sep = ""
  )

  writeLines(description_content, con = description_path)

  invisible()
}

create_temp_package_man <- function(path) {
  roxygen2::roxygenise(path, "rd")
}
