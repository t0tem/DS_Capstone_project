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


for (i in 1:3) {
    con <- file(extrF[i], open = "r")
    data <- c(data, list(readLines(con, encoding = "UTF-8")))
    close(con)
    names(data)[i] <- source[i]
}


blogs <- readLines(extrF[1], encoding = "UTF-8")
news <- readLines(extrF[2], encoding = "UTF-8")
twitter <- readLines(extrF[3], encoding = "UTF-8")



#sampling----

#closeAllConnections()
#showConnections(all = TRUE)


n <- 50000 #sample size
prob <- 0.1 #probability for biased coin flip


#option 1 - this takes from diff parts of file, doesn't load the whole file, but takes around 100sec
con <- file(extrF, open = "r")
smpl <- character(0) #initiating sample
set.seed(456789)
pts <- proc.time()
while (length(smpl) < n & 
       length(cur.line <- readLines(con, 1))) {
    #we flip a biased coin to decide do we take the line to sample or not
    if(rbinom(1,1,prob)) { 
        smpl <- c(smpl, cur.line)
    }
}
proc.time() - pts
close(con)

#option 2 - this takes from diff parts of file, takes only 6-13sec, but loads the whole file (>300mb)
con <- file(extrF, open = "r")
pts <- proc.time()
all <- readLines(con)
set.seed(456789)
smpl <- sample(all, n)
proc.time() - pts
close(con)
#rm(all)

#option 3 - this doesn't load the whole file, takes no time, but takes from beginning of the file
con <- file(extrF, open = "r")
pts <- proc.time()
smpl <- readLines(con, n)
proc.time() - pts
close(con)



####################################
# Creating Corpus and preprocessing
####################################

library(tm)
docs <- VCorpus(VectorSource(smpl))
summary(docs) 
inspect(docs[[1]])

docs <- tm_map(docs, removePunctuation)   
docs <- tm_map(docs, removeNumbers)   
docs <- tm_map(docs, content_transformer(tolower))
docs <- tm_map(docs, removeWords, stopwords("english"))  
docs <- tm_map(docs, stripWhitespace)
docs <- tm_map(docs, PlainTextDocument)


##################################
# Staging & exploring
##################################

dtm <- DocumentTermMatrix(docs)
dtm

findFreqTerms(dtm, lowfreq=1000)


freq <- colSums(as.matrix(dtm)) #memory overload...

