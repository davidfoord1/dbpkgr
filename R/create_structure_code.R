#' Generate the code file for _structure functions
#'
#' @description
#' Generate the R file for a dbpkgr package's structure function. Which
#' retrieves information_schema.tables.
#'
#' @param package_name
#' A string, the name of the package to create the file for.
#'
#' @return
#' Returns `NULL` invisibly
#' @import dbplyr
#' @import DBI
create_structure_code <- function(package_name) {
  function_name <- paste0(package_name, "_structure")

  function_code <- paste0(
    "#' Get database structure\n",
    "#'\n",
    "#' Attempts to read catalog, schema, table name and type from `INFORMATION_SCHEMA.TABLES`.\n",
    "#' If `INFORMATION_SCHEMA` is not available, it uses \\code{DBI::dbListTables} and returns\n",
    "#' \\code{NA} for columns other than TABLE_NAME.\n",
    "#' This function is useful for building queries for tables\n",
    "#' in the format \\code{SELECT * FROM catalog.schema.table}.\n",
    "#' \n",
    "#' @return A tibble with columns CATALOG, TABLE_SCHEMA, TABLE_NAME.\n",
    "#' It will be a lazy table/remote connection if information_schema is found.\n",
    "#' TABLE_TYPE.\n",
    "#' @export\n",
    "#' @seealso \\link{", package_name, "_list_tables} for just the table names.\n",
    "#' \n",
    "#' @seealso \\link{", package_name, "_list_schemas} for the schema names.\n",
    "#' @examples\n",
    "#' \\dontrun{\n",
    "#' con <- DBI::dbConnect(RSQLite::SQLite(), ':memory:')\n",
    "#' DBI::dbWriteTable(con, 'mtcars', mtcars)\n",
    "#'\n",
    "#' ", package_name, "_structure()\n",
    "#' }\n",
    function_name, " <- function() {\n",
    "connection <- ", package_name, "_env[['connection']]\n",
    "tryCatch(\n",
      "{\n",
        "dplyr::tbl(connection, dbplyr::sql(\n",
          "'SELECT TABLE_CATALOG, TABLE_SCHEMA, TABLE_NAME, TABLE_TYPE FROM INFORMATION_SCHEMA.TABLES'\n",
        "))\n",
      "},\n",
      "# If unable to generate from INFORMATION_SCHEMA\n",
      "# Use dbListTables and return NA for catalog, schema and table type\n",
      "error = function(e) {\n",
        "tables <- DBI::dbListTables(connection)\n",
       " \n",
        "tibble::tibble(\n",
          "'TABLE_CATALOG' = rep(NA_character_, length(tables)),\n",
          "'TABLE_SCHEMA' = rep(NA_character_, length(tables)),\n",
          "'TABLE_NAME' = tables,\n",
          "'TABLE_TYPE' = rep(NA_character_, length(tables))\n",
        ")\n",
      "})\n",
    "}\n"
  )

  write_R_file(package_name, function_name, function_code)
}
