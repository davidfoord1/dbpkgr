#' Get the path for a dbpkgr package
#'
#' @description
#' #' Get the path for a package already created via
#' [dbp_package()] or [dbp_init()]
#'
#' @param package_name The name of the package to locate
#'
#' @return
#' A string path.
#' @export
dbp_package_path <- function(package_name) {
  var_name <- paste0(package_name, "_path")

  if (var_name %in% names(dbp_env)) {
    dbp_env[[var_name]]
  } else {
    stop(
      paste0(
        "dbpkgr could not find a path for ", package_name, "\n",
        "Check if the package has been created"
      )
    )
  }
}

#' Create package based on a database connection
#'
#' @description Generates a temp package with a number of functions
#' for interacting with a database connection.
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
#' @return
#' Returns `NULL` invisbly.
#' @export
#'
#' @seealso [dbp_init()] and [dbp_load()] which this function wraps.
#'
#' @examples
#' \dontrun{
#' con <- DBI::dbConnect(RSQLite::SQLite(), ":memory:")
#' DBI::dbWriteTable(con, "mtcars", mtcars)
#'
#' dbp_package(con, "mydb")
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
dbp_package <- function(connection, package_name, temp = TRUE) {
  dbp_init(connection, package_name, temp)

  dbp_load(package_name)

  invisible()
}
