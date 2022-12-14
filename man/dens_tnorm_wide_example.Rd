% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/data.R
\docType{data}
\name{dens_tnorm_wide_example}
\alias{dens_tnorm_wide_example}
\title{Example of Truncated Normal parameters for monthly estimates of bird density}
\format{
A 3 x 25 data frame, with the monthly density parameters (columns) for
each of the 3 species (rows). Columns include:
\describe{
\item{Species}{Species name}
\item{Jan}{January mean density}
\item{JanSD}{SD of density in January}
\item{Feb}{February mean density}
\item{FebSD}{SD of density in February}
...
}
}
\usage{
dens_tnorm_wide_example
}
\description{
A data frame of (fake) monthly bird density parameters for three seabird
species.
}
\details{
Intended to illustrate the application of \code{stoch_scrm()} to a multiple
scenario setting, where parameter data is available from tables in wide
format.
}
\keyword{datasets}
