## ----setup, include = FALSE----------------------------------------------
knitr::opts_chunk$set(
  collapse = TRUE,
  comment = "#>"
)

## ----eval=FALSE----------------------------------------------------------
#  install.packages('devtools')
#  devtools::install_github('adblackwell/localgrowth',build_vignettes = TRUE)

## ------------------------------------------------------------------------
library(localgrowth)
data(TsimaneData)
head(TsimaneData)

## ------------------------------------------------------------------------
HFA<-growthRef(Age,Height,Sex,data=TsimaneData,type="Height")
head(HFA)

## ------------------------------------------------------------------------
WFH<-growthRef(Height,Weight,Sex,data=TsimaneData,type="WFH")
head(WFH)

## ------------------------------------------------------------------------
HFA<-growthRef(Age,Height,Sex,data=TsimaneData,type="Height",pop=c("CDC","Tsimane"),z="centile")
head(HFA)

## ------------------------------------------------------------------------
BFA<-growthRef(Age,BMI,Sex,data=TsimaneData,type="BMI",pop="CDC")
head(BFA)

## ------------------------------------------------------------------------
WFH<-growthRef(Height,Weight,Sex,data=TsimaneData,LMS=CDC.WFH,z="centile")
head(WFH)

## ------------------------------------------------------------------------
#Tsimane specific z-score for a single individual, age 2 yrs, 75 cm, male.
getZ(2,75,"Male",Tsimane.Height)
getCentile(2,75,"Male",Tsimane.Height)

## ----fig1, fig.height = 4, fig.width = 5---------------------------------
#Subset the observations for one individual 
ind<-TsimaneData[TsimaneData$PID=='TGD0734',]
#Get the 2.5, 50, and 97.5 centiles for age 2 to 7, for plotting
cent<-centilesLMS(seq(2,7,0.1),"Female",Tsimane.Height,cent=c(0.025,0.5,0.975),xname="Age")
plot(Height~Age,data=ind,ylim=range(cent[,2:4]),xlim=c(2,7),pch=19,main="Height growth for TGD0734")
lines(cent$Age,cent$'0.5',col="red",lty=1)
lines(cent$Age,cent$'0.025',col="red",lty=2)
lines(cent$Age,cent$'0.975',col="red",lty=2)

## ----eval=FALSE----------------------------------------------------------
#  ?localgrowth
#  ?growthRef
#  ?centilesLMS
#  ?ZfromLMS
#  ?TsimaneData

