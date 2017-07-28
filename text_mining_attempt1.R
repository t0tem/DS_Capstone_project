# in this script I'm just tinkering around with some examples of text mining I found
# on the Web to undestand (practically) how it works

# credits to: Philip Murphy, PhD "https://rstudio-pubs-static.s3.amazonaws.com/265713_cbef910aee7642dc8b62996e38d2825d.html"

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

#Preprocessing

#Removing punctuation:
docs <- tm_map(docs, removePunctuation)
inspect(docs[[2]])
# writeLines(as.character(docs[1])) # Check to see if it worked.
# The 'writeLines()' function is commented out to save space.

#and special characters
#docs <- tm_map(docs, 
#               content_transformer(function(x) gsub(pattern = "free", 
#                                                    replacement = "freedom", 
#                                                    x)))
# написать рег экспр чтобы одной строчкой

for (j in seq(docs)) {
    docs[[j]] <- gsub("/", " ", docs[[j]])
    docs[[j]] <- gsub("@", " ", docs[[j]])
    docs[[j]] <- gsub("\\|", " ", docs[[j]])
    docs[[j]] <- PlainTextDocument(
        gsub("\u2028", " ", docs[[j]])
        )# This is an ascii character that did not translate, so it had to be removed.
    
}
writeLines(as.character(docs[1]))
#inspect(docs[[2]]) #doesn't work any more as docs[[x]] is a "character" now, not "PlainTextDocument"

