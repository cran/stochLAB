% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/get_avg_prob_collision.R
\name{get_avg_prob_collision}
\alias{get_avg_prob_collision}
\title{Average single transit collision risk with no avoidance}
\usage{
get_avg_prob_collision(
  flight_speed,
  body_lt,
  wing_span,
  prop_upwind = 0.5,
  flap_glide,
  rotor_speed,
  rotor_radius,
  blade_width,
  blade_pitch,
  n_blades,
  chord_prof = chord_prof_5MW
)
}
\arguments{
\item{flight_speed}{Numeric value. The bird flying speed (\eqn{v}), in
metres/sec.}

\item{body_lt}{Numeric value. The length of the bird (\eqn{L}), in metres.}

\item{wing_span}{Numeric value. The wingspan of the bird (\eqn{W}), in
metres.}

\item{prop_upwind}{Numeric value between 0-1 giving the proportion of
flights upwind - defaults to 0.5.}

\item{flap_glide}{Numeric value representing the correction for flapping or
gliding birds (\eqn{F}).}

\item{rotor_speed}{Numeric value. The operational rotation speed, in
revolutions/min.}

\item{rotor_radius}{Numeric value. The radius of the rotor (\eqn{R}), in
metres.}

\item{blade_width}{Numeric value, giving the maximum blade width, in metres.}

\item{blade_pitch}{Numeric value. The average blade pitch angle, the angle
between the blade surface and the rotor plane (\eqn{\gamma}), in radians.}

\item{n_blades}{An integer, the number of blades in rotor (\eqn{b}).}

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
A numeric value. The average collision probability (risk) for a bird
flying through any point of the rotor circle area.
}
\description{
Calculate the average probability of collision for a single bird transit at
any point across the rotor, assuming no avoidance action. Required for the
Basic model calculations, where flights at collision risk height are
assumed to be uniformly distributed.
}
\details{
Methodology and assumptions underpinning \code{get_avg_prob_collision}
are described in "Stage C" of
\href{https://www.bto.org/sites/default/files/u28/downloads/Projects/Final_Report_SOSS02_Band1ModelGuidance.pdf}{Band (2012)}.
}
\examples{
       get_avg_prob_collision(
           flight_speed = 13.1,
           body_lt = 0.85,
           wing_span = 1.01,
           prop_upwind = 0.5,
           flap_glide = 1,
           rotor_speed = 15,
           rotor_radius = 120,
           blade_width = 5,
           blade_pitch = 15,
           n_blades = 3,
           chord_prof = chord_prof_5MW
           )

}
