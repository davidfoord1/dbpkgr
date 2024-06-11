#' Register db connection in db package
#'
#' @description Generate a small R file to create an environment variable and
#' store the supplied connection when the db package is loaded.
#'
#' @param package_name The name of the package being created.
#' @param connection The database connection to be stored and used throughout
#' the package.
#'
#' @return
#' Returns `NULL` invisibly.
create_db_env_code <- function(package_name, connection) {
  path <- dbp_package_path(package_name)

  file_con <- file(
    file.path(path, "R", paste0(package_name, "_env.R")),
    encoding = "UTF-8"
  )

  pkg_env_name <- paste0(package_name, "_env")

  file_content <- paste0(
    pkg_env_name, " <- new.env(parent = emptyenv())\n",
    "path <- dbp_package_path('", package_name, "')\n",
    "con <- dbpkgr:::dbp_env[['", package_name, "_connection']]\n",
    pkg_env_name, "[['connection']] <- con \n"
  )

  writeLines(file_content, con = file_con)

  close(file_con)

  invisible()
}
