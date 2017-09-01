library(tidytext)
library(dplyr)
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

#creating tidy text DF
#text_df <- data_frame(line = 1:length(sample), text = sample)
text_df <- data_frame(line = 1:length(bigtext), text = bigtext)

#creating first tidy long text format
tidy_text <- text_df %>% 
    
    #handles tokens, lowercase, punctuation
    unnest_tokens(word, text) %>%
    
    #removes numbers
    filter(!str_detect(word, "[\\d]"))

#word count
word_count <- tidy_text %>% count(word, sort = TRUE)


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

lexiconed_text <- tidy_text %>% mutate_at("word", filter_lexicon)

#function to assemble back the text
norm_text <- data.table(lexiconed_text)[,.(text = paste(word, collapse = " ")), 
                                        by = line][, text]
