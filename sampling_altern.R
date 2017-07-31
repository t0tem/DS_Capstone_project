##########
#sampling
##########

#closeAllConnections()
#showConnections(all = TRUE)


n <- 50000 #sample size
prob <- 0.1 #probability for biased coin flip


#option 1 - this takes from diff parts of file, doesn't load the whole file, but takes around 100sec
con <- file(extrF[1], open = "rb")
smpl <- character(0) #initiating sample
set.seed(456789)
pts <- proc.time()
while (length(smpl) < n & 
       length(cur.line <- readLines(con, 1, encoding = "UTF-8", skipNul = TRUE))) {
    #we flip a biased coin to decide do we take the line to sample or not
    if(rbinom(1,1,prob)) { 
        smpl <- c(smpl, cur.line)
    }
}
proc.time() - pts
close(con)

#option 2 - this takes from diff parts of file, takes only 6-13sec, but loads the whole file (>300mb)
con <- file(extrF[1], open = "rb")
pts <- proc.time()
all <- readLines(con, encoding = "UTF-8", skipNul = TRUE)
set.seed(456789)
smpl <- sample(all, n)
proc.time() - pts
close(con)
#rm(all)

#option 3 - this doesn't load the whole file, takes no time, but takes from beginning of the file
con <- file(extrF, open = "rb")
pts <- proc.time()
smpl <- readLines(con, n, encoding = "UTF-8", skipNul = TRUE)
proc.time() - pts
close(con)
