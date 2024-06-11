#' Environment to record active db packages
dbp_env <- new.env(parent = emptyenv())

#' Initialise and load package based on a database connection.
#'
#' @description
#' [dbp_init()] creates a folder for an R package, writes the DESCRIPTION
#' and .R files, including roxygen comments and function definitions.
#'
#' [dbp_load()] generates help pages and loads the package with
#' [roxygen2::roxygenise()].
#'
#'
#' As the automatically generated
#' documentation is quite limited, [dbp_init()] is exported to generate the
#' files without installing the package. You can then make your own changes
#' to the package like adding more detailed roxygen documentation.
#' Once you're done,
#' you can pass the package name to [dbp_load()] to install and load
#' the package.
#'
#' [dbp_package()] is the easy, one-line way to get a package as the connection
#' interface up and running, which wraps these two functions.
#'
#' @param connection
#' A database connection object.
#'
#' @param package_name
#' A string to be used as the name of the temp package and the prefix to its
#' functions. Must be a valid package name; lowercase no punctuation recommended.
#'
#' @param temp Whether the the package should be detached and deleted at
#' the end of the R session. Set to `FALSE` to allow it to persist.
#'
#' @seealso
#' [dbp_package()] the convenient wrapper for these two functions.
#'
#' [dbp_package_path()] to locate the package files.
#'
#' [dbp_unload()] to remove the loaded package.
#'
#' @return
#' Returns `NULL` invisibly.
#' @export
dbp_init <- function(connection, package_name, temp = TRUE) {
  path <- create_db_package_path(package_name, temp)

  dbp_env[[paste0(package_name, "_path")]] <- path
  dbp_env[[paste0(package_name, "_is_temp")]] <- temp
  dbp_env[[paste0(package_name, "_connection")]] <- connection

  create_db_package_dir(path)
  create_db_package_desc(package_name, path)

  # Generate files in the temp_dir based on the connection
  # Each file should have a function and a roxygen docstring
  create_db_env_code(package_name, connection)
  create_structure_code(package_name)
  create_list_tables_code(package_name)
  create_list_schemas_code(package_name)
  create_query_code(package_name)
  # create_execute_code(package_name, path)

  # A function per table to work with just that table (e.g. in dbplyr pipeline)
  # db_structure <- dbp_get_db_structure(connection)
  # mapply(create_table_funs, db_structure[["TABLE_SCHEMA"]] db_structure[["TABLE_NAME]],)

  invisible()
}

#' @rdname dbp_init
#' @export
dbp_load <- function(package_name) {
  path <- dbp_package_path(package_name)

  roxygen2::roxygenise(path)

  is_temp <- dbp_env[[paste0(package_name, "_is_temp")]]

  if (is_temp) {
    reg.finalizer(dbp_env, onexit = TRUE, function(e) {
      # Called when the dbp_env is unloaded
      # e.g. at the end of an R session
      dbp_unload(package_name)
    })
  }

  invisible()
}

