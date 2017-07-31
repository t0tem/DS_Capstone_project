#loading libraries

library(stringr)
library(tm)
library(ggplot2)
library(wordcloud)
library(cluster)   
library(fpc)  


#downloading dataset
if(!dir.exists("data")) {dir.create("data")}
setwd("data")

if (!file.exists("Coursera-SwiftKey.zip")) {
    link <- "https://d396qusza40orc.cloudfront.net/dsscapstone/dataset/Coursera-SwiftKey.zip"
    #print("hi")
    download.file(link, "Coursera-SwiftKey.zip")
}


#making the paths
archv <- "Coursera-SwiftKey.zip"
locale <- c("en_US", "ru-RU", "de_DE", "fi_FI")
source <- c("blogs", "news", "twitter")

#final path to txt inside zip
extrF <- paste0(locale[1], ".", source, ".txt")
path <- paste0("final/",locale[1], "/", extrF)

#unzipping
if (!file.exists(extrF[1])) {
    unzip(archv, files = c(path), junkpaths = TRUE)
}

###################
# Loading the data
###################

# 1st attempt to read files through usual connection failed at en_US.news.txt
# the reason is that the file has ASCII Substitute Character somewhere in the middle
# this character (decimal 26 or 0x1A) corresponds to Ctrl+Z in Windows (see Wikipedia)
# so readLines truncates the file at this character
# solution found on StackOverflow 
# https://stackoverflow.com/questions/15874619/reading-in-a-text-file-with-a-sub-1a-control-z-character-in-r-on-windows
# in opening connection with "rb" (binary mode)

con <- file(extrF[1], open = "rb")
blogs <- readLines(extrF[1], encoding = "UTF-8", skipNul = TRUE)
close(con)

con <- file(extrF[2], open = "rb")
news <- readLines(con, encoding = "UTF-8", skipNul = TRUE)
close(con)

con <- file(extrF[3], open = "rb")
twitter <- readLines(con, encoding = "UTF-8", skipNul = TRUE)
close(con)

#news[77259]

str_replace_all(blogs[591457:591459], "[^[:graph:]]", " ")



## Sampling the files
sampleSize <- 50000
set.seed(456789)
sampleN <- sample(news, sampleSize)
sampleB <- sample(blogs, sampleSize)
sampleT <- sample(twitter, sampleSize)

## Cleaning the samples from non-printable characters 
#https://stackoverflow.com/questions/9637278/r-tm-package-invalid-input-in-utf8towcs
ptm <- proc.time()
sampleN <- str_replace_all(sampleN, "[^[:graph:]]", " ")
sampleB <- str_replace_all(sampleB, "[^[:graph:]]", " ")
sampleT <- str_replace_all(sampleT, "[^[:graph:]]", " ")
proc.time() - ptm

## Storing the samples in the files 
if(!dir.exists("samples")) {dir.create("samples")}
write(sampleB, file = file.path("samples", "Blogs.txt"))
write(sampleN, file = file.path("samples", "News.txt"))
write(sampleT, file = file.path("samples", "Twitter.txt"))


####################################
# Creating Corpus and preprocessing
####################################

docs <- VCorpus(DirSource("samples", encoding = "UTF-8"),
                readerControl = list(language = "en"))
d.init <- docs #saving initial state of Corpus
docs <- d.init

names(docs)
inspect(docs)
docs[[1]][[1]][5]


docs <- tm_map(docs, content_transformer(tolower))
docs <- tm_map(docs, removeWords, stopwords("english"))  
docs <- tm_map(docs, removePunctuation)   
docs <- tm_map(docs, removeNumbers)   
docs <- tm_map(docs, stripWhitespace)
d <- docs #saving copy
docs <- tm_map(docs, stemDocument)


if( !class(docs[[1]])[1] == "PlainTextDocument" ) {
    docs <- tm_map(docs, PlainTextDocument)
    #this one truncates the IDs of documents, so we use it only if necessary
}



##################################
# Staging & exploring
##################################

tdm <- TermDocumentMatrix(docs)
tdm
inspect(tdm[2000:2020, 1:3])

freq <- sort(rowSums(as.matrix(tdm)), decreasing=TRUE)   
head(freq, 14)

wf <- data.frame(word=names(freq), freq=freq)   
head(wf)

##########################
## Plot Word Frequencies
##########################


p <- ggplot(subset(wf, freq > 5000), aes(x = reorder(word, -freq), y = freq)) +
    geom_bar(stat = "identity") + 
    theme(axis.text.x=element_text(angle=45, hjust=1))
p 

##############################
## Relationships Between Terms
##############################

#findAssocs(tdm, c("said" , "will"), corlimit=0.85) 


##############
## Word Clouds
##############

set.seed(123)   
wordcloud(names(freq), freq, min.freq=2000, scale=c(5, .1), rot.per=0.3,
          colors=brewer.pal(6, "Dark2"))  


################################
# Clustering by Term Similarity
################################

tdms <- removeSparseTerms(tdm, 0.15) 
tdms

#Hierarchal Clustering

#First calculate distance between words & then cluster them according to similarity.
d <- dist(tdms, method="euclidian")   
fit <- hclust(d=d, method="complete")   # for a different look: method="ward.D"
fit  

#let's look at 6 clusters level 
plot(fit, hang=-1)
groups <- cutree(fit, k=6)   # "k=" defines the number of clusters you are using   
rect.hclust(fit, k=6, border="red") # draw dendogram with red borders around the 6 clusters   

###############################
# K-means clustering
###############################

kfit <- kmeans(d, 2)   
clusplot(as.matrix(d), kfit$cluster, color=T, shade=T, labels=2, lines=0)
