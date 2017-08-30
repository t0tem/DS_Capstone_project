# script for building n-grams from the whole files
# build_lexicon.R should be run first

library(readtext)
library(quanteda)
library(data.table)

setwd("data")
load("full RData/corp.RData")

#tokenizing
system.time(
    tok <- 
        tokens_tolower(
            tokens(corp, what = "word", remove_numbers = TRUE,
                   remove_punct = TRUE, remove_symbols = TRUE, 
                   remove_separators = TRUE, remove_twitter = TRUE, 
                   remove_hyphens = TRUE, remove_url = TRUE)))

#building DFMs for tokens
build.dfm <- function(n) {
    dfm(tokens_ngrams(tok, n = n), tolower = FALSE)
}


system.time(dfm1 <- build.dfm(1L))
topfeatures(dfm1)

#lapply(list(dfm1, dfm2, dfm3, dfm4, dfm5, dfm6), topfeatures)


#building DTs with frequencies
build.dt <- function(dfm) {
    dt <- data.table(ngram = featnames(dfm), count = colSums(dfm))
    dt <- dt[order(-count)]
    dt
}

system.time(dt1 <- build.dt(dfm1))
system.time(dt2 <- build.dt(dfm2))
system.time(dt3 <- build.dt(dfm3))
system.time(dt4 <- build.dt(dfm4))
system.time(dt5 <- build.dt(dfm5))
system.time(dt6 <- build.dt(dfm6))

save(dt1, file = "full RData/dt1.RData")
save(dt2, file = "full RData/dt2.RData")
save(dt3, file = "full RData/dt3.RData")
save(dt4, file = "full RData/dt4.RData")
save(dt5, file = "full RData/dt5.RData")
save(dt6, file = "full RData/dt6.RData")

