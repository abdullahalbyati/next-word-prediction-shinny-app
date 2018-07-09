library(data.table)
library(wordcloud)
library(shiny)
library(tm)
library(shinydashboard)
library(dashboardthemes)
library(ggplot2) #graphs

#Load data; total 65.8MB
d1 <- readRDS('data/d1.RDS') #0.3MB
d2 <- readRDS('data/d2.RDS') #7MB
d3 <- readRDS('data/d3.RDS') #22.4MB
d4 <- readRDS('data/d4.RDS') #36.1MB

#Prediction function
predict.quadmkn <- function (words, n=5) {
  
  # follow a similar preparation path as the large corpus
  words <- removeNumbers(words)
  words <- removePunctuation(words)
  words <- tolower(words)
  
  # split into words
  words <- unlist(strsplit(words, split = " " ))
  
  # only focus on last 5 words
  words <- tail(words, 5)
  
  word1 <- words[1];word2 <- words[2];word3 <- words[3];word4 <- words[4];word5 <- words[5];
  word1_word2_word3 <- paste(tail(words,3),collapse = ' ')
  quad <- head(d4[w1w2w3==word1_word2_word3,c('pred','pkn','ngram'),with=FALSE])
  word2_word3 <- paste(tail(words,2),collapse = ' ')
  tri <- head(d3[w1w2==word2_word3,c('pred','pkn','ngram'),with=FALSE])
  word3 <- tail(words,1)
  bi <- head(d2[w1==word3,c('pred','pkn','ngram'),with=FALSE])
  uni <- head(d1)
  result <- rbind(quad,tri,bi,uni)
  head(result,10)
  
}
