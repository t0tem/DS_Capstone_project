#script for building lexicon
#the idea is to use the trick from Stanford NLP lecture
#https://youtu.be/-aMYz1tMfPg?t=4m24s

library(readtext)
library(quanteda)
library(data.table)

setwd("data")

#function to read files in binary mode skipping NULLs 
read_file <- function(path) {
    con <- file(path, open = "rb")
    data <- readLines(con, encoding = "UTF-8", skipNul = TRUE)
    close(con)
    data
}

bigtext <- c(read_file("en_US.blogs.txt"),
             read_file("en_US.news.txt"),
             read_file("en_US.twitter.txt"))

bigtext <- iconv(bigtext, from = "UTF-8", sub = "")

#creating corpus
system.time(corp <- corpus(bigtext))
#save(corp, file = "full RData/corp.RData")
#load("full RData/corp.RData")

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

#building DTs with frequencies
build.dt <- function(dfm) {
    dt <- data.table(ngram = featnames(dfm), count = colSums(dfm))
    dt <- dt[order(-count)]
    dt
}

system.time(dt1 <- build.dt(dfm1))

#building Lexicon
Lexicon <- dt1[count > 3][,ngram]


