create_db_package_dir <- function(path) {
  if(!dir.exists(path)) {
    dir.create(path, recursive = TRUE)
    dir.create(file.path(path, "R"))
  }

  invisible()
}

create_db_package_desc <- function(package_name, path) {
  description_path <- file.path(path, "DESCRIPTION")

  description_content <- paste(
    "Package: ", package_name, "\n",
    "Version: 0.1.0\n",
    "Title: Temporary DB Package\n",
    "Description: A package built with dbpkgr as an interface to a database connection.\n",
    "Encoding: UTF-8\n",
    "Depends: R (>= 3.5.0)\n",
    sep = ""
  )

  writeLines(description_content, con = description_path)

  invisible()
}

create_db_package_path <- function(package_name, temporary) {
  if (temporary) {
    file.path(tempdir(), package_name)
  } else {
    file.path("dkpkgr", package_name)
  }
}

#' Uninstall and delete a dbpkgr db package
#'
#' @param package_name The name of the package to be deleted.
#' @param path The path to the package files.
#'
#' @return
#' Returns `NULL` invisibly.
remove_db_package <- function(package_name) {
  path <- dbp_package_path(package_name)

  tryCatch({
    detach(paste0("package:", package_name), unload = TRUE, character.only = TRUE)
  }, error = function(e) {
    message(paste0("Package not loaded package:", package_name, " - ", e$message))
  })

  if (dir.exists(path)) {
    unlink(path, recursive = TRUE, force = TRUE)
  }

  invisible()
}
