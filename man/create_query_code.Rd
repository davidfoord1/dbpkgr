% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/create_query_code.R
\name{create_query_code}
\alias{create_query_code}
\title{Generate the code file for _query functions}
\usage{
create_query_code(package_name)
}
\arguments{
\item{package_name}{A string, the name of the package to create the file for.}
}
\value{
Returns \code{NULL} invisibly.
}
\description{
Generate the R file for a dbpkgr package's _query function. Which
gets the results of an SQL query against the connection.
}
