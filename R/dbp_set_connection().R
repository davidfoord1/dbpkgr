#' Load the connection to be used
#'
#' @description To be included in the \code{on.load()} section of a package
#'   where [dbp_generate()] has been used to create R files for a connection.
#'
#' @param connection A database connection object.
#'
#' @param package_name A string to be used as the name of the temp package and
#'   the prefix to its functions. Must be a valid package name; lowercase no
#'   punctuation recommended.
#'
#' @return Returns `NULL` invisibly
#'
#' @export
dbp_set_connection <- function(connection, package_name) {
  env_name <- paste0(package_name, "_dbpkgr_env")

  eval(parse(text = paste0(env_name, " <- new.env()")))
  eval(parse(text = paste0(env_name, "[['connection']] <- connection")))

  invisible()
}
