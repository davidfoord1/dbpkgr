#' Generate the code file for _structure functions
#'
#' @description
#' Generate the R file for a dbpkgr package's structure function. Which
#' retrieves information_schema.tables.
#'
#' @param package_name
#'
#' @return
#' Returns `NULL` invisibly.
create_list_tables_code <- function(package_name,h) {
  function_name <- paste0(package_name, "_list_tables")
  path <- dbp_package_path(package_name)

  file_con <- file(
    file.path(path, "R", paste0(function_name, ".R")),
    encoding = "UTF-8"
  )

  function_code <- paste0(
    "#' Get a list of tables in the database\n",
    "#' \n",
    "#' Queries the `", package_name, "` connection to retrieve a list of table\n",
    "#' names.\n",
    "#' \n",
    "#' @return A character vector of table names.\n",
    "#' @export\n",
    "#' @seealso \\link{", package_name, "_structure} for the full information_schema.tables\n",
    function_name, " <- function() {\n",
    package_name, "_structure()[['TABLE_NAME']]\n",
    "}\n"
  )

  writeLines(function_code, con = file_con)

  close(file_con)

  invisible()
}
