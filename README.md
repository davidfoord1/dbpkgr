
<!-- README.md is generated from README.Rmd. Please edit that file -->

# dbpkgr

<!-- badges: start -->
<!-- badges: end -->

dbpkgr seeks to turn a database connection into a temporary R package to
provide a set of convenience functions. Each created package supplies
the following functions for the given connection:

- `_structure()` retrieves data.frame of catolog, schema and table names
  from information_schema.tables.
- `_list_schemas()` retrieves a character vector of schema names
  available.
- `_list_tables()` retrieves a character vector of table names
  available.
- `_query()` takes a SQL string and retrieves the result as a
  data.frame.

It is designed to work best where an `INFORMATION_SCHEMA` is provided by
the connection database management system (DBMS). Once the package is
created you don’t need to handle the connection object anymore.

## Installation

You can install the development version of dbpkgr from
[GitHub](https://github.com/) with:

``` r
# install.packages("devtools")
devtools::install_github("davidfoord1/dbpkgr")
```

## Example

``` r
library(dbpkgr)
```

A demo with a database in memory:

``` r
connection <- DBI::dbConnect(RSQLite::SQLite(), ":memory:")
DBI::dbWriteTable(connection, "mtcars", mtcars)
DBI::dbWriteTable(connection, "iris", iris)
```

Set up the package with a single function call, supplying the connection
and package name:

``` r
dbp_package(connection, "mydb")
```

The name will be used as a prefix for auto-complete friendly functions,
with which you can get information from the connection:

``` r
mydb_list_tables()
#> [1] "iris"   "mtcars"
```

Or retrieve raw SQL query results:

``` r
mydb_query("SELECT cyl, COUNT(cyl) AS count FROM mtcars GROUP BY cyl")
#> # Source:   SQL [3 x 2]
#> # Database: sqlite 3.46.0 [:memory:]
#>     cyl count
#>   <dbl> <int>
#> 1     4    11
#> 2     6     7
#> 3     8    14
```

Basic documentation is automatically generated for the temporary
package, e.g. provided by:

``` r
?mydb_structure
```
