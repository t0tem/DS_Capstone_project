# in this script I'm just tinkering around with some examples of text mining I found
# on the Web to undestand (practically) how it works

# credits to: Philip Murphy, PhD 
#"https://rstudio-pubs-static.s3.amazonaws.com/265713_cbef910aee7642dc8b62996e38d2825d.html"

Needed <- c("tm", "SnowballCC", "RColorBrewer", "ggplot2", "wordcloud", "biclust", 
            "cluster", "igraph", "fpc")
install.packages(Needed, dependencies = TRUE)

install.packages("Rcampdf", repos = "http://datacube.wu.ac.at/", type = "source")

#Loading Texts
cname <- file.path(getwd(),"data", "texts")   
cname   
dir(cname)  

library(tm)
docs <- VCorpus(DirSource(cname, encoding = "UTF-8"))   

summary(docs)   
inspect(docs[[1]])
#writeLines(as.character(docs[1]))

###################
#Preprocessing
##################


#Removing punctuation:
docs <- tm_map(docs, removePunctuation)
inspect(docs[[1]])


#and special characters. removing with one regexp
docs <- tm_map(docs, 
               content_transformer(function(x) gsub(pattern = "[/@\\|\u2028]", 
                                                    replacement = " ", 
                                                    x)))
inspect(docs[[1]])


#for (j in seq(docs)) {
#    docs[[j]] <- gsub("/", " ", docs[[j]])
#    docs[[j]] <- gsub("@", " ", docs[[j]])
#    docs[[j]] <- gsub("\\|", " ", docs[[j]])
#    docs[[j]] <- PlainTextDocument(
#        gsub("\u2028", " ", docs[[j]])
#        )# This is an ascii character that did not translate, so it had to be removed.
#    
#}
#inspect(docs[[2]]) #doesn't work any more as docs[[x]] is a "character" now, not "PlainTextDocument"


#Removing numbers
docs <- tm_map(docs, removeNumbers)


#Converting to lowercase
docs <- tm_map(docs, content_transformer(tolower))



#Removing “stopwords” (common words)
docs <- tm_map(docs, removeWords, stopwords("english"))


#Removing particular words:
docs <- tm_map(docs, removeWords, c("syllogism", "tautology"))   



#Combining words that should stay together
#for (j in seq(docs))
#{
#    docs[[j]] <- gsub("fake news", "fake_news", docs[[j]])
#    docs[[j]] <- gsub("inner city", "inner-city", docs[[j]])
#    docs[[j]] <- gsub("politically correct", "politically_correct", docs[[j]])
#}


docs <- tm_map(docs, 
               content_transformer(function(x) gsub(pattern = "fake news", 
                                                    replacement = "fake_news", 
                                                    x)))

docs <- tm_map(docs, 
               content_transformer(function(x) gsub(pattern = "inner city", 
                                                    replacement = "inner-city", 
                                                    x)))

docs <- tm_map(docs, 
               content_transformer(function(x) gsub(pattern = "politically correct", 
                                                    replacement = "politically_correct", 
                                                    x)))

#inspect(docs[[1]])


#Removing common word endings (e.g., “ing”, “es”, “s”) - Stemming

docs_st <- tm_map(docs, stemDocument)   
#docs_st <- tm_map(docs_st, PlainTextDocument)
inspect(docs_st[[1]]) # Check to see if it worked.

#add common endings to improve intrepretability.
# This appears not to be working right now. You are welcome to try it, but there are numerous reports of 
#   the stemCompletion function not being currently operational.
# Note: This code was not run for this particular example either.
#   Read it as a potential how-to.
#docs_stc <- tm_map(docs_st, stemCompletion, dictionary = DocsCopy, lazy=TRUE)
#docs_stc <- tm_map(docs_stc, PlainTextDocument)
#inspect(docs_stc[[1]])

#Stripping unnecesary whitespace from your documents:
docs <- tm_map(docs, stripWhitespace)
inspect(docs[[1]])

#Be sure to use the following script once you have completed preprocessing.
#This tells R to treat your preprocessed documents as text documents.
#docs <- tm_map(docs, PlainTextDocument)

##################
##Stage the Data
##################

dtm <- DocumentTermMatrix(docs)   
dtm   
dim(dtm)

inspect(dtm[1:5, 1:20])


#########################
## Explore your data
#########################

freq <- colSums(as.matrix(dtm))   
length(freq)
ord <- order(freq)   

#export the matrix to Excel
#m <- as.matrix(dtm)   
#dim(m)
#write.csv(m, file="DocumentTermMatrix.csv")  


##############
## Focus
##############

#removing sparse terms:   
dtms <- removeSparseTerms(dtm, 0.2) # This makes a matrix that is 20% empty space, maximum.   
dtms
    

#Word Frequency

#1
freq <- colSums(as.matrix(dtm))
head(table(freq), 20) 
#tail(table(freq), 20)

#2
freq <- colSums(as.matrix(dtms))   
freq   

#3
freq <- sort(colSums(as.matrix(dtm)), decreasing=TRUE)   
head(freq, 14)   

#4
findFreqTerms(dtm, lowfreq=50)

#5
wf <- data.frame(word=names(freq), freq=freq)   
head(wf)


##########################
## Plot Word Frequencies
##########################

library(ggplot2)
p <- ggplot(subset(wf, freq>50), aes(x = reorder(word, -freq), y = freq)) +
    geom_bar(stat = "identity") + 
    theme(axis.text.x=element_text(angle=45, hjust=1))
p 



##############################
## Relationships Between Terms
##############################

findAssocs(dtm, c("country" , "american"), corlimit=0.85) 
# specifying a correlation limit of 0.85

findAssocs(dtms, "think", corlimit=0.70) 


##############
## Word Clouds
##############

library(wordcloud)
set.seed(123)   
wordcloud(names(freq), freq, min.freq=100)

set.seed(123)   
wordcloud(names(freq), freq, max.words=100) 


set.seed(123)   
wordcloud(names(freq), freq, min.freq=20, scale=c(5, .1), 
          colors=brewer.pal(6, "Dark2"))  


set.seed(123)   
dark2 <- brewer.pal(6, "Dark2")   
wordcloud(names(freq), freq, max.words=100, rot.per=0.2, colors=dark2)  

################################
# Clustering by Term Similarity
################################

#To do this well, you should always first remove a lot of the uninteresting or infrequent words. 
#you can remove these with the following code.

dtmss <- removeSparseTerms(dtm, 0.15) 
# This makes a matrix that is only 15% empty space, maximum.   
dtmss

#Hierarchal Clustering

#First calculate distance between words & then cluster them according to similarity.
library(cluster)   
d <- dist(t(dtmss), method="euclidian")   
fit <- hclust(d=d, method="complete")   # for a different look: method="ward.D"
fit  

plot(fit, hang=-1)

#let's look at 6 clusters level 
plot.new()
plot(fit, hang=-1)
groups <- cutree(fit, k=6)   # "k=" defines the number of clusters you are using   
rect.hclust(fit, k=6, border="red") # draw dendogram with red borders around the 6 clusters   

###############################
# K-means clustering
###############################

library(fpc)   
d <- dist(t(dtmss), method="euclidian")   
kfit <- kmeans(d, 2)   
clusplot(as.matrix(d), kfit$cluster, color=T, shade=T, labels=2, lines=0)
