
install.packages("tidytext")
library(tidytext)
library(dplyr)
text_df <- data_frame(line = 1:length(news), text = news)

text_df

data(stop_words)

tidy_text <- text_df %>% 
    
    #handles tokens, lowercase, punctuation
    unnest_tokens(word, text) %>% 
    
    #removes stop words
    anti_join(stop_words) %>%
    
    #remove numbers
    filter(!str_detect(word, "[\\d]"))

#word count
tidy_text %>%
    count(word, sort = TRUE)

#visualization
library(ggplot2)

tidy_text %>%
    count(word, sort = TRUE) %>%
    mutate(word = reorder(word, n)) %>%
    head(20) %>%
    ggplot(aes(word, n)) +
    geom_col() +
    xlab(NULL) +
    coord_flip()


#n-grams
tidy_2_g <- text_df %>% sample_n(50000) %>% unnest_tokens(word, text, 
                                      token = "ngrams", n = 3)

word_freq <- tidy_2_g %>%
    count(word, sort = TRUE)

head(word_freq)

wordcloud(words = word_freq$word,
          freq = word_freq$n, 
          colors = brewer.pal(8, "Dark2"), 
          scale = c(4, 0.2),
          rot.per = 0.3,
          min.freq = 50, max.words = 100,
          random.order = FALSE)
