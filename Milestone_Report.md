# Milestone Report for NLP Capstone Project
Vadim K.  
22 August 2017  



## Synopsis

The purpose of this document is to provide a milestone report on developing an 
interactive text prediction web app.  
This developement is a part of the capstone project that 
wraps up Coursera Data Science specialization offered by Johns Hopkins University (Baltimore, Maryland).

This application will predict the next word a user most likely will type 
based on the words he/she already typed.  
The server part of application will run a word prediction algorithm that will be finalized later in the project. 
This algorithm is based on N-gram language model built from [HC Corpora](https://web-beta.archive.org/web/20160930083655/http://www.corpora.heliohost.org/aboutcorpus.html) (a set of files with millions lines of text in different languages collected from publicly available sources by a web crawler).

In the present document I will give a brief overview of the first steps of the project 
that were already achieved such as downloading, cleaning and exploring the data. 
I will also share couple of issues I faced and some interesting findings in the data.  
In conclusion you'll find some info about my plans for creating the prediction algorithm and the expected constraints.


## Data Processing



The R packages used during analysis are


```{}
library(stringr) # to count words
library(stringi) # to count max characters (seems faster than stringr)
library(dplyr) # to rename columns of summary table
library(readtext) # to read sample file into a Corpus
library(quanteda) # for all the text mining
library(data.table) # to hold the frequency tables
```


#### _Loading Data_

The data was obtained from the archive available under following [link](https://d396qusza40orc.cloudfront.net/dsscapstone/dataset/Coursera-SwiftKey.zip).  
It contains texts from 3 types of sources (blogs, news, Twitter) in 4 different locales (en_US, de_DE, ru_RU and fi_FI).  
Files in English were taken for this project (i.e. `"en_US.blogs.txt"; "en_US.news.txt"; "en_US.twitter.txt"`).  


<span style="color:gray">
_There was an issue with loading News file: it containes ASCII `Substitute` character on line 77259, 
this character (decimal 26 or 0x1A) corresponds to Ctrl+Z in Windows so `readLines` function truncates the file at it and imports only 77259 lines.  
Solution is to launch `readLines` in binary mode (credits to  [this Q on StackOverflow](https://stackoverflow.com/questions/15874619/reading-in-a-text-file-with-a-sub-1a-control-z-character-in-r-on-windows))_
</span>



#### _Summary statistics_
Here is some summary statistics for the chosen files:


                    File size    Total lines   Max. character per line   Total words   Av. character per word
------------------  ----------  ------------  ------------------------  ------------  -----------------------
en_US.blogs.txt     248.5 Mb          899288                     40833      37874365                      4.3
en_US.news.txt      249.6 Mb         1010242                     11384      34613673                      4.6
en_US.twitter.txt   301.4 Mb         2360148                       140      30556137                      4.1


****************


#### _Sampling Data_
делаем сэмпл

#### _Cleaning Data_
_Issue found (and solved) on samples_
описываем и чистим
сохраняем сэмплы для дальнейшего использования

## Exploring the Data

чтобы продолжить разобьем на предложения
и потом токены (в целях exploring уберем stop words и сделаем стеммы, потом для
предсказания не будем)
и потом dfm
и потом частоты

графики

## Plans for Prediction Algorithm
сам алгоритм построим на n-gram language model
будем использовать 1-4-граммы и smooting (поэкспериментируем с Good-Turing and 
Katz's back-of)
ограничения:  

* размеры итоговых таблиц (будем использовать data.table, как советуют fellow data scientists on course forum), 
* оперативка на Shiny Server (1 RAM), для экспериментов может сделаем вирт.машину с подобными параметрами

