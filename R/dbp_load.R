#' Create package based on a database connection
#'
#' @description Creates and loads a package with a number of functions
#' for interacting with a database connection.
#'
#' This function will load the functions from R files created by [dbp_generate()].
#' If the files have not already been generated yet, this funciton will call
#' [dbp_generate()] to create them first.
#'
#' @param connection
#' A database connection object.
#'
#' @param package_name
#' A string to be used as the name of the temp package and the prefix to its
#' functions. Must be a valid package name; lowercase no punctuation recommended.
#'
#' @return
#' Returns `NULL` invisbly.
#' @export
#'
#' @inheritSection dbp_generate {Generated functions}
#'
#' @seealso [dbp_generate()] for generating R files.
#'
#' @examples
#' \dontrun{
#' con <- DBI::dbConnect(RSQLite::SQLite(), ":memory:")
#' DBI::dbWriteTable(con, "mtcars", mtcars)
#'
#' dbp_load(con, "mydb")
#'
#' # Get info about the database
#' mydb_list_tables()
#'
#' # Each table is available as a lazy tbl
#' mydb_mtcars()
#'
#' # And you can query with raw SQL
#' mydb_query("SELECT cyl, COUNT(cyl) AS count FROM mtcars GROUP BY cyl")
#' }
dbp_load <- function(connection, package_name) {
  connection_name <- paste0(package_name, "_connection")

  if (!connection_name %in% names(dbp_env)) {
    dbp_generate(connection, package_name, project_is_package = FALSE)
  }

  path <- dbp_package_path(package_name)

  suppressMessages(roxygen2::roxygenise(path))
}
