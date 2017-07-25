#downloading dataset
if(!dir.exists("data")) {dir.create("data")}

if (!file.exists("data/Coursera-SwiftKey.zip")) {
    link <- "https://d396qusza40orc.cloudfront.net/dsscapstone/dataset/Coursera-SwiftKey.zip"
    #print("hi")
    download.file(link, "data/Coursera-SwiftKey.zip")
}


#making the paths
archv <- "data/Coursera-SwiftKey.zip"
locale <- c("en_US", "ru-RU", "de_DE", "fi_FI")
source <- c("blogs", "news", "twitter")

#final path to txt inside zip
extrF <- paste0(locale[1], ".", source[3], ".txt")
path <- paste0("final/",locale[1], "/", extrF)

#unzipping
unzip(archv, files = c(path), junkpaths = TRUE, exdir = "data")

#connecting
f <- paste0("data/", extrF)
con <- file(f, "r")

#sampling
totalSize <- length(readLines(con))
sampleSize <- 200

# creating a vector of 0s and 1s to decide to we take or not the line in sample
set.seed(45678)
v <- integer()
for (i in 1:totalSize) {
    v <- c(v, 
           rbinom(1, 1, 0.01))
}

#reading line by line the 

for (i in seq_along(v)) {
    x <- c(x, i)
}

mean(v)
hist(v)

readLines(con, 1)


close(con)

#closing all connections just in case...
closeAllConnections()
showConnections(all = TRUE)








#inspired by https://www.r-bloggers.com/random-sampling-of-plain-text-in-r/
set.seed(456798)
lines <- sample(totalSize, sampleSize)

sample <- character()
for (i in lines) {
    add <- scan(con, what = "character", skip = i-1, 
                nlines = 1, sep = "\n")
    sample <- rbind(sample, add)
}

scan(con, what = "character", skip = 100000, 
     nlines = 10, sep = "\n")





