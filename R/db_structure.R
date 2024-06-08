#' Get database structure
#'
#' Attempts to read catalog, schema, table type and table name from `INFORMATION_SCHEMA.TABLES`.
#' If `INFORMATION_SCHEMA` is not available, it uses `DBI::dbListTables` and returns
#' `NA` for catalog, schema and type. This function is useful for building queries for tables
#' in the format `SELECT * FROM catalog.schema.table`.
#'
#' @param connection A DBI database connection object.
#' @param schema Optionally select results only for a specific schema.
#'
#' @return A data.frame with columns `TABLE_CATALOG`, `TABLE_SCHEMA`, `TABLE_TYPE`
#' and `TABLE_NAME`
#'
#' @examples
#' \dontrun{
#' con <- DBI::dbConnect(RSQLite::SQLite(), ":memory:")
#'
#' DBI::dbWriteTable(con, "mtcars", mtcars)
#'
#' dbp_get_db_structure(con)
#' }
dbp_get_db_structure <- function(connection, schema = NULL) {
  if (is.null(schema)) {

    tryCatch(
      {
        DBI::dbGetQuery(
          connection,
          "SELECT TABLE_CATALOG, TABLE_SCHEMA, TABLE_TYPE, TABLE_NAME FROM INFORMATION_SCHEMA.TABLES"
        )
      },

      # If unable to generate from INFORMATION_SCHEMA
      # Use dbListTables and return NA for catalog, schema and table type
      error = function(e) {
        tables <- DBI::dbListTables(connection)

        data.frame(
          "TABLE_CATALOG" = rep(NA_character_, length(tables)),
          "TABLE_SCHEMA" = rep(NA_character_, length(tables)),
          "TABLE_NAME" = tables,
          "TABLE_TYPE" = rep(NA_character_, length(tables))
        )
    })

  } else {

    # If schema is set, select only from that schema
    DBI::dbGetQuery(
      connection,
      paste0(
        "SELECT TABLE_CATALOG, TABLE_SCHEMA, TABLE_NAME, TABLE_TYPE  FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA = '",
        schema,
        "'"
      )
    )

  }
}
