# script for building n-grams from the whole files

##########
# STEP 1 #
##########

library(quanteda)
library(data.table)

setwd("data")
load("full RData/norm_text.RData")

#creating corpus
system.time(corp <- corpus(norm_text))

#tokenizing
system.time(tok <- tokens(corp, what = "word"))
save(tok, file = "full RData/tok.RData")


rm(list=ls())
##   END   ##
## RESTART ##



##########
# STEP 2 #
##########

source("pre_step.R")

#DFMs
system.time(dfm1 <- build.dfm(1L))
system.time(dfm2 <- build.dfm(2L))

#DTs
system.time(dt1 <- build.dt(dfm1))
system.time(dt2 <- build.dt(dfm2))

#save
save(dt1, file = "full RData/dt1.RData")
save(dt2, file = "full RData/dt2.RData")

rm(list=ls())
##   END   ##
## RESTART ##



##########
# STEP 3 #
##########

source("pre_step.R")

#DFMs
system.time(dfm3 <- build.dfm(3L))

#DTs
system.time(dt3 <- build.dt(dfm3))

#save
save(dt3, file = "full RData/dt3.RData")

rm(list=ls())
##   END   ##
## RESTART ##



##########
# STEP 4 #
##########

source("pre_step.R")

#DFMs
system.time(dfm4 <- build.dfm(4L))

#DTs
system.time(dt4 <- build.dt(dfm4))

#save
save(dt4, file = "full RData/dt4.RData")

rm(list=ls())
##   END   ##
## RESTART ##



##########
# STEP 5 #
##########

source("pre_step.R")

#DFMs
system.time(dfm5 <- build.dfm(5L))

#DTs
system.time(dt5 <- build.dt(dfm5))

#save
save(dt5, file = "full RData/dt5.RData")

rm(list=ls())
##   END   ##
## RESTART ##


#lapply(list(dfm1, dfm2, dfm3, dfm4, dfm5, dfm6), topfeatures)

