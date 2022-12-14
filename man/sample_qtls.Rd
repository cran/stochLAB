% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/utils.R
\name{sample_qtls}
\alias{sample_qtls}
\title{Generate random draws based on empirical c.d.f.}
\usage{
sample_qtls(n, probs, qtls)
}
\arguments{
\item{n}{integer, the number of draws to generate}

\item{probs}{numeric vector, the probabilities}

\item{qtls}{numeric vector, the quantiles for the probabilities
specified in \code{probs}}
}
\value{
a numeric vector, with random draws of the approximated distribution
underpinning the provided quantiles
}
\description{
Generate random draws from a set of quantiles, based on the empirical
cumulative density function
}
\details{
Based on the Inverse Transform Sampling technique, by sampling
random probabilities from a uniform distribution and interpolate (cubic)
the count samples from the percentiles provided by the user (taken as the
empirical cumulative density function)
}
\examples{
 sample_qtls(10,c(0.1,0.2,0.3),qtls=c(0.05,0.1,0.95))
}
