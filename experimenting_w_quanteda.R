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

# Document feature matrix
myDfm <-  dfm(corp)
myDfm[, 1:5]


myStemMat <- dfm(corp, remove = stopwords("english"), stem = TRUE, remove_punct = TRUE)
myStemMat[, 1:5]

myStemMat.big <- dfm(corp.big, remove = stopwords("english"), stem = TRUE, remove_punct = TRUE)
myStemMat.big[, 1:5]
myStemMat.big
topfeatures(myStemMat.big, 20)

set.seed(100)
textplot_wordcloud(myStemMat.big, min.freq = 2000, random.order = FALSE,
                   rot.per = .25, 
                   colors = RColorBrewer::brewer.pal(8,"Dark2"))




