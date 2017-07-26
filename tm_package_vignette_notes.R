# tm package vignette "https://cran.r-project.org/web/packages/tm/vignettes/tm.pdf"

library(tm)
txt <- system.file("texts", "txt", package = "tm")
(ovid <- VCorpus(DirSource(txt, encoding = "UTF-8"),
                readerControl = list(language = "lat")))

docs <- c("This is a text.", "This another one.")
VCorpus(VectorSource(docs))


reut21578 <- system.file("texts", "crude", package = "tm")
reuters <- VCorpus(DirSource(reut21578), 
                   readerControl = list(reader = readReut21578XMLasPlain))


writeCorpus(ovid)

inspect(ovid[1:2])

meta(ovid[[2]], "id")
identical(ovid[[2]], ovid[["ovid_2.txt"]])

inspect(ovid[[2]])
as.character(ovid[[2]])

inspect(reuters[[1]])
as.character(reuters[[1]])


lapply(ovid[1:2], as.character)


#Eliminating Extra Whitespace
reuters <- tm_map(reuters, stripWhitespace)
inspect(reuters[[1]])


#Convert to Lower Case
reuters <- tm_map(reuters, content_transformer(tolower))
inspect(reuters[[1]])


#Remove Stopwords
reuters <- tm_map(reuters, removeWords, stopwords("english"))
inspect(reuters[[1]])


#Stemming
tm_map(reuters, stemDocument)



#Creating Term-Document Matrices
dtm <- DocumentTermMatrix(reuters)
inspect(dtm[5:10, 740:743])


# find those terms that occur at least five times
findFreqTerms(dtm, 5)


#find associations (i.e., terms which correlate) with at least 0.8 correlation for the term opec
findAssocs(dtm, "opec", 0.8)

#remove sparse terms, i.e., terms occurring only in very few documents 
inspect(removeSparseTerms(dtm, 0.4))



