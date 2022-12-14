% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/generate_rotor_grids.R
\name{generate_rotor_grids}
\alias{generate_rotor_grids}
\title{Geometric attributes at equidistant points within the rotor's unit circle}
\usage{
generate_rotor_grids(yinc = 0.05, xinc = 0.05, chord_prof)
}
\arguments{
\item{yinc, xinc}{numeric values, the grid increments along the y-axis and
x-axis (i.e. grid cell dimensions)}

\item{chord_prof}{A data frame with the chord taper profile of the rotor
blade. Function expects two named columns:
\itemize{
\item{\code{pp_radius}, equidistant intervals of radius at bird passage point,
as a proportion of \code{rotor_radius}, within the range \eqn{[0, 1]}.}
\item{\code{chord}, the chord width at \code{pp_radius}, as a proportion
of \code{blade_width}.}
}
Defaults to a generic profile for a typical modern 5MW turbine. See
\code{\link[=chord_prof_5MW]{chord_prof_5MW()}} for details.}
}
\value{
A list with the following elements, taking the center of the rotor as
the origin in the rotor's plane:
\itemize{
\item{\code{x_grid}, a 2D array of horizontal distances from the rotor's
horizontal axis, as proportion of rotor radius, at each grid point}
\item{\code{y_grid}, a 2D array of vertical distances from the rotor's
vertical axis, as proportion of rotor radius, at each grid point}
\item{\code{r_grid}, a 2D array of radial distances from rotor center,
as proportion of rotor radius, at each grid point}
\item{\code{phi_grid}, a 2D array of angles, relative to vertical, at
each grid point}
\item{\code{chord_grid}, a 2D array of blade chord width at each grid
point}
}
All elements are representative of the left-half of the rotor circle
}
\description{
Generates a list of grids containing geometric attributes of the
rotor disk at equidistant locations, taking the center of the rotor as
the reference point and overlaying the left-half of the rotor disk. The
size of grid cells are determined by \code{xinc} and \code{yinc}, and their
values map properties of the rotor at the cell's location.
}
\details{
These grids are required for an alternative approach to the
calculation of probability of collision under the extended model (i.e.
non-uniform flight distribution at risk height).

Functions \code{xrisksum2}, \code{pcollxy} and \code{pcoll} used in Masden
& Cook implementation (\code{PCollFunctions.r} script) were based on Visual
Basic computations available in the original Band worksheet. This Visual
Basic code was devised under a deterministic context, i.e. for one single
set of collision calculations for one given species and turbine scenario.
However, in a stochastic context, where potentially thousands of collision
calculations are performed per species and turbine scenario, it became
clear that \code{xrisksum2} and associated functions were highly
inefficient for the task at hand.

The alternative approach streamlines computations by calculating (relative)
rotor geometric attributes outside the stochastic sampling loop, which
remain constant over iterations. These elements, calculated via
\code{generate_rotor_grids}, are then applied to sampled parameters
via vectorized operations. The number of calculations per iteration are
thence substantially reduced, leading to significant gains in computational
speed over Masden's implementation for a 1000 iterations
run.
}
\examples{
rotor_grids <- generate_rotor_grids(yinc = 0.05, xinc = 0.05, chord_prof_5MW)

}
\seealso{
\code{\link[=get_x_grid]{get_x_grid()}}, \code{\link[=get_y_grid]{get_y_grid()}},
\code{\link[=get_phi_grid]{get_phi_grid()}}
}
