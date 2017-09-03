#setting directories, loading libraries and functions
setwd("~/R/Coursera/DS_Capstone_project/")
source("functions.R")
setwd("data")

library(quanteda)

##########
# STEP 0 #
##########

#reading files
bigtext <- c(read_file("en_US.blogs.txt"),
             read_file("en_US.news.txt"),
             read_file("en_US.twitter.txt"))

bigtext <- iconv(bigtext, to = "ASCII", sub = "")


##########
# STEP 1 #
##########

#splitting into sentences
#set.seed(100)
#sample <- sample(bigtext, length(bigtext)*0.5)

system.time(
    sentences <- tokens(bigtext, what = "sentence", verbose = TRUE)
)

sentences <- as.character(sentences)
save(sentences, file = "makeitsimple/sentences.Rda")



#tokenizing
system.time(
    tok <- 
        tokens_tolower(
            tokens(sentences, what = "word", remove_numbers = TRUE,
                   remove_punct = TRUE, remove_symbols = TRUE, 
                   remove_twitter = TRUE, remove_hyphens = TRUE, remove_url = TRUE))
)

save(tok, file = "makeitsimple/tok.Rda")

rm(list=ls())
##   END   ##
## RESTART ##


##########
# STEP 2 #
##########

source("../makeitsimple_pre_step.R")

#DFMs
system.time(dfm1 <- build.dfm(1L))
system.time(dfm2 <- build.dfm(2L))
topfeatures(dfm1)

#DTs
#system.time(dt1 <- build.dt(dfm1))
system.time(dt2 <- build.dt(dfm2))

#system.time(dt1 <- get_scores(dt1))
system.time(dt2 <- get_scores(dt2))

#save
#save(dt1, file = "makeitsimple/dt1.Rda")
save(dt2, file = "makeitsimple/dt2.Rda")

rm(list=ls())
##   END   ##
## RESTART ##


##########
# STEP 3 #
##########

source("../makeitsimple_pre_step.R")

#DFMs
system.time(dfm3 <- build.dfm(3L))

#DTs
system.time(dt3 <- build.dt(dfm3))

system.time(dt3 <- get_scores(dt3))

#save
save(dt3, file = "makeitsimple/dt3.Rda")

rm(list=ls())
##   END   ##
## RESTART ##


##########
# STEP 4 #
##########

source("../makeitsimple_pre_step.R")

#DFMs
system.time(dfm4 <- build.dfm(4L))

#DTs
system.time(dt4 <- build.dt(dfm4))

system.time(dt4 <- get_scores(dt4))

#save
save(dt4, file = "makeitsimple/dt4.Rda")

rm(list=ls())
##   END   ##
## RESTART ##


##########
# STEP 5 #
##########

source("../makeitsimple_pre_step.R")

#DFMs
system.time(dfm5 <- build.dfm(5L))

#DTs
system.time(dt5 <- build.dt(dfm5))

system.time(dt5 <- get_scores(dt5))

#save
save(dt5, file = "makeitsimple/dt5.Rda")

rm(list=ls())
##   END   ##
## RESTART ##




#remove profanity from predictions
setwd("..")
profanity <- readLines("badwords.txt")

dt5 <- dt5[!prediction %in% profanity]
dt4 <- dt4[!prediction %in% profanity]
dt3 <- dt3[!prediction %in% profanity]
dt2 <- dt2[!prediction %in% profanity]


#truncating DTs
system.time(dt5 <- truncate.dt(dt5))
system.time(dt4 <- truncate.dt(dt4))
system.time(dt3 <- truncate.dt(dt3))
system.time(dt2 <- truncate.dt(dt2))

