#Script with functions


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

