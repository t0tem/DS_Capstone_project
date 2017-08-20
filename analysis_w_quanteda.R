library(readtext)
library(quanteda)
library(data.table)
library(stringr)
library(stringi)

setwd("data")

read_file <- function(path) {
    con <- file(path, open = "rb")
    data <- readLines(con, encoding = "UTF-8", skipNul = TRUE)
    close(con)
    data
}

blogs <- read_file("en_US.blogs.txt")
news <- read_file("en_US.news.txt")
twitter <- read_file("en_US.twitter.txt")

## Sampling the files
sampleSize <- 100000
set.seed(456789)
sampleN <- sample(news, sampleSize)
sampleB <- sample(blogs, sampleSize)
sampleT <- sample(twitter, sampleSize)


## cleaning samples from found issues (see 'issues_in_text.R')
sampleN <- iconv(sampleN, from = "UTF-8", sub = "")
sampleB <- iconv(sampleB, from = "UTF-8", sub = "")
sampleT <- iconv(sampleT, from = "UTF-8", sub = "")


## Storing the samples in the files 
if(!dir.exists("samples")) {dir.create("samples")}

saveSmpl <- function(data, fname) {
    con <- file(file.path("samples", fname), encoding = "UTF-8")
    write(data, file = con)
    close(con)
}

saveSmpl(sampleB, "Blogs.txt")
saveSmpl(sampleN, "News.txt")
saveSmpl(sampleT, "Twitter.txt")


#corpus creation
corp <- corpus(readtext("samples/*.txt", encoding = "UTF-8"))

sentences <- tokens(corp, what = "sentence", remove_separators = FALSE, verbose = TRUE)

sentences <- as.character(sentences)

#save(sentences, file = 'sentences.RData')
load('sentences.Rdata')

#n-grams creation
n1 <- tokens(sentences, what = "word", remove_numbers = TRUE,
                remove_punct = TRUE, remove_symbols = TRUE, remove_separators = TRUE,
                remove_twitter = TRUE, remove_hyphens = TRUE, remove_url = TRUE,
                ngrams = 1L, verbose = TRUE)

n1 <- tokens_tolower(n1)
#n1 <- tokens_remove(n1, stopwords("english"))
#n1 <- tokens_wordstem(n1, language = "english")

n2 <- tokens_ngrams(n1, n = 2L, concatenator = " ")
n3 <- tokens_ngrams(n1, n = 3L, concatenator = " ")
n4 <- tokens_ngrams(n1, n = 4L, concatenator = " ")

#data-features matrices creation
d1 <- dfm(n1, tolower = FALSE)
d2 <- dfm(n2, tolower = FALSE)
d3 <- dfm(n3, tolower = FALSE)
d4 <- dfm(n4, tolower = FALSE)

#checking top features
topfeatures(d1, 20)
topfeatures(d2, 20)
topfeatures(d3, 20)
topfeatures(d4, 20)

#there is 'cinco de mayo' among popular 3-grams, don't know what's that,
#let's check in context (through original sentences)
ind0 <- sapply(n3, function(x) {"cinco de mayo" %in% x})
head(sentences[ind0]) #ok, now I know :) thanks, Wikipedia

#let's check smth else
ind1 <- sapply(n3, function(x) {"st loui counti" %in% x})
head(sentences[ind1])

ind2 <- sapply(n4, function(x) {"associ programm design provid" %in% x})
head(sentences[ind2]) #surprisingly many similar texts about Amazon from diff blogs on *.wordpress.com

ind3 <- sapply(n4, function(x) {"amazon.d amazon.fr amazon.it amazon." %in% x})
head(sentences[ind3])


#storing frequencies in data.tables
dt1 <- data.table(ngram = featnames(d1), count = colSums(d1))
head(dt1[order(-count)], 20)

dt2 <- data.table(ngram = featnames(d2), count = colSums(d2))
head(dt2[order(-count)], 20)

dt3 <- data.table(ngram = featnames(d3), count = colSums(d3))
head(dt3[order(-count)], 20)

dt4 <- data.table(ngram = featnames(d4), count = colSums(d4))
head(dt4[order(-count)], 30)


#making splitted DTs
dt4.orig <- copy(dt4)

dt4[, c("w1", "w2", "w3", "w4") := 
        tstrsplit(ngram, " ", fixed = TRUE)][, ngram := NULL]

    #change order of fields, sorting
setcolorder(dt4, c(2:5, 1))
dt4 <- dt4[order(-count)]

save(dt4, file = "dt4.RData")
load("dt4.RData")


#testing the simpliest model of just subsetting DT by last 3 input words
string <- "I go to the gym to "
v1 <- "the"
v2 <- "gym"
v3 <- "to"

dt4[w1 == v1][w2 == v2][w3 == v3]  #[1, w4]

