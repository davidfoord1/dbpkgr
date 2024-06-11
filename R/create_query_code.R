#' Generate the code file for _query functions
#'
#' @description
#' Generate the R file for a dbpkgr package's _query function. Which
#' gets the results of an SQL query against the connection.
#'
#' @param package_name
#' A string, the name of the package to create the file for.
#'
#' @return
#' Returns `NULL` invisibly.
create_query_code <- function(package_name) {
  function_name <- paste0(package_name, "_query")

  function_code <- paste0(
    "#' Retrieve results from a query\n",
    "#' \n",
    "#' Returns the result of a SQL query to the `", package_name, "` connection\n",
    "#' as a data.frame.\n",
    "#' @param query A string containing SQL.\n",
    "#' \n",
    "#' @return A \\code{data.frame}, the result of the query.\n",
    "#' @export\n",
    "#' @details This relies on \\code{DBI::dbGetQuery}\n",
    "#' \n",
    "#' @seealso \\link{", package_name, "_list_tables} for the tables that can be queried.\n",
    function_name, " <- function(query) {\n",
    "connection <- ", package_name, "_env[['connection']]\n",
    "DBI::dbGetQuery(connection, query)\n",
    "}\n"
  )

  write_R_file(package_name, function_name, function_code)
}
