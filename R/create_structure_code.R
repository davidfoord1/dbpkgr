#' Generate the code file for db_structure
#'
#' @description
#' A short description...
#'
#' @param package_name
#' A string, the name of the package to create the file for.
#'
#' @return
#' Returns `NULL` invisibly
create_structure_code <- function(package_name) {
  function_name <- paste0(package_name, "_structure")

  path <- dbp_package_path(package_name)

  file_con <- file(
    file.path(path, "R", paste0(function_name, ".R")),
    encoding = "UTF-8"
  )

  function_code <- paste0(
    "#' Get database structure\n",
    "#'\n",
    "#' Attempts to read catalog, schema, table name and type from `INFORMATION_SCHEMA.TABLES`.\n",
    "#' If `INFORMATION_SCHEMA` is not available, it uses `[DBI::dbListTables()]` and returns\n",
    "#' `NA` for catalog, schema and type. This function is useful for building queries for tables\n",
    "#' in the format `SELECT * FROM catalog.schema.table`.\n",
    "#' \n",
    "#' @return A data.frame with columns CATALOG, TABLE_SCHEMA, TABLE_NAME.\n",
    "#' TABLE_TYPE.\n",
    "#' @export\n",
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
        "DBI::dbGetQuery(\n",
          "connection,\n",
          "'SELECT TABLE_CATALOG, TABLE_SCHEMA, TABLE_NAME, TABLE_TYPE,  FROM INFORMATION_SCHEMA.TABLES'\n",
        ")\n",
      "},\n",
      "# If unable to generate from INFORMATION_SCHEMA\n",
      "# Use dbListTables and return NA for catalog, schema and table type\n",
      "error = function(e) {\n",
        "tables <- DBI::dbListTables(connection)\n",
       " \n",
        "data.frame(\n",
          "'TABLE_CATALOG' = rep(NA_character_, length(tables)),\n",
          "'TABLE_SCHEMA' = rep(NA_character_, length(tables)),\n",
          "'TABLE_NAME' = tables,\n",
          "'TABLE_TYPE' = rep(NA_character_, length(tables))\n",
        ")\n",
      "})\n",
    "}\n"
  )

  writeLines(function_code, con = file_con)

  close(file_con)

  invisible()
}
