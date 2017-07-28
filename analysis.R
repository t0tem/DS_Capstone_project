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

#connecting----
f <- paste0("data/", extrF)
con <- file(f, "r")

#sampling----

closeAllConnections()
#showConnections(all = TRUE)


n <- 100000 #sample size
prob <- 0.2 #probability for biased coin flip
smpl <- character(0) #final sample

#option 1 - this takes from diff parts of file, doesn't load the whole file, but takes around 100sec
con <- file(f, open = "r")
pts <- proc.time()
while (length(smpl) < n & 
       length(cur.line <- readLines(con, 1))) {
    if(rbinom(1,1,prob)) {
        smpl <- c(smpl, cur.line)
    }
}
proc.time() - pts
close(con)

#option 2 - this takes from diff parts of file, takes only 6sec, but loads the whole file (>300mb)
con <- file(f, open = "r")
pts <- proc.time()
all <- readLines(con)
smpl <- sample(all, n)
proc.time() - pts
close(con)

#option 3 - this doesn't load the whole file, takes no time, but takes from beginning of the file
con <- file(f, open = "r")
pts <- proc.time()
smpl <- readLines(con, 100000)
proc.time() - pts
close(con)
