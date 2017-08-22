# Milestone Report for NLP Capstone Project
Vadim K.  
22 August 2017  



## Synopsis
в чем цель


## Data Processing
библиотеки


### _Loading Data_

описываем что была проблема из-за символов
_Issue found (and solved) on loading_
решаем и грузим


### _Summary statistics_
графики с общим количеством строк, символов, размером файлов

### Sampling Data
делаем сэмпл

### _Cleaning Data_
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

