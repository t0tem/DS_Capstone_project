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
#bigtext[grepl(st1, bigtext)]
#bigtext[grepl(st2, bigtext)]
#bigtext[grepl(st3, bigtext)]

sample <- sample(bigtext, 500000)


#creating tidy text DF
text_df <- data_frame(line = 1:length(sample), text = sample)

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


#there was smth important to correct from Lexicon weird stuff

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


#removing 

#filtering function
filter_lexicon <- function(word) {
    word[!word %in% Lexicon] <- "_unk_"
    word
}


#replacing OOV words with <unknown> token (making final ngrams)
n1 <- tidy_text %>% mutate_at("word", filter_lexicon)

n2 <- n1 %>% unnest_tokens(word, word, token = "ngrams", n = 2)


#frequency of unigram
n1Freq <- n1 %>% count(word, sort = TRUE) %>% filter(n > 3 & word != "_unk_") 
n2Freq <- n2 %>% count(word, sort = TRUE)

n2Freq %>% filter(grepl("_unk_", word))
nrow(n2Freq %>% filter(n > 3))




dt2 <- n2Freq %>% filter(n > 10)
format(object.size(n1Freq), "Mb")


n2 %>% filter(line == 24)
n2Freq %>% filter(grepl("_", word))
n2Freq %>% filter(grepl("that", word))

text_df %>% filter(grepl("#", text))
tidy_text2 %>% filter(line == 439) %>% .$word


