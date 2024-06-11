#' Generate the code file for _list_table functions
#'
#' @description
#' Generate the R file for a dbpkgr package's list_tables function. Which
#' retrieves all the table names available from the connection.
#'
#' @param package_name
#' A string, the name of the package to create the file for.
#'
#' @return
#' Returns `NULL` invisibly.
create_list_tables_code <- function(package_name) {
  function_name <- paste0(package_name, "_list_tables")

  function_code <- paste0(
    "#' Get a list of tables in the database\n",
    "#' \n",
    "#' Queries the `", package_name, "` connection to retrieve a list of table\n",
    "#' names available.\n",
    "#' \n",
    "#' @return A character vector of table names.\n",
    "#' @export\n",
    "#' @seealso \\link{", package_name, "_structure} for the full information_schema.tables.\n",
    "#' \n",
    "#' @seealso \\link{", package_name, "_list_schemas} for the available schemas.\n",
    function_name, " <- function() {\n",
    "unique(", package_name, "_structure()[['TABLE_NAME']])\n",
    "}\n"
  )

  write_R_file(package_name, function_name, function_code)
}
