#' localgrowth: Calculates Z-scores From LMS Files for local growth references.
#'
#' Provides functions to calculate z-scores and centile values for
#' measurements of height, weight, and BMI based on both widely used growth
#' standards and references (CDC, WHO) and references from other populations,
#' including the Tsimane and Shuar indigenous groups of Bolivia and Ecuador.
#' @section Documentation:
#' View available vignettes with: \code{browseVignettes("localgrowth")}
#'
#' @section localgrowth functions:
#' The primary function for \code{localgrowth} is \code{\link{growthRef}}, which provides an interface for calcualting z-scores or centiles from one or more growth references. Other functions include \code{\link{centilesLMS}} which generates centile tables for reference or plotting, and \code{\link{ZfromLMS}} which does simple calculations from LMS values. Other variants of these functions are documented on their respective help pages.
#'
#' @section References:
#' \strong{Tsimane:} Blackwell, AD, Urlacher, SS, Beheim, B, von Rueden, C, Jaeggi, A, Stieglitz, J, Tumble, BC, Gurven, MD, Kaplan, H. (2017) Growth references for Tsimane forager-horticulturalists of the Bolivian Amazon, American Journal of Physical Anthropology. 162(3) 441-461. DOI: 10.1002/ajpa.23128.
#'
#' \strong{Shuar:} Urlacher, SS, Blackwell, AD, Liebert, MA, Madimenos, FC, Cepon-Robins, TJ, Gildner, TE, Snodgrass, JJ, Sugiyama, LS. (2016) Physical Growth of the Shuar: Height, Weight, and BMI Growth References for an Indigenous Amazonian Population, American Journal of Human Biology, 28(1): 16-30. DOI: 10.1002/ajhb.22747.
#'
#' \strong{CDC:} Kuczmarski, R. J., Ogden, C. L., Guo, S. S., Grummer-Strawn, L. M., Flegal, K. M., Mei, Z., Wei, R., Curtin, L. R., Roche, A. F., Johnson, C. L. (2002). 2000 CDC Growth Charts for the United States: Methods and development. Vital Health Statistics 11,1-190.
#'
#' \url{https://www.cdc.gov/growthcharts/data_tables.htm}
#'
#' \strong{WHO:} World Health Organization. (2006). New child growth standards: Length/ height-for-age, weight-for-age, weight-for-length, weight-for-height and body mass index-for-age: Methods and development. Geneva: World Health Organization
#'
#' de Onis, M., Onyango, A., Borghi, E., Siyam, A., Nishida, C., & Siekman, J. (2007). Development of a WHO growth reference for school-aged children and adolescents. Bulletin of World Health Organization, 85, 660-667.
#'
#' \url{http://www.who.int/childgrowth/en/}. \url{http://www.who.int/growthref/en/}.
#'
#' @docType package
#' @name localgrowth
NULL

.onAttach <- function(libname, pkgname) {
  packageStartupMessage(
"Welcome to localgrowth (version ",utils::packageVersion('localgrowth'),").
Basic information: ?localgrowth.
Vignettes: browseVignettes('localgrowth').
Citation: citation('localgrowth').
You can find the latest version and report issues here:
https://github.com/adblackwell/localgrowth.")
}
