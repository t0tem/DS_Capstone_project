#3
lapply(list(blogs = blogs, 
            news = news, 
            twitter = twitter), 
       function(x) {max(nchar(x))})

# m <- max(nchar(blogs))
# pos <- which(nchar(blogs) == m)
# write(blogs[pos], "longest_blogpost.txt")


#4
sum(grepl("love", twitter)) / sum(grepl("hate", twitter))

#5
grep("biostats", twitter, value = TRUE)

#6
str <- "A computer once beat me at chess, but it was no match for me at kickboxing"
sum(grepl(str, twitter))