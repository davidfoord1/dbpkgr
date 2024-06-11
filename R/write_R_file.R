#' Write R function to .R file
#'
#' @description
#' Utility function to be called by all of the `create_*_code` functions,
#' which will write their code to file with UTF-8 encoding.
#'
#' @param package_name
#' A string, the name of the package to create the file for.
#' @param function_name
#' A string, the name of the function for the R file.
#' @param function_code
#' A character vector of text/code to be written to file.
#'
#' @return
#' Returns `NULL` invisibly.
#'
#' @seealso [create_structure_code()], [create_list_tables_code()],
#' [create_list_schemas_code()]
write_R_file <- function(package_name, function_name, function_code) {
  path <- dbp_package_path(package_name)

  file_con <- file(
    file.path(path, "R", paste0(function_name, ".R")),
    encoding = "UTF-8"
  )

  writeLines(function_code, con = file_con)

  close(file_con)

  invisible()
}
