
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
create_table_function_code <- function(package_name) {
  con <- dbp_env[[paste0(package_name, "_connection")]]
  structure <- dbp_db_structure(con)

  catalog_names <- structure[["table_catalog"]]
  schema_names <- structure[["table_schema"]]
  table_names <- structure[["table_name"]]

  if (purrr::none(schema_names, is.na)) {
    from <- paste0(catalog_names, schema_names, table_names, sep = ".")
  } else {
    from <- table_names
  }

  function_names <- paste0(package_name, "_", table_names)

  text <- paste0(
    "#' Get the ", table_names, " table\n",
    "#' \n",
    "#' @description Lazy load the \\code{", table_names, "} table\n",
    "#' from the `", package_name, "` connection.\n",
    "#' \n",
    "#' @return A lazy \\code{tbl}\n",
    "#' @export\n",
    "#' @details Created with ",
    "#' \\code{dplyr::tbl(connection, dplyr::sql('SELECT * FROM ", from, "'))}\n",
    "#' \n",
    "#' @seealso \\link{", package_name, "_list_tables} for the tables that can be queried.\n",
    function_names, " <- function() {\n",
    "connection <- ", package_name, "_env[['connection']]\n",
    "dplyr::tbl(connection, dplyr::sql('SELECT * FROM ", from, "'))\n",
    "}\n"
  )

  purrr::walk2(function_names, text, \(.x, .y) write_R_file(package_name, .x, .y))
}
