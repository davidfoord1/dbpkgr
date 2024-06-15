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
    "#' Retrieve results from a query to the ", package_name, " database\n",
    "#' \n",
    "#' Returns the result of a SQL query to the `", package_name, "` connection\n",
    "#' as a lazy tibble.\n",
    "#' @param query A string containing SQL.\n",
    "#' \n",
    "#' @return A \\code{tibble}, the result of the query.\n",
    "#' @export\n",
    "#' @details Executes \\code{dplyr::tbl()}\n",
    "#' \n",
    "#' @seealso \\link{", package_name, "_list_tables} for the tables that can be queried.\n",
    "#' \n",
    "#' \\link{", package_name, "_execute} to execute a SQL statement agianst the connection\n",
    function_name, " <- function(query) {\n",
    "connection <- ", package_name, "_env[['connection']]\n",
    "dplyr::tbl(connection, dplyr::sql(query))\n",
    "}\n"
  )

  write_R_file(package_name, function_name, function_code)
}
