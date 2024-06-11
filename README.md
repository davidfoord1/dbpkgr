
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

Tables get their own functions:

``` r
mydb_iris() 
#> # Source:   SQL [?? x 5]
#> # Database: sqlite 3.46.0 [:memory:]
#>    Sepal.Length Sepal.Width Petal.Length Petal.Width Species
#>           <dbl>       <dbl>        <dbl>       <dbl> <chr>  
#>  1          5.1         3.5          1.4         0.2 setosa 
#>  2          4.9         3            1.4         0.2 setosa 
#>  3          4.7         3.2          1.3         0.2 setosa 
#>  4          4.6         3.1          1.5         0.2 setosa 
#>  5          5           3.6          1.4         0.2 setosa 
#>  6          5.4         3.9          1.7         0.4 setosa 
#>  7          4.6         3.4          1.4         0.3 setosa 
#>  8          5           3.4          1.5         0.2 setosa 
#>  9          4.4         2.9          1.4         0.2 setosa 
#> 10          4.9         3.1          1.5         0.1 setosa 
#> # ℹ more rows
```

They are lazy loaded - as a connection object that works with a
dplyr/dbplyr chain:

``` r
# median petal length/width ratio
mydb_iris() |>
  mutate(petal_length_width_ratio = Petal.Length / Petal.Width) |>
  summarise(petal_length_width_ratio = median(petal_length_width_ratio, na.rm = TRUE), .by = Species) |>
  arrange(desc(petal_length_width_ratio))
#> # Source:     SQL [3 x 2]
#> # Database:   sqlite 3.46.0 [:memory:]
#> # Ordered by: desc(petal_length_width_ratio)
#>   Species    petal_length_width_ratio
#>   <chr>                         <dbl>
#> 1 setosa                         7   
#> 2 versicolor                     3.24
#> 3 virginica                      2.67
```

Or you can retrieve raw SQL query results:

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

Basic documentation is automatically generated for the temporary package
e.g. you could use

``` r
help(mydb_structure)
```
