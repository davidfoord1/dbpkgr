#' Generate the code file for _list_columns functions
#'
#' @description
#' Generate the R file for a dbpkgr package's _list_columns function. Which
#' retrieves column name and type from information_schema.columns.
#'
#' @param package_name
#' A string, the name of the package to create the file for.
#'
#' @return
#' Returns `NULL` invisibly
create_list_columns_code <- function(package_name) {
  function_name <- paste0(package_name, "_structure")

  function_code <- paste0(
    "#' Get ", package_name, " database structure\n",
    "#'\n",
    "#' Returns a table of column information information for a table from the `", package_name, "` connection.\n",
    "#' Attempts to read from \\code{information_schema.columns}.\n",
    "#' \n",
    "#' @param table_name String - the name of the table to retrieve from. Must include the full FROM\n",
    "#' specification where there are distinct catalogs and schema e.g. \\code{table_schema.table_name}\n",
    "#' \n",
    "#' @return A \\code{lazy tbl} with columns \\code{column_name, data_type}\n",
    "#' @export\n",
    "#' @seealso \\link{", package_name, "_list_tables} for just the table names.\n",
    "#' \n",
    "#' @seealso \\link{", package_name, "_list_schemas} for the schema names.\n",
    function_name, " <- function() {\n",
    "connection <- ", package_name, "_dbpkgr_env[['connection']]\n",
        "dplyr::tbl(connection, dbplyr::sql(\n",
          "'SELECT column_name, data_type FROM information_schema.columns'\n",
        "))\n",
    "}\n"
  )

  write_R_file(package_name, function_name, function_code)
}
