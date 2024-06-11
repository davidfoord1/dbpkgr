#' Uninstall and delete a dbpkgr db package
#'
#' @description Detaches the package from the search path and deletes the
#' package files. It is recommended to restart the R session afterwards.
#'
#' You shouldn't need to call this function as it will be called automatically
#' on clean up if the package was created with argument `temp = TRUE`. It is
#' provided for more fine control of the cleanup, especially for when
#' `temp = FALSE`.
#'
#' @param package_name The name of the dbpkgr package to be deleted. This should
#' be a package created by [dbp_package()] or [dbp_init()].
#'
#' @return
#' Returns `NULL` invisibly.
#'
#' @seealso [dbp_package_path()] to locate the package files.
#'
#' @export
dbp_unload <- function(package_name) {
  path <- dbp_package_path(package_name)

  search_name <- paste0("package:", package_name)

  if (search_name %in% search()) {
    detach(search_name, unload = TRUE, character.only = TRUE)
  }

  if (dir.exists(path)) {
    unlink(path, recursive = TRUE, force = TRUE)
  }

  invisible()
}
