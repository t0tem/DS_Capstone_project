#initiating a folder
if(!dir.exists("data")) {dir.create("data")}
setwd("data")

# initiating a log file
sink("log.txt", append = TRUE, split = TRUE)
"Analysis started at"
Sys.time()


#loading libraries
library(stringr)
library(tm)
library(ggplot2)
library(wordcloud)
library(cluster)   
library(fpc)  

#downloading dataset
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

saveSmpl <- function(data, fname) {
    con <- file(file.path("samples", fname), encoding = "UTF-8")
    write(data, file = con)
    close(con)
}

saveSmpl(sampleB, "Blogs.txt")
saveSmpl(sampleN, "News.txt")
saveSmpl(sampleT, "Twitter.txt")


####################################
# Creating Corpus and preprocessing
####################################

docs <- VCorpus(DirSource("samples", encoding = "UTF-8"),
                readerControl = list(language = "en"))
d.init <- docs #saving initial state of Corpus
#docs <- d.init

docs <- tm_map(docs, content_transformer(tolower))
docs <- tm_map(docs, removeWords, stopwords("english"))  
docs <- tm_map(docs, removePunctuation)   
docs <- tm_map(docs, removeNumbers)   
docs <- tm_map(docs, stripWhitespace)
d <- docs #saving copy of non-stemmed
docs <- tm_map(docs, stemDocument)

if( !class(docs[[1]])[1] == "PlainTextDocument" ) {
    docs <- tm_map(docs, PlainTextDocument)
    #this one truncates the IDs of documents, so we use it only if necessary
}

##################################
# Staging & exploring
##################################

#creating TDM

ptm <- proc.time()
tdm <- TermDocumentMatrix(docs)
paste0("TDM with samples size ", 
       sampleSize,
       " took ",
       round((proc.time() - ptm)[1], 2),
       " sec")
tdm
inspect(tdm[2000:2020, 1:3])

#words by frequency
freq <- sort(rowSums(as.matrix(tdm)), decreasing=TRUE)   

freq.b <- sort(as.matrix(tdm)[,1], decreasing=TRUE) #only blogs
freq.n <- sort(as.matrix(tdm)[,2], decreasing=TRUE) #only news
freq.t <- sort(as.matrix(tdm)[,3], decreasing=TRUE) #only twitter

##########################
## Plot Word Frequencies
##########################

#function for plotting
plot_w_freq <- function(data, min.freq, title) {
    
    wf <- data.frame(word = names(data), 
                     freq = data)
    
    ggplot(subset(wf, freq > min.freq), 
           aes(x = reorder(word, freq, function(x){x*-1}), 
               y = freq)) +
        geom_bar(stat = "identity") + 
        theme(axis.text.x = element_text(angle = 90, vjust = 0),
              plot.title = element_text(hjust = 0.5),
              axis.title.x = element_blank()) +
        ggtitle(title) + ylab("Frequency")
}


plot_w_freq(freq, 5000, "Global most frequent words")
plot_w_freq(freq.b, 2000, "Most frequent words in blogs")
plot_w_freq(freq.n, 1700, "Most frequent words in news")
plot_w_freq(freq.t, 1300, "Most frequent words in Twitter")

###############
## Word Clouds
###############

set.seed(123)   
wordcloud(names(freq), freq, min.freq=2000, scale=c(5, .1), rot.per=0.3,
          colors=brewer.pal(6, "Dark2")) #all

wordcloud(names(freq.b), freq.b, min.freq=1000, scale=c(4, .1), rot.per=0.3,
          colors=brewer.pal(6, "Dark2")) #blogs

wordcloud(names(freq.n), freq.n, min.freq=700, scale=c(5, .1), rot.per=0.3,
          colors=brewer.pal(6, "Dark2")) #news

wordcloud(names(freq.t), freq.t, min.freq=300, scale=c(4, .1), rot.per=0.3,
          colors=brewer.pal(6, "Dark2")) #twitter

#closing the log file
sink()
