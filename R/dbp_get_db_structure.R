#' Get database structure
#'
#' Attempts to read catalog, schema, table name and type from `INFORMATION_SCHEMA.TABLES`.
#' If `INFORMATION_SCHEMA` is not available, it uses [DBI::dbListTables()] and returns
#' `NA` for columns other than TABLE_NAME.
#' This function is useful for building queries for tables
#' in the format `SELECT * FROM catalog.schema.table`.
#'
#' The `_structure()` functions generated for each package work the same,
#' without taking the connection argument. This function is exported for working
#' with connection information to enhance the package e.g. after calling
#' [dbp_init()] and before [dbp_load()].
#'
#' @param connection A database connection to get the structure for.
#'
#' @return A tibble with columns CATALOG, TABLE_SCHEMA, TABLE_NAME.
#' It will be a lazy table/remote connection if information_schema is found.
#' TABLE_TYPE.
#'
#' @export
#' @import dbplyr
dbp_get_db_structure <- function(connection) {
  tryCatch(dplyr::tbl(
    connection,
    dplyr::sql("SELECT TABLE_CATALOG, TABLE_SCHEMA, TABLE_NAME FROM INFORMATION_SCHEMA.TABLES"))
  ,
  error = function(e) {
    tables <- DBI::dbListTables(connection)
    tibble::tibble(
          'TABLE_CATALOG' = rep(NA_character_, length(tables)),
          'TABLE_SCHEMA' = rep(NA_character_, length(tables)),
          'TABLE_NAME' = tables,
          'TABLE_TYPE' = rep(NA_character_, length(tables)),
    )
  })
}
