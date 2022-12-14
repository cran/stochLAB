% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/stochLAB.R
\docType{package}
\name{stochLAB}
\alias{stochLAB}
\title{stochLAB: Stochastic Collision Risk Model}
\description{
{stochLAB} is a tool to run stochastic (and deterministic) Collision Risk
Models (CRM) for seabirds on offshore wind farms.

The main functions of stochLAB are:
\itemize{
\item \code{\link[=stoch_crm]{stoch_crm()}}: Stochastic Collision Risk Model,
\item \code{\link[=band_crm]{band_crm()}}: Deterministic Collision Risk Model,
\item \code{\link[=mig_stoch_crm]{mig_stoch_crm()}}: Stochastic Migration Collision risk Model
}
}
\section{Overview}{


The \code{{stochLAB}} package is an adaptation of the \href{https://data.marine.gov.scot/dataset/developing-avian-collision-risk-model-incorporate-variability-and-uncertainty-r-code-0}{R code}
developed by \href{https://data.marine.gov.scot/dataset/developing-avian-collision-risk-model-incorporate-variability-and-uncertainty}{Masden (2015)}
to incorporate variability and uncertainty in the avian collision risk model
originally developed by \href{https://www.bto.org/sites/default/files/u28/downloads/Projects/Final_Report_SOSS02_Band1ModelGuidance.pdf}{Band (2012)}.

Code developed under \code{{stochLAB}} substantially re-factored and re-structured
Masden's (heavily script-based) implementation into a user-friendly,
streamlined, well documented and easily distributed tool. Furthermore, this
package lays down the code infrastructure for easier incorporation of new
functionality, e.g. extra parameter sampling features, model expansions,
etc.

Previous code underpinning key calculations for the extended model has been
replaced by an alternative approach, resulting in significant gains in
computational speed over Masden's code. This optimization
is particularly beneficial under a stochastic context, when Band calculations
are computed repeatedly. See \code{\link[=generate_rotor_grids]{generate_rotor_grids()}} for further details.
}

\section{Function \code{stoch_crm()}}{


\code{stoch_crm()} is essentially a replacement function for script \emph{BandModel.r}
in Masden's approach. Main changes in terms of user interface include:
\itemize{
\item Collision model runs for one single scenario (i.e. one species for one
turbine scenario) at each \code{stoch_crm()} call. Apart from gains in development
code structure, this unit-based approach was considered to offer greater end
user flexibility for setting up and managing multiple scenarios (including
parallel computation).
\item Input parameters now entered explicitly into feature-specific arguments,
instead of bundled together into wide-column tables. This improves code
readability and reduces the quantity of hard-coded parameter names,
therefore making referencing errors less likely.
\item Outputs no longer saved automatically to external files.
}
\subsection{Seasonal Outputs}{

\code{stoch_crm()} now provides an option for user-defined seasonal outputs, allowing
for country/region specific seasonal definitions.

Currently implemented CRM calculations produce collision estimates on a
monthly basis to reflect changing bird abundance within the windfarm area.
Seasonal estimates are obtained by aggregating monthly estimates over each
season definition, with uncertainty in collision estimates being suitably
propagated to seasonal outputs.
}

\subsection{Sampling distributions}{

Masden's implementation used Normal and Truncated Normal distributions to
generate random parameter values. However, the Normal distribution is
unbounded, and so there was the risk of randomly drawing inappropriate values in
some cases.

\code{stoch_crm()} extends the use of bounded probability distributions to all model
parameters. Strictly positive features (e.g. bird densities, body length,
turbine downtime, etc.) are sampled from Truncated Normal distributions, while
features constrained between 0 and 1 (e.g. nocturnal activity, proportion
of flights at collision risk height, etc) are assumed to follow Beta
distributions.

In addition, new functionality has been incorporated to allow the use of bird
density resamples (e.g. bootstrap samples) or quantile estimates from density
estimation models in the simulations.
}
}

\section{Function \code{band_crm()}}{

\code{band_crm()} performs the core CRM calculations required to estimate the
number of collisions, as per \href{https://www.bto.org/sites/default/files/u28/downloads/Projects/Final_Report_SOSS02_Band1ModelGuidance.pdf}{Band (2012)}.
While being the computing workhorse of the \code{stoch_crm()} function, it can
also be used alone, providing backward compatibility with the original Band
spreadsheet outputs.
}

\examples{
# ------------------------------------------------------
# Run with arbitrary parameter values, for illustration
# ------------------------------------------------------

# Setting a dataframe of parameters to draw from
params <- data.frame(
  flight_speed = 13.1,         # Flight speed in m/s
  body_lt = 0.85,              # Body length in m
  wing_span = 1.01,            # Wing span in m
  flight_type = "flapping",    # flapping or gliding flight
  avoid_rt_basic = 0.989,      # avoidance rate for option 1 and 2
  avoid_rt_ext = 0.981,        # extended avoidance rate for option 3 and 4
  noct_activity = 0.5,         # proportion of day birds are inactive
  prop_crh_surv = 0.13,        # proportion of birds at collision risk height (option 1 only)
  prop_upwind = 0.5,           # proportion of flights that are upwind
  rotor_speed = 15,            # rotor speed in m/s
  rotor_radius = 120,          # radius of turbine in m
  blade_width = 5,             # width of turbine blades at thickest point in m
  blade_pitch = 15,            # mean radius pitch in Radians
  n_blades = 3,                # total number of blades per turbine
  hub_height = 150,            # height of hub in m above HAT
  n_turbines = 100,            # number of turbines in the wind farm
  wf_width = 52,               # width across longest section of wind farm
  wf_latitude = 56,            # latitude of centroid of wind farm
  tidal_offset = 2.5,          # mean tidal offset from HAT of the wind farm
  lrg_arr_corr = TRUE          # apply a large array correction?
)

# Monthly bird densities
b_dens <- data.frame(
  month = month.abb,
  dens = runif(12, 0.8, 1.5)
)

# flight height distribution from Johnston et al
gen_fhd_dat <- Johnston_Flight_heights_SOSS \%>\%
  dplyr::filter(variable=="Gannet.est") \%>\%
  dplyr::select(height,prop)


# monthly operational time of the wind farm
turb_oper <- data.frame(
  month = month.abb,
  prop_oper = runif(12,0.5,0.8)
)


band_crm(
  model_options = c(1,2,3),
  flight_speed = params$flight_speed,
  body_lt = params$body_lt,
  wing_span = params$wing_span,
  flight_type = params$flight_type,
  avoid_rt_basic = params$avoid_rt_basic,
  avoid_rt_ext = params$avoid_rt_ext,
  noct_activity = params$noct_activity,
  prop_crh_surv = params$prop_crh_surv,
  dens_month = b_dens,
  prop_upwind = params$prop_upwind,
  gen_fhd = gen_fhd_dat,
  site_fhd = NULL,  # Option 4 only
  rotor_speed = params$rotor_speed,
  rotor_radius = params$rotor_radius,
  blade_width = params$blade_width,
  blade_pitch = params$blade_pitch,
  n_blades = params$n_blades,
  hub_height = params$hub_height,
  chord_prof = chord_prof_5MW,
  n_turbines = params$n_turbines,
  turb_oper_month = turb_oper,
  wf_width = params$wf_width,
  wf_latitude = params$wf_latitude,
  tidal_offset = params$tidal_offset,
  lrg_arr_corr = params$lrg_arr_corr
  )
}
\seealso{
Useful links:
\itemize{
\item \url{https://github.com/HiDef-Aerial-Surveying/stochLAB}
\item Report bugs at \url{https://github.com/HiDef-Aerial-Surveying/stochLAB/issues}
}
}
