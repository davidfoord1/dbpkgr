#' Generate the code file for _list_schema functions
#'
#' @description
#' Generate the R file for a dbpkgr package's list_schemas function. Which
#' retrieves all the schema names available from the connection.
#'
#' @param package_name
#' A string, the name of the package to create the file for.
#'
#' @return
#' Returns `NULL` invisibly.
create_list_schemas_code <- function(package_name) {
  function_name <- paste0(package_name, "_list_schemas")

  function_code <- paste0(
    "#' Get a list of schemas in the ", package_name, " database\n",
    "#' \n",
    "#' Queries the `", package_name, "` connection to retrieve a list of schema\n",
    "#' names available.\n",
    "#' \n",
    "#' @return A character vector of schema names.\n",
    "#' @export\n",
    "#' @seealso \\link{", package_name, "_list_tables} for the table names.\n",
    "#' \n",
    "#' @seealso \\link{", package_name, "_structure} for the full information_schema.schemas.\n",
    function_name, " <- function() {\n",
    "unique(", package_name, "_structure()[['table_schema']])\n",
    "}\n"
  )

  write_R_file(package_name, function_name, function_code)
}
