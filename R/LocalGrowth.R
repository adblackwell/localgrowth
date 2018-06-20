#run devtools::document() to compile documentation
#' localgrowth: Calculates Z-scores From LMS Files for local growth references.
#'
#' Provides functions to calculate z-scores and centile values for
#' measurements of height, weight, and BMI based on both widely used growth
#' standards and references (CDC, WHO) and references from other populations,
#' including the Tsimane and Shuar indigenous groups of Bolivia and Ecuador.
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

#' A subset of Tsimane growth data.
#'
#' A dataset containing 200 Tsimane growth measurements.
#'
#' @format A data frame with 200 rows and 6 variables:
#' \describe{
#'   \item{PID}{Individual identifier}
#'   \item{Sex}{Sex, "Male" or "Female"}
#'   \item{Age}{Age in years}
#'   \item{Height}{Height in centimeters}
#'   \item{Weight}{Weight in kilograms}
#'   \item{BMI}{Body mass index in kg/m^2}
#' }
#' @source Blackwell, AD, Urlacher, SS, Beheim, B, von Rueden, C, Jaeggi, A, Stieglitz, J, Tumble, BC, Gurven, MD, Kaplan, H. (2017) Growth references for Tsimane forager-horticulturalists of the Bolivian Amazon, American Journal of Physical Anthropology. 162(3) 441-461. DOI: 10.1002/ajpa.23128.
"TsimaneData"

#' Calculate z-scores
#'
#' Calculates z-scores from a measure and LMS values
#'
#' \code{ZfromLMS} calcuates a z-score from a \code{measure}=\eqn{y} and the distribuiton parameters, \code{la}=\eqn{\lambda}, \code{mu}=\eqn{\mu}, and \code{si}=\eqn{\sigma}, which describe the median, the generalized coefficient of variation, and the power in the Box-Cox transformation. It uses the formula: \eqn{Z=((y / \mu)^\lambda - 1)/(\lambda * \sigma)}
#'
#' @param measure a vector of numbers
#' @param la a vector of lambda values
#' @param mu a vector of mu values
#' @param si a vector of sigma values
ZfromLMS<-function(measure,la,mu,si){
  zs <- ((measure / mu)^la - 1)/(la * si)
  zs
}


#' @rdname growthRef
getZ<-function(x, y, sex, LMS, method=c("fmm", "periodic", "natural", "monoH.FC", "hyman","linear","constant"),rule=1){
  method<-match.arg(method)
  if(length(rule)==1) rule<-c(rule,rule)
  if(is.null(LMS)) return(rep(NA,length=length(x)))
  else x <- .matchLMS(x,sex,LMS,method,rule)
  return(ZfromLMS(y,x$L,x$M,x$S))
}

#' @rdname growthRef
#just a wrapper. Uses pnorm to get centiles from the Z-scores in getZ
getCentile<-function(x, y, sex, LMS, method=c("fmm", "periodic", "natural", "monoH.FC", "hyman","linear","constant"),rule=1){
  return(pnorm(getZ(x, y, sex, LMS, method, rule)))
}

.matchLMS<-function(x, sex, LMS, method, rule){
  if(method %in% c("linear","constant")){
    L.M<-approxfun(LMS[LMS$Sex=="Male",2],LMS$Lambda[LMS$Sex=="Male"],method=method,rule=rule)
    M.M<-approxfun(LMS[LMS$Sex=="Male",2],LMS$Mu[LMS$Sex=="Male"],method=method,rule=rule)
    S.M<-approxfun(LMS[LMS$Sex=="Male",2],LMS$Sigma[LMS$Sex=="Male"],method=method,rule=rule)

    L.F<-approxfun(LMS[LMS$Sex=="Female",2],LMS$Lambda[LMS$Sex=="Female"],method=method,rule=rule)
    M.F<-approxfun(LMS[LMS$Sex=="Female",2],LMS$Mu[LMS$Sex=="Female"],method=method,rule=rule)
    S.F<-approxfun(LMS[LMS$Sex=="Female",2],LMS$Sigma[LMS$Sex=="Female"],method=method,rule=rule)
  } else {
    L.M<-splinefun(LMS[LMS$Sex=="Male",2],LMS$Lambda[LMS$Sex=="Male"],method=method)
    M.M<-splinefun(LMS[LMS$Sex=="Male",2],LMS$Mu[LMS$Sex=="Male"],method=method)
    S.M<-splinefun(LMS[LMS$Sex=="Male",2],LMS$Sigma[LMS$Sex=="Male"],method=method)

    L.F<-splinefun(LMS[LMS$Sex=="Female",2],LMS$Lambda[LMS$Sex=="Female"],method=method)
    M.F<-splinefun(LMS[LMS$Sex=="Female",2],LMS$Mu[LMS$Sex=="Female"],method=method)
    S.F<-splinefun(LMS[LMS$Sex=="Female",2],LMS$Sigma[LMS$Sex=="Female"],method=method)
  }
  L<-ifelse(sex=="Male",L.M(x),L.F(x))
  M<-ifelse(sex=="Male",M.M(x),M.F(x))
  S<-ifelse(sex=="Male",S.M(x),S.F(x))
  rangeM<-range(LMS[LMS$Sex=="Male",2],na.rm=TRUE)
  rangeF<-range(LMS[LMS$Sex=="Female",2],na.rm=TRUE)
  if(rule[1]==1) {
    M[sex=="Male" & x<rangeM[1]]<-NA
    M[sex=="Female" & x<rangeF[1]]<-NA
  }
  if(rule[2]==1) {
    M[sex=="Male" & x>rangeM[2]]<-NA
    M[sex=="Female" & x>rangeF[2]]<-NA
  }
  return(list(L=L,M=M,S=S))
}


#' Calculate Z-scores from growth references
#'
#' Functions to calculates Z-scores from one or more growth references. \code{growthRef} provides an interface for indicating the desired LMS reference and passing growth data to \code{getZ}. \code{getZ} and \code{getCentile} calculate z-scores or centiles from child growth references provided in LMS format.
#'
#' \code{growthRef} returns Z-scores calculated from lambda, mu, sigma (LMS) tables from various sources. \code{growthRef} acts as a wrapper that selects the appropriate LMS tables and passes them to \code{getZ} to calculate z-scores. At present, \code{growthRef} can provide z-scores based on four different growth references: the Tsimane, an indigenous group of Bolivia, the Shuar, an indigenous group of Ecuador, and references or standards from the US Center for Disease Control (CDC) and the World Health Organization (WHO). Internal LMS tables are typically referenced indirectly by \code{growthRef}, but can be referenced directly by \code{pop.type}, i.e. \code{Tsimane.Height}. See below for relevant citations and ranges for each growth reference.
#'
#' \strong{Valid x-value ranges for included references and standards}
#' \tabular{lcccc}{
#'  \tab \strong{HFA (yrs)} \tab \strong{WFA (yrs)} \tab \strong{BFA (yrs)} \tab \strong{WFH (cm)} \cr
#'  \strong{CDC} \tab 0-20 \tab 0-20 \tab 2-20 \tab 45-121  \cr
#'  \strong{WHO} \tab 0-19 \tab 0-10 \tab 0-19 \tab 45-120 \cr
#'  \strong{Tsimane} \tab 0-25 \tab 0-25 \tab 0-25 \tab 45-170 \cr
#'  \strong{Shuar} \tab 0-25 \tab 0-25 \tab 0-25 \tab N/A
#'}
#'
#' Note: For CDC and WHO references, height and length are combined together, with a junction at 2 years of age for height-for-age, and 80.5 cm for weight for height.
#'
#' \code{getZ} calculates z-scores for growth data using an LMS data table, by first determining the appropriate L,M, and S values for a given observation by matching based on sex and then interpolating the L, M, and S values for the exact x-value (age or height) for the observation. Interpolation is done using either \code{\link[stats]{splinefun}} or \code{\link[stats]{approxfun}}, as determined by the \code{method} parameter. By default, observations outside the range of the reference LMS are returned as \code{NA}, but this can be overridden to allow for extrapolation by setting the \code{rule} parameter. See \code{\link[stats]{approxfun}}.
#'
#' \code{getCentile} is simply a wrapper that passes parameters to \code{getZ} and then converts the z-scores to centiles using \code{pnorm}.
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
#' @param x a single value or vector of either ages in years or height in cm at which to calcuate Z-scores, or the name of a column or item in \code{data}.
#' @param y a single value or vector of measures (heights, weights, BMIs) to be converted to Z-scores, or the name of a column or item in \code{data}.
#' @param sex a single value or vector of sexes, or the name of a column or item in \code{data}. Sex must be coded for males/females as 1/0, 1/2, 'm'/'f', 'M'/'F', 'Male'/'Female', or 'male'/'female'.
#' @param data an optional data frame or list containing x, y, or sex.
#' @param type a string indicating the type of Z-score to calculate, corresponding to the measures in x and y. Either "Weight","Height","BMI", or "WFH", indicating weight-for-age, height-for-age, BMI-for-age, or weight-for-height.
#' @param pop the references or standards to return Z-scores based on. Can be "All","CDC","WHO","Tsimane",or "Shuar", with "All" equivalent to \code{pop=c("CDC","WHO","Tsimane","Shuar")}. Subsets are also allowed, i.e. \code{pop=c("CDC","Tsimane")}.
#' @param LMS a data frame containing the LMS table with columns named "Sex","Age","Lambda","Mu", "Sigma" or "Sex","Height","Lambda","Mu","Sigma". For \code{growthRef} this will typically be \code{NULL}, as \code{type} and \code{pop} will be used to determine the appropriate internal LMS tables.
#' @param z a string. Either "zscore" or "centile" indicating the type of value to return.
#' @param method the interpolation method. If it is "fmm", "periodic", "natural", "monoH.FC", or "hyman", \code{\link[stats]{splinefun}} is used. If \code{method} is "linear" or "constant", \code{\link[stats]{approxfun}} is used.
#' @param rule an integer (of length 1 or 2) describing how interpolation is to take place outside the interval [min(x), max(x)]. If \code{rule} is 1 then NAs are returned. If \code{rule} is 2 and method is "linear" or "constant", then \code{rule} is followed as in \code{\link[stats]{approxfun}}. If \code{rule} is 2 and a spline is used, the spline will be used to extrapolate outside the interval. If \code{rule} is length 2 (i.e c(2,1)), then different rules will be used for the left and right side extrapolation.
#'
#' @return
#' Returns either a data frame with columns corresponding to the requested Z-scores or centiles, or a vector, if only a single Z-score is requested.
#'
#' @examples
#' #Height-for-age
#' data(TsimaneData)
#' HFA<-growthRef(Age,Height,Sex,data=TsimaneData,type="Height")
#'
#' #Height-for-age, just CDC and Tsimane
#' HFA<-growthRef(Age,Height,Sex,data=TsimaneData,type="Height",pop=c("CDC","Tsimane"))
#'
#' #Weight-for-height, CDC centiles only
#' WFH<-growthRef(Height,Weight,Sex,data=TsimaneData,type="WFH",pop="CDC",z="centile")
#'
#' #The same as above, but referencing the CDC.WFH table directly
#' WFH<-growthRef(Height,Weight,Sex,data=TsimaneData,LMS=CDC.WFH,z="centile")
#'
#' #Tsimane specific z-score for a single individual, age 2 yrs, 75 cm, male.
#' getZ(2,75,"Male",Tsimane.Height)
#'
#' LMS<-getLMS(0:10,"Male",Tsimane.Height)
#' cent<-centilesLMS(0:10,"Male",Tsimane.Height,cent=c(0.025,0.5,0.975))
#' @seealso \code{\link{ZfromLMS}}, \code{\link{splinefun}}, \code{\link{approxfun}}

growthRef<-function(x, y, sex, data, type=c("Weight","Height","BMI","WFH"), pop=c("All","CDC","WHO","Tsimane","Shuar"), LMS=NULL, z=c("zscore","centile"), method=c("fmm", "periodic", "natural", "monoH.FC", "hyman","linear","constant"), rule=1){
  type<-match.arg(type)
  pop<-match.arg(pop,several.ok=TRUE)
  z<-match.arg(z)
  arg<-as.list(match.call())
  x<-tryCatch(eval(arg$x),error=function(d) eval(arg$x,data))
  y<-tryCatch(eval(arg$y),error=function(d) eval(arg$y,data))
  sex<-tryCatch(eval(arg$sex),error=function(d) eval(arg$sex,data))
  sex<-tolower(as.character(sex))

  #check that sex is coded in an understandable way
  if (all(unique(sex) %in% c("1","2"))){
    sex<-ifelse(sex=="1","Male","Female")
  } else if (all(unique(sex) %in% c("0","1"))){
    sex<-ifelse(sex=="1","Male","Female")
  } else if (all(unique(sex) %in% c("m","f"))){
    sex<-ifelse(sex=="m","Male","Female")
  } else if (all(unique(sex) %in% c("male","female"))){
    sex<-ifelse(sex=="male","Male","Female")
  } else stop("Error, 'sex' must be coded as c(0,1), c(2,1), c('m','f'), c('M','F'), c('Male','Female'), or c('male','female')")

  if(pop[1]=="All") pop<-c("CDC","WHO","Tsimane","Shuar")

  if(!is.null(LMS)) LMSfiles<-as.character(arg$LMS) else LMSfiles<-paste(pop,type,sep=".")

  allzs<-data.frame(sapply(LMSfiles,function(LMSf) getZ(x,y,sex,get0(LMSf),method,rule)))

  if(z=="Centile"){
    allzs<-pnorm(allzs)
    names(allzs)<-paste0("Centile.",names(allzs))
  } else names(allzs)<-paste0("Z.",names(allzs))

  if(ncol(allzs)==1) allzs<-unlist(allzs,use.names=FALSE)
  return(allzs)
}

#This function produces interpolated LMS values for given ages and a given LMS table.
#' @rdname centilesLMS
getLMS<-function(x,sex,LMS,xname="x",method=c("fmm", "periodic", "natural", "monoH.FC", "hyman","linear","constant"), rule=1){

  sex<-tolower(as.character(sex))
  #check that sex is coded in an understandable way
  if (all(unique(sex) %in% c("1","2"))){
    sex<-ifelse(sex=="1","Male","Female")
  } else if (all(unique(sex) %in% c("0","1"))){
    sex<-ifelse(sex=="1","Male","Female")
  } else if (all(unique(sex) %in% c("m","f"))){
    sex<-ifelse(sex=="m","Male","Female")
  } else if (all(unique(sex) %in% c("male","female"))){
    sex<-ifelse(sex=="male","Male","Female")
  } else stop("Error, 'sex' must be coded as c(0,1), c(2,1), c('m','f'), c('M','F'), c('Male','Female'), or c('male','female')")

  method<-match.arg(method)
  if(length(rule)==1) rule<-c(rule,rule)
  if(length(sex)==1) sex<-rep(sex,length(x))
  useLMS <- data.frame(.matchLMS(x,sex,LMS,method,rule))
  useLMS<-cbind(x,useLMS)
  names(useLMS)<-c(xname,"Lambda","Mu","Sigma")
  return(useLMS)
}


#' Interpolate Centile or LMS tables
#'
#' These functions are useful for producing reference tables or plots. \code{centilesLMS} produces a table of centiles. \code{getLMS} produces a table of interpolated LMS values.
#'
#' \code{getLMS} produces a table of LMS values interpolated at the specified x values. Interpolation is done using either \code{\link[stats]{splinefun}} or \code{\link[stats]{approxfun}}, as determined by the \code{method} parameter. By default, observations outside the range of the reference LMS are returned as \code{NA}, but this can be overridden to allow for extrapolation by setting the \code{rule} parameter. See \code{\link[stats]{approxfun}}. \code{centilesLMS} uses \code{getLMS} to produce the appropriate LMS tabel, and then calculates the values at the centiles specified by \code{cent}
#'
#' @param x a single value or vector of either ages in years or height in cm at which to interpolate LMS of centile values.
#' @param sex a single value or vector of sexes. Sex must be coded for males/females as 1/0, 1/2, 'm'/'f', 'M'/'F', 'Male'/'Female', or 'male'/'female'.
#' @param LMS a data frame containing the LMS table with columns named "Sex","Age","Lambda","Mu", "Sigma" or "Sex","Height","Lambda","Mu","Sigma". Internal LMS tables can be referenced by \code{pop.type}, i.e. \code{CDC.Height}
#' @param cent a single value or vector of centiles
#' @param xname optional name to give the x column in the output, typically "Age" or "Height".
#' @param method the interpolation method. If it is "fmm", "periodic", "natural", "monoH.FC", or "hyman", \code{\link[stats]{splinefun}} is used. If \code{method} is "linear" or "constant", \code{\link[stats]{approxfun}} is used.
#' @param rule an integer (of length 1 or 2) describing how interpolation is to take place outside the interval [min(x), max(x)]. If \code{rule} is 1 then NAs are returned. If \code{rule} is 2 and method is "linear" or "constant", then \code{rule} is followed as in \code{\link[stats]{approxfun}}. If \code{rule} is 2 and a spline is used, the spline will be used to extrapolate outside the interval. If \code{rule} is length 2 (i.e c(2,1)), then different rules will be used for the left and right side extrapolation.
#'
#' @return
#' Returns a data frame with columns corresponding to the provided x-value and columns for either Lambda, Mu, and Sigma (for \code{getLMS}), or the requested centiles (for \code{centilesLMS}).
#'
#' @examples
#' #Produce a Tsimane height LMS table for males at ages 0-10
#' LMS<-getLMS(0:10,"Male",Tsimane.Height,xname="Age)
#'
#' #Produce a Tsimane height centile table for males at ages 0-10
#' cent<-centilesLMS(0:10,"Male",Tsimane.Height,cent=c(0.025,0.5,0.975),xname="Age")
#'
#' @seealso \code{\link{ZfromLMS}}, \code{\link{growthRef}}, \code{\link{getZ}}
centilesLMS<-function(x,sex,LMS,cent=c(0.02,0.05,0.25,0.50,0.75,0.95,0.98),xname="x",method=c("fmm", "periodic", "natural", "monoH.FC", "hyman","linear","constant"), rule=1){

  useLMS <- getLMS(x,sex,LMS,xname,method,rule)[,-1]

  getcent<-function(la,mu,si){
    sapply(cent,function(x) exp(log(qnorm(x)*la*si+1)/la+log(mu)),simplify=TRUE)
  }

  if(length(cent)==1) o<-cbind(x,apply(useLMS,1,function(x) getcent(x[1],x[2],x[3])))
  else o<-cbind(x,t(apply(useLMS,1,function(x) getcent(x[1],x[2],x[3]))))
  o<-data.frame(o)
  names(o)<-c(xname,cent)
  return(o)
}


