#######
#  1  #
#######

#after 1st attempt of building n-grams with quanteda there is an issue
#issue - among popular we see 2-grams like 'u 009f'  '009f u' etc.
#seems there were some non-printable symbols in our text
#let's try to find them at the source

# we pick one pattern and make a vector to subset sentences
ind <- sapply(n2, function(x) {"u 009f" %in% x})
head(sentences[ind])

#"<f0><U+009F><U+0092><U+009C> $4 Bud Light Pints"
#"<f0><U+009F><U+0098><U+00A1> What happened?"   
#looks like unicode for smiles and stuff like that 

# found 2 sub-types of them in the text
# both look like escaped unicode characters
st1 <- "Girls night with and !"
st2 <- "I was just trying to hit it hard someplace"

grep(st1, twitter)
grep(st2, news)
issue1 <- twitter[grepl(st1, twitter)]
issue2 <- news[grepl(st2, news)]

str_replace_all(issue1, "[^[:print:]]", "") #didn't work
str_replace_all(issue2, "[^[:print:]]", "") #worked

iconv(issue1, from = "UTF-8", sub = "") #worked!
iconv(issue2, from = "UTF-8", sub = "") #worked!


#one more check
issue3 <- news[136]
iconv(issue3, from = "UTF-8", sub = "") #worked!


#credits to this StackO- post
#https://stackoverflow.com/questions/9934856/removing-non-ascii-characters-from-data-files




#####
# 2 #
#####

t <- "By Advertising and linking to Amazon.com, 123 amazon.ca, amazon.fr, amazon.it and amazon.es."

t %>% tokens( what = "word", remove_numbers = TRUE,
              remove_punct = TRUE, remove_symbols = TRUE, remove_separators = TRUE,
              remove_twitter = TRUE, remove_hyphens = TRUE, remove_url = TRUE,
              ngrams = 1L, verbose = TRUE) %>%
    tokens_tolower() %>%
    tokens_remove(stopwords("english")) %>%
    tokens_wordstem(language = "english") #this last step somehow truncates 'es' from (only) 'amazon.es'

