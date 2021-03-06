# script for building Milestone report


library(readtext)
library(quanteda)
library(data.table)
library(stringr)
library(stringi)
library(dplyr)
library(ggplot2)
library(wordcloud)

setwd("data")

#function to read files in binary mode skipping NULLs 
read_file <- function(path) {
    con <- file(path, open = "rb")
    data <- readLines(con, encoding = "UTF-8", skipNul = TRUE)
    close(con)
    data
}

blogs <- read_file("en_US.blogs.txt")
news <- read_file("en_US.news.txt")
twitter <- read_file("en_US.twitter.txt")


# Building files summary --------


#file sizes
f.sizes <- sapply(list(blogs, news, twitter), 
                  function(x) {format(object.size(x), "Mb")})

#lines count
total.lines <- c(length(blogs),
                 length(news),
                 length(twitter))



#words count
total.words.blogs <- sum(str_count(blogs, "[[:alpha:]]+"))
total.words.news <- sum(str_count(news, "[[:alpha:]]+"))
total.words.twitter <- sum(str_count(twitter, "[[:alpha:]]+"))

total.words <- c(total.words.blogs,
                 total.words.news,
                 total.words.twitter)

#word characters count
total.char.blogs <- sum(str_count(blogs, "[[:alpha:]]"))
total.char.news <- sum(str_count(news, "[[:alpha:]]"))
total.char.twitter <- sum(str_count(twitter, "[[:alpha:]]"))

total.char <- c(total.char.blogs,
                total.char.news,
                total.char.twitter)

#average character per word
av.char <- round(total.char / total.words, 1)

#Max characters per line
max.char <- c(max(stri_length(blogs)),
              max(stri_length(news)),
              max(stri_length(twitter)))

#summary table
summary.table <- data.frame(f.sizes, total.lines, max.char, total.words, av.char, 
                            row.names = c("en_US.blogs.txt", 
                                          "en_US.news.txt",
                                          "en_US.twitter.txt")) %>%
    rename("File size" = f.sizes,
           "Total lines" = total.lines,
           "Max. characters per line" = max.char,
           "Total words" = total.words,
           "Av. characters per word" = av.char)

#saving table to be used in milestone report (R markdown)
save(summary.table, file = 'summary.table.RData')

# end of building summary----

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

# Saving samples ----

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

# end of saving samples ----

#corpus creation
corp <- corpus(readtext("samples/*.txt", encoding = "UTF-8"))

#save(corp, file = "corp.RData")
#load("corp.RData")

ptm <- proc.time()
sentences <- tokens(corp, what = "sentence", remove_separators = FALSE, verbose = TRUE)
(sentences.time <- proc.time() - ptm)

sentences <- as.character(sentences)

#save(sentences, file = 'sentences.RData')
#load('sentences.Rdata')


#n-grams creation
ptm <- proc.time()
n1 <- tokens(sentences, what = "word", remove_numbers = TRUE,
                remove_punct = TRUE, remove_symbols = TRUE, remove_separators = TRUE,
                remove_twitter = TRUE, remove_hyphens = TRUE, remove_url = TRUE,
                ngrams = 1L, verbose = TRUE)
(n1.time <- proc.time() - ptm)

n1 <- tokens_tolower(n1)
n1 <- tokens_remove(n1, stopwords("english"))
n1 <- tokens_wordstem(n1, language = "english")

#save(n1, file = 'n1.RData')
#load('n1.Rdata')

n2 <- tokens_ngrams(n1, n = 2L, concatenator = " ")
#save(n2, file = 'n2.RData')
#load('n2.Rdata')

n3 <- tokens_ngrams(n1, n = 3L, concatenator = " ")
#save(n3, file = 'n3.RData')
#load('n3.Rdata')

n4 <- tokens_ngrams(n1, n = 4L, concatenator = " ")
#save(n4, file = 'n4.RData')
#load('n4.Rdata')

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
dt2 <- data.table(ngram = featnames(d2), count = colSums(d2))
dt3 <- data.table(ngram = featnames(d3), count = colSums(d3))
dt4 <- data.table(ngram = featnames(d4), count = colSums(d4))


#truncating DTs for further saving
dt1 <- head(dt1[order(-count)], 200)
dt2 <- head(dt2[order(-count)], 200)
dt3 <- head(dt3[order(-count)], 200)
dt4 <- head(dt4[order(-count)], 200)

#saving data.tables to be used in milestone report (R markdown)
save(list = c("dt1", "dt2", "dt3", "dt4"), file = "dt.RData")


#plotting bars
plot_n_gram <- function(data, title) {
    ggplot(head(data, 30), aes(x = reorder(ngram, count), y = count)) +
        geom_col() + 
        theme(plot.title = element_text(hjust = 0.5),
              axis.title.x = element_blank()) +
        coord_flip() +
        ggtitle(title) + xlab(NULL)
}

plot_n_gram(dt1, "Most frequent unigrams")
plot_n_gram(dt2, "Most frequent bigrams")
plot_n_gram(dt3, "Most frequent trigrams")
plot_n_gram(dt4, "Most frequent four-grams")


#plotting wordclouds
plot_wcloud <- function(data, scale, n, title) {
    layout(matrix(c(1, 2), nrow = 2), heights = c(1, 30))
    par(mar = rep(0, 4))
    plot.new()
    text(x = 0.5, y = 0.5, title)
    
    wordcloud(words = data$ngram,
          freq = data$count, 
          colors = brewer.pal(6, "Dark2"), 
          scale = c(scale, 0.2),
          rot.per = 0.3,
          max.words = n,
          random.order = FALSE)
}

plot_wcloud(dt1, 5, 200, "Unigrams Word Cloud")
plot_wcloud(dt2, 4, 120, "Bigrams Word Cloud")
