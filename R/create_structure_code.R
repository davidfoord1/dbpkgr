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
create_structure_code <- function(package_name) {
  function_name <- paste0(package_name, "_structure")

  function_code <- paste0(
    "#' Get database structure\n",
    "#'\n",
    "#' Returns a table of schema and table information for the `", package_name, "` connection.\n",
    "#' It attempts to read from \\code{information_schema.tables}.\n",
    "#' If not available, it uses \\code{DBI::dbListTables} and returns\n",
    "#' \\code{NA} for columns other than TABLE_NAME.\n",
    "#'\n",
    "#' This function is useful for building queries for tables\n",
    "#' in the format \\code{SELECT * FROM catalog.schema.table}.\n",
    "#' \n",
    "#' @return A \\code{lazy tbl} with columns \\code{catalog, table_schema, table_name, table_type.}\n",
    "#' It will be a a \\code{tibble} if information_schema is not found.\n",
    "#' @export\n",
    "#' @seealso \\link{", package_name, "_list_tables} for just the table names.\n",
    "#' \n",
    "#' @seealso \\link{", package_name, "_list_schemas} for the schema names.\n",
    "#' @examples\n",
    "#' \\dontrun{\n",
    function_name, " <- function() {\n",
    "connection <- ", package_name, "_env[['connection']]\n",
    "tryCatch(\n",
      "{\n",
        "dplyr::tbl(connection, dbplyr::sql(\n",
          "'SELECT table_catalog, table_schema, table_name, table_type FROM information_schema.tables'\n",
        "))\n",
      "},\n",
      "# If unable to generate from INFORMATION_SCHEMA\n",
      "# Use dbListTables and return NA for catalog, schema and table type\n",
      "error = function(e) {\n",
        "tables <- DBI::dbListTables(connection)\n",
       " \n",
        "tibble::tibble(\n",
          "'table_catalog' = rep(NA_character_, length(tables)),\n",
          "'table_schema' = rep(NA_character_, length(tables)),\n",
          "'table_name' = tables,\n",
          "'table_type' = rep(NA_character_, length(tables))\n",
        ")\n",
      "})\n",
    "}\n"
  )

  write_R_file(package_name, function_name, function_code)
}
