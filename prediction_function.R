require(quanteda)
require(data.table)

predict.word <- function(str) {
    
    #splitting and cleaning string
    split_str <- as.character(tokens_tolower(
        tokens(str, what = "word", remove_numbers = TRUE,
               remove_punct = TRUE, remove_symbols = TRUE, 
               remove_twitter = TRUE, remove_hyphens = TRUE, remove_url = TRUE))
    )
    
    #creating empty candidates DT
    dt_cand <- data.table()
    
    #checking 4gram root
    if (length(split_str) >= 4) {
        
        root4 <- paste(tail(split_str, 4), collapse = " ")
        
        add_cand <- head(dt5[root == root4][, c("prediction", "score")], 3)
        new <- !add_cand[, prediction] %in% dt_cand #checking which ones are new
        dt_cand <- rbind(dt_cand, add_cand[new])
        
        if (nrow(dt_cand) >= 3) {
            return(dt_cand[order(-score)][,prediction][1:3])
        }
    }
    
    #checking 3gram root
    if (length(split_str) >= 3) {
        
        root3 <- paste(tail(split_str, 3), collapse = " ")
        
        add_cand <- head(
            dt4[root == root3][, c("prediction", "score")][, score := 0.4*score], 
            3)
        new <- !add_cand[, prediction] %in% dt_cand #checking which ones are new
        dt_cand <- rbind(dt_cand, add_cand[new])
        
        if (nrow(dt_cand) >= 3) {
            return(dt_cand[order(-score)][,prediction][1:3])
        }
    }
    
    #checking 2gram root
    if (length(split_str) >= 2) {
        
        root2 <- paste(tail(split_str, 2), collapse = " ")
        
        add_cand <- head(
            dt3[root == root2][, c("prediction", "score")][, score := 0.4*0.4*score],
            3)
        new <- !add_cand[, prediction] %in% dt_cand #checking which ones are new
        dt_cand <- rbind(dt_cand, add_cand[new])
        
        if (nrow(dt_cand) >= 3) {
            return(dt_cand[order(-score)][,prediction][1:3])
        }
    }
    
    #checking unigram root
    if (length(split_str) >= 1) {
        
        root1 <- paste(tail(split_str, 1), collapse = " ")
        
        add_cand <- head(
            dt2[root == root1][, c("prediction", "score")][, score := 0.4*0.4*0.4*score],
            3)
        new <- !add_cand[, prediction] %in% dt_cand #checking which ones are new
        dt_cand <- rbind(dt_cand, add_cand[new])
        
        if (nrow(dt_cand) >= 3) {
            return(dt_cand[order(-score)][,prediction][1:3])
        }
    }
    
    if (nrow(dt_cand) > 0) {
        return(
            head(
                c(dt_cand[order(-score)][,prediction], 
                  "the", "to", "and"),
                3)) 
    }
    return(c("the", "to", "and"))
}
