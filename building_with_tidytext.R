library(tidytext)
library(dplyr)
library(stringr)
library(data.table)

setwd("data")

#function to read files in binary mode skipping NULLs 
read_file <- function(path) {
    con <- file(path, open = "rb")
    data <- readLines(con, encoding = "UTF-8", skipNul = TRUE)
    close(con)
    data
}

bigtext <- c(read_file("en_US.blogs.txt"),
             read_file("en_US.news.txt"),
             read_file("en_US.twitter.txt"))

bigtext <- iconv(bigtext, to = "ASCII", sub = "")

#checking if all convertion done ok
#st1 <- "Girls night with and !"
#st2 <- "I was just trying to hit it hard someplace"
#st3 <- "platforms were named after pagan"
#bigtext[grep(st1, bigtext)]
#bigtext[grep(st2, bigtext)]
#bigtext[grep(st3, bigtext)]
bigtext[1]
bigtext[899298]
bigtext[2963709]

set.seed(772233)
sample <- sample(bigtext, 100000)


#creating tidy text DF
text_df <- data_frame(line = 1:length(sample), text = sample)
#text_df <- data_frame(line = 1:length(bigtext), text = bigtext)

#creating first tidy long text format
tidy_text <- text_df %>% 
    
    #handles tokens, lowercase, punctuation
    unnest_tokens(word, text) %>%
    
    #removes numbers
    filter(!str_detect(word, "[\\d]"))

#word count
word_count <- tidy_text %>%
    count(word, sort = TRUE)


#creating Lexicon (all the words more frequent than 3 times)
Lexicon <- word_count %>% filter(n > 3) %>% .$word

#checking Lexicon for weird stuff
to_remove <- grep("[!\"#$%&()*+,-./:;<=>?@^_`|~.]", Lexicon, value = TRUE)
Lexicon <- Lexicon[!Lexicon %in% to_remove]


#there was smth important to correct in text found in Lexicon weird stuff
#function for correction
correct_spelling <- function(word) {
    word[word == "u.s"] <- "us"
    word[word == "p.m"] <- "pm"
    word[word == "a.m"] <- "am"
    word[word == "i.e"] <- "that's"
    word[word == "thats"] <- "that's"
    word[word == "thatll"] <- "that's"
    word
}

tidy_text <- tidy_text %>% mutate_at("word", correct_spelling)

#now we'll introduce <unknown> token to our data
#filtering function
filter_lexicon <- function(word) {
    word[!word %in% Lexicon] <- "_unk_" #'_' is the only symbol kept by tokenizer
    word
}


#replacing OOV words with <unknown> token (making final ngrams)

n1 <- tidy_text %>% mutate_at("word", filter_lexicon)

n2 <- n1 %>% unnest_tokens(word, word, token = "ngrams", n = 2)
#n2 %>% filter(line == 24)
n3 <- n1 %>% unnest_tokens(word, word, token = "ngrams", n = 3)
#n3 %>% filter(line == 111)
n4 <- n1 %>% unnest_tokens(word, word, token = "ngrams", n = 4)
#n4 %>% filter(line == 100001)
n5 <- n1 %>% unnest_tokens(word, word, token = "ngrams", n = 5)
#n5 %>% filter(line == max(line))

#frequency of unigram
n1Freq <- n1 %>% count(word, sort = TRUE) #%>% filter(n > 3 & word != "_unk_")
n2Freq <- n2 %>% count(word, sort = TRUE) #%>% filter(n > 3)
#nrow(n2Freq %>% filter(n > 3))
n3Freq <- n3 %>% count(word, sort = TRUE) #%>% filter(n > 3)
n4Freq <- n4 %>% count(word, sort = TRUE) #%>% filter(n > 3)
n5Freq <- n5 %>% count(word, sort = TRUE) #%>% filter(n > 3)


#switching to DTs
dt1 <- data.table(n1Freq)
dt2 <- data.table(n2Freq)
dt3 <- data.table(n3Freq)
dt4 <- data.table(n4Freq)
dt5 <- data.table(n5Freq)


#drafts
#system.time(
#dt4[, c("w1", "w2", "w3", "w4") := 
#        tstrsplit(word, " ", fixed = TRUE)][, word := NULL]
#) # эта быстрее но не универсальна
#dt4[, root := paste(w1, w2, w3)][, c("w1", "w2", "w3") := NULL]
#setnames(dt4, "w4", "prediction")

#function to calculate score and clean-up DT

#get_scores1 <- function(DT) {
#    DT[, c("root", "prediction") := 
#           list(word(word, 1, -2), 
#                word(word, -1))][, word := NULL] 
#    #'word' is the fucntion from stringr
#    DT[, root.n := sum(n), by = root] #count frequencies of 'root'
#    DT[, score := n/root.n]
#    setcolorder(DT, c(2,3,4,1,5))
#    DT
#}

get_scores <- function(DT) {
    DT[, c("root", "prediction") := 
           tstrsplit(word, " (?=[^ ]*$)", perl = TRUE)][, word := NULL] 
    #splitting at last whitespace, much faster than 'stringr::word'
    DT[, root.n := sum(n), by = root] #count frequencies of 'root'
    DT[, score := n/root.n]
    setcolorder(DT, c(2,3,4,1,5))
    DT
}


system.time(get_scores(dt1))
system.time(get_scores(dt2))
system.time(get_scores(dt3))
system.time(get_scores(dt4))
system.time(get_scores(dt5))



#prediction

str <- c("you must be")

#df <- data_frame(line = 1:length(str), text = str)

root4 <- data_frame(str) %>% unnest_tokens(word, str) %>%
    filter(!str_detect(word, "[\\d]")) %>% 
    mutate_at("word", filter_lexicon) %>% 
    #slice((n() - 3):n()) %>%
    filter(row_number() > n()-5) %>%
    .$word %>% paste(collapse = " ")
root3 <- word(root4, start=-3, end = -1)
root2 <- word(root4, start=-2, end = -1)
root1 <- word(root4, start=-1, end = -1)


dt5[root == root4]
dt4[root == root3]
dt3[root == root2]
dt2[root == root1]

###this script appeared to be too slow when applied to the whole Corpus
###we'll use its' part for normalizing text, then will proceed with 'quanteda'
### see normalize_w_tidytext.R
