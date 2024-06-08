create_list_tables_fun <- function(package_name, path) {
  function_name <- paste0(package_name, "_list_tables")
  function_file <- file.path(path, "R", paste0(function_name, ".R"))

  function_code <- paste0(
    "#' Get a list of tables in the database\n",
    "#' \n",
    "#' Queries the `", package_name, "` connection to retrieve a list of table\n",
    "#' names.\n",
    "#' \n",
    "#' @return A character vector of table names.\n",
    "#' @export\n",
    function_name, " <- function() {\n",
    "  connection <- get('", package_name, "_connection', envir = dbp_env)\n",
    "  db_structure <- dbp_get_db_structure(connection)\n",
    "  db_structure[['TABLE_NAME']]\n",
    "}\n"
  )

  writeLines(function_code, con = function_file)
}
