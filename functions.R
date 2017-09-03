#Script with functions

#function to read the files in binary mode
read_file <- function(path) {
    con <- file(path, open = "rb")
    data <- readLines(con, encoding = "UTF-8", skipNul = TRUE)
    close(con)
    data
}


#building DFMs for tokens
build.dfm <- function(n) {
    dfm(tokens_ngrams(tok, n = n, concatenator = " "), tolower = FALSE)
}


#building DTs with frequencies
build.dt <- function(dfm) {
    dt <- data.table(word = featnames(dfm), n = colSums(dfm))
    dt <- dt[order(-n)]
    dt
}


#calculating scores
get_scores <- function(dt) {
    dt[, c("root", "prediction") := 
           tstrsplit(word, " (?=[^ ]*$)", perl = TRUE)][, word := NULL]
    dt[, root.n := sum(n), by = root] #count frequencies of 'root'
    dt[, score := n/root.n]
    setcolorder(dt, c(2,3,4,1,5))
    setkey(dt, root)
    dt <- dt[n > 1]
    dt
}

#truncate DTs
truncate.dt <- function(dt) {
    dt <- dt[dt[, head(.I, 3), by = root]$V1]
    dt <- dt[n > 3, c("root", "prediction", "score")]
    dt
}
