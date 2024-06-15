#' Environment to record active db packages
dbp_env <- new.env(parent = emptyenv())

#' Create function code based on a database connection.
#'
#' @description Writes R files for functions intended to create an easy
#'   interface for interacting with a database connection. This can be used
#'   within a database-specific package to quickly generate accessor functions
#'   for the database. By default the files will be written to the R/ directory.
#'
#'   If you primarily want to load the functions for use interactively, but
#'   would like to customise the functions before loading - like
#'   expanding on the basic automatically generated documentation - you can call
#'   [dbp_generate()] with the argument `project_is_package = FALSE` and it will
#'   generate the files under a new folder dkpgr/package_name/. You can later
#'   call [dbp_load()] to load to your library as package from there.
#'
#'   Just using [dbp_load()] is the easy one-liner for having the functions
#'   available interactively.
#'
#' @param connection A database connection object.
#'
#' @param project_is_package A logical indicating whether dbpkgr is being used
#'   to build a database specific package. If `TRUE`, files will be written to
#'   `R/`. Default is `FALSE`, which generates files in a custom
#'   dbpkgr/package_name/, ready to be loaded for interactive use with
#'   [dbp_load()].
#'
#' @section {Generated functions}: The following functions will be created for
#'   the database:
#' \itemize{
#' \item{\code{_structure()}} - get a table of catalog, schema and table names.
#' \item{\code{_list_schemas()}} - get a character vector of schema names.
#' \item{\code{_list_tables()}} - get a character vector of table names.
#' \item{\code{_query()}} - get the results of SQL query on the connection.
#' \item{\code{_execute()}} - execute a SQL statement on the connection.
#' }
#'
#'   As well as functions for each of the tables in the database.
#'
#' @seealso [dbp_package()] the convenient wrapper for these two functions.
#'
#'   [dbp_package_path()] to locate the package files.
#'
#'   [dbp_unload()] to remove the loaded package.
#'
#' @return Returns `NULL` invisibly.
#' @export
#' @examples
#'
#' \dontrun{
#' con <- DBI::dbConnect(RSQLite::SQLite(), ":memory:")
#' DBI::dbWriteTable(con, "mtcars", mtcars)
#'
#' dbp_generate(con, "mydb")
#'
#' devtools::document()
#' }
dbp_generate <- function(connection, package_name, project_is_package = TRUE) {
  # Set up a path for the package
  path <- create_db_package_path(package_name, project_is_package)

  # Store some information about the package outside the package
  dbp_env[[paste0(package_name, "_connection")]] <- connection
  dbp_env[[paste0(package_name, "_path")]] <- path

  if (!project_is_package) {
    # Create the folders path and path/R/
    create_db_package_dir(path)
    # Create the file path/DESCRIPTION
    create_db_package_desc(package_name, path)

    create_db_env_code(package_name, connection)
  }

  # Generate .R files under path/R/
  create_structure_code(package_name)
  create_list_tables_code(package_name)
  create_list_schemas_code(package_name)
  create_query_code(package_name)
  create_execute_code(package_name)
  create_table_function_code(package_name)

  if(project_is_package) {
    cli::cli_alert_info(paste0("Written function code to ", path, "/R/"))
  }

  invisible()
}
