
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
- `_execute()` takes an SQL string and executes it against the
  connection.

As well as a function for each and every table in the database, so you
can take advantage of autocomplete for table names.

The package is most functional where an `INFORMATION_SCHEMA` is provided
by the connection database management system (DBMS), which it can used
to get the `_structure()` and build queries like
`FROM table_schema.table_name`.

## Installation

You can install the development version of dbpkgr from
[GitHub](https://github.com/) with:

``` r
# install.packages("remotes")
remotes::install_github("davidfoord1/dbpkgr")
```

## Example

``` r
library(dbpkgr)
```

A demo connection with a database in memory:

``` r
connection <- DBI::dbConnect(RSQLite::SQLite(), ":memory:")
DBI::dbWriteTable(connection, "mtcars", mtcars)
DBI::dbWriteTable(connection, "iris", iris)
```

Set up the package with a call to `dbp_package`, supplying the
connection and package name. Once the package is created you don’t need
to handle the connection object anymore.

``` r
dbp_package(connection, "mydb")
```

The name will be used as a prefix for auto-complete friendly functions,
with which you can get information from the connection:

``` r
mydb_list_tables()
#> [1] "iris"   "mtcars"
```

Tables get their own functions:

``` r
mydb_mtcars()
#> # Source:   SQL [?? x 11]
#> # Database: sqlite 3.46.0 [:memory:]
#>      mpg   cyl  disp    hp  drat    wt  qsec    vs    am  gear  carb
#>    <dbl> <dbl> <dbl> <dbl> <dbl> <dbl> <dbl> <dbl> <dbl> <dbl> <dbl>
#>  1  21       6  160    110  3.9   2.62  16.5     0     1     4     4
#>  2  21       6  160    110  3.9   2.88  17.0     0     1     4     4
#>  3  22.8     4  108     93  3.85  2.32  18.6     1     1     4     1
#>  4  21.4     6  258    110  3.08  3.22  19.4     1     0     3     1
#>  5  18.7     8  360    175  3.15  3.44  17.0     0     0     3     2
#>  6  18.1     6  225    105  2.76  3.46  20.2     1     0     3     1
#>  7  14.3     8  360    245  3.21  3.57  15.8     0     0     3     4
#>  8  24.4     4  147.    62  3.69  3.19  20       1     0     4     2
#>  9  22.8     4  141.    95  3.92  3.15  22.9     1     0     4     2
#> 10  19.2     6  168.   123  3.92  3.44  18.3     1     0     4     4
#> # ℹ more rows
```

They are lazy loaded - as a connection object that works with a
dplyr/dbplyr chain:

``` r
# median petal length/width ratio by species
mydb_iris() |>
  mutate(petal_ratio = Petal.Length / Petal.Width) |>
  summarise(petal_ratio = median(petal_ratio, na.rm = TRUE), .by = Species) |>
  arrange(desc(petal_ratio))
#> # Source:     SQL [3 x 2]
#> # Database:   sqlite 3.46.0 [:memory:]
#> # Ordered by: desc(petal_ratio)
#>   Species    petal_ratio
#>   <chr>            <dbl>
#> 1 setosa            7   
#> 2 versicolor        3.24
#> 3 virginica         2.67
```

You can retrieve raw SQL query results:

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

And execute SQL statements that don’t return a table:

``` r
mydb_execute("CREATE TABLE table_1 (ID int PRIMARY KEY)")
#> [1] 0
mydb_list_tables()
#> [1] "iris"    "mtcars"  "table_1"
mydb_execute("DROP TABLE table_1")
#> [1] 0
mydb_list_tables()
#> [1] "iris"   "mtcars"
```

Basic documentation is automatically generated for the temporary package
e.g. you could use

``` r
help(mydb_structure)
```
