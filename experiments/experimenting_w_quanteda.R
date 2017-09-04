library(data.table)

#install.packages("quanteda", dependencies = TRUE)
#install.packages("readtext")


library(readtext)
library(quanteda)

setwd("data")

#corpus creation
corp <- corpus(readtext("texts/*.txt"))
corp.big <- corpus(readtext("samples/*.txt"))
corp.huge <- corpus(readtext("txt/*.txt"))

tokenInfo <- summary(corp)

names(corp[[1]][[1]])

corp$documents$texts[1] #all text of 1 doc in 1 'cell' of data.frame (do not run)


# search by Key Word In Context
kwic(corp, "hate", valuetype = "regex")

head(docvars(corp))

metacorpus(corp)

#tokens
txt <- c(text1 = "This is $10 in 999 different ways,\n up and down; left and right!", 
         text2 = "@kenbenoit working: on #quanteda 2day\t4ever, http://textasdata.com?page=123.")
tokens(txt)

tokens(txt, remove_numbers = TRUE,  remove_punct = TRUE)
tokens(txt, remove_numbers = FALSE, remove_punct = FALSE, remove_separators = FALSE)

tokens("Great website: http://textasdata.com?page=123.", what = "character")
tokens("Great website: http://textasdata.com?page=123.", what = "character", 
       remove_separators = FALSE)

tokens(c("Kurt Vongeut said; only assholes use semi-colons.", 
         "Today is Thursday in Canberra:  It is yesterday in London.", 
         "En el caso de que no puedas ir con ellos, ¿quieres ir con nosotros?"), 
       what = "sentence")

# Document feature matrix
myDfm <-  dfm(corp)
myDfm[, 1:5]


myStemMat <- dfm(corp, remove = stopwords("english"), stem = TRUE, remove_punct = TRUE)
myStemMat[, 1:5]

myStemMat.big <- dfm(corp.big, remove = stopwords("english"), stem = TRUE, remove_punct = TRUE)
myStemMat.big[, 1:5]
myStemMat.big
topfeatures(myStemMat.big, 20)

#word cloud
set.seed(100)
textplot_wordcloud(myStemMat.big, min.freq = 2000, random.order = FALSE,
                   rot.per = .25, 
                   colors = RColorBrewer::brewer.pal(8,"Dark2"))


mydfm <- dfm(data_char_ukimmig2010, remove = stopwords("english"), remove_punct = TRUE)
mydfm
set.seed(100)
textplot_wordcloud(mydfm, min.freq = 6, random.order = FALSE,
                   rot.per = .25, 
                   colors = RColorBrewer::brewer.pal(8,"Dark2"))

byPartyDfm <- dfm(data_corpus_irishbudget2010, 
                  groups = "party", remove = c("will", stopwords("english")), remove_punct = TRUE)
sort(byPartyDfm)[, 1:10]


#Grouping words by dictionary or equivalence class

recentCorpus <- corpus_subset(data_corpus_inaugural, Year > 1991)

myDict <- dictionary(list(terror = c("terrorism", "terrorists", "threat"),
                          economy = c("jobs", "business", "grow", "work")))

byPresMat <- dfm(recentCorpus, dictionary = myDict)
byPresMat

#Similarities between texts
presDfm <- dfm(corpus_subset(data_corpus_inaugural, Year > 1980), 
               remove = stopwords("english"), stem = TRUE, remove_punct = TRUE)
obamaSimil <- textstat_simil(presDfm, c("2009-Obama" , "2013-Obama"), 
                             margin = "documents", method = "cosine")
obamaSimil

#plot a dendrogram, clustering presidents (doesn't work):

#package install
#devtools::install_github("kbenoit/quantedaData")
data(data_corpus_SOTU, package = "quantedaData")
presDfm <- dfm(corpus_subset(data_corpus_SOTU, Date > as.Date("1980-01-01")), 
               stem = TRUE, remove_punct = TRUE,
               remove = stopwords("english"))
presDfm <- dfm_trim(presDfm, min_count = 5, min_docfreq = 3)
# hierarchical clustering - get distances on normalized dfm
presDistMat <- textstat_dist(dfm_weight(presDfm, "relFreq"))
# hiarchical clustering the distance object
presCluster <- hclust(presDistMat)
# label with document names
presCluster$labels <- docnames(presDfm)
# plot as a dendrogram
plot(presCluster, xlab = "", sub = "", main = "Euclidean Distance on Normalized Token Frequency")
