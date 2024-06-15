#' Generate code file for _execute functions
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
create_execute_code <- function(package_name) {
  function_name <- paste0(package_name, "_execute")

  function_code <- paste0(
    "#' Execute a SQL statement\n",
    "#' \n",
    "#' Executes an SQL statement on the `", package_name, "` connection\n",
    "#' as a lazy tibble.\n",
    "#' @param query A string containing SQL to execute.\n",
    "#' \n",
    "#' @return Returns the number of rows affected.\n",
    "#' @details Executes \\code{DBI::dbExecute()}\n",
    "#' \n",
    "#' @seealso \\link{", package_name, "_query} to retrieve result from a SQL query.\n",
    function_name, " <- function(statement) {\n",
    "connection <- ", package_name,"_dbpkgr_env[['connection']]\n",
    "DBI::dbExecute(connection, statement)",
    "}\n"
  )

  write_R_file(package_name, function_name, function_code)
}
