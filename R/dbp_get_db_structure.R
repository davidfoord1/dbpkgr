#' Get database structure
#'
#' Returns a table of information about the structure of the database.
#' Specfically, it attempts to read catalog, schema, table name and type from
#' `INFORMATION_SCHEMA.TABLES`. If `INFORMATION_SCHEMA` is not available, it
#' uses [DBI::dbListTables()] and returns
#' `NA` for columns other than TABLE_NAME.
#' This function is useful for building queries for tables
#' in the format `SELECT * FROM catalog.schema.table`.
#'
#' The `_structure()` functions generated for each package work the same,
#' without taking the connection argument. This function is exported for working
#' with connection information to enhance the package e.g. after calling
#' [dbp_generate()] and before [dbp_load()].
#'
#' @param connection A database connection to get the structure for.
#'
#' @return A `lazy tbl` with columns `catalog`, `table_schema`, `table_name`, `table_type`.
#' It will be a `tibble` if information_schema is not found.
#'
#' @export
#' @import dbplyr
dbp_db_structure <- function(connection) {
  tryCatch(dplyr::tbl(
    connection,
    dplyr::sql("SELECT table_catalog, table_schema, table_name, table_type FROM INFORMATION_SCHEMA.TABLES"))
  ,
  error = function(e) {
    tables <- DBI::dbListTables(connection)
    tibble::tibble(
          'table_catalog' = rep(NA_character_, length(tables)),
          'table_schema' = rep(NA_character_, length(tables)),
          'table_name' = tables,
          'table_type' = rep(NA_character_, length(tables)),
    )
  })
}
