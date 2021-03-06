library(tm)
library(data.table)

# URL for data source
URL <- "https://d396qusza40orc.cloudfront.net/dsscapstone/dataset/Coursera-SwiftKey.zip"
# If data set not downloaded already, fetch it
if (!file.exists("./Coursera-SwiftKey.zip")) {
  download.file(URL, destfile = "./Coursera-SwiftKey.zip", method="auto")
}
# If data set not extracted already, extract it
if (!file.exists("/data/final/en_US/en_US.blogs.txt")) {
  unzip("/Coursera-SwiftKey.zip", exdir="./data")
}
rm(URL)

#Read text files
blogs <- readLines("data/final/en_US/en_US.blogs.txt", encoding = "UTF-8", skipNul=TRUE)
news <- readLines("data/final/en_US/en_US.news.txt", encoding = "UTF-8", skipNul=TRUE)
twitter <- readLines("data/final/en_US/en_US.twitter.txt", encoding = "UTF-8", skipNul=TRUE)

#Take a small sample of the text to work with 
set.seed( 2017 ); ds.blogs  <- sample(blogs,   0.02 * length(blogs))
set.seed( 2017 ); ds.tweets <- sample(news, 0.05 * length(news))
set.seed( 2017 ); ds.news   <- sample(twitter, 0.02 * length(twitter))

rm("blogs", "news", "twitter")

#Combine sample text together
ds <- c(ds.blogs, ds.tweets, ds.news)

rm("ds.blogs", "ds.tweets", "ds.news")


# text mining on sampled data
corp <- VCorpus(VectorSource(ds))

# start the tm_map transformations 

# switch encoding: convert character vector from UTF-8 to ASCII
corp <- tm_map(corp, function(x)  iconv(x, 'UTF-8', 'ASCII'))

# eliminate white spaces
corp <- tm_map(corp, stripWhitespace)

# convert to lowercase
corp <- tm_map(corp, tolower)

# Remove punctuation
corp = tm_map(corp, removePunctuation)

# Remove numbers
corp = tm_map(corp, removeNumbers)

# assign TEXT flag
corp <- tm_map(corp, PlainTextDocument)

for(i in 1:6) {
  print(paste0("Extracting", " ", i, "-grams from corpus"))
  tokens <- function(x) unlist(lapply(ngrams(words(x), i), paste, collapse = " "), use.names = FALSE)
  tdm <- TermDocumentMatrix(corp, control = list(tokenize = tokens))
  
  
  tdmr <- sort(slam::row_sums(tdm, na.rm = T), decreasing=TRUE)
  tdmr.t <- data.table(token = names(tdmr), count = unname(tdmr)) 
  tdmr.t[,  paste0("w", seq(i)) := tstrsplit(token, " ", fixed=TRUE)]
  tdmr.t$token <- NULL
  
  
  print(paste0("Loaded in memory ", nrow(tdmr.t), " ", i, "-grams, taking: "))
  print(object.size(tdmr.t), units='Mb')
  
  #frequency distribution
  print( table(tdmr.t$count) )
  
  # dynamically create variable names
  assign(paste0("ngram",i), tdmr.t)
}
rm(ds)
rm(tdmr)
rm(tdm)
rm(tdmr.t)
#################################################################

# prediction

################################################################
pred_words <- function(words, n = 10){
  
  # follow a similar preparation path as the large corpus
  words <- removeNumbers(words)
  words <- removePunctuation(words)
  words <- tolower(words)
  
  # split into words
  words <- unlist(strsplit(words, split = " " ))
  
  # only focus on last 5 words
  words <- tail(words, 5)
  
  word1 <- words[1];word2 <- words[2];word3 <- words[3];word4 <- words[4];word5 <- words[5];
  datasub <- data.table()
  
  if (nrow(datasub)==0 & !is.na(word5)) {
    if(nrow(datasub) == 0) datasub <- subset(ngram6, w1==word1 & w2==word2 & w3==word3 & w4==word4 & w5==word5)
    if(nrow(datasub) == 0) datasub <- subset(ngram5, w1==word2 & w2==word3 & w3==word4 & w4==word5)
    if(nrow(datasub) == 0) datasub <- subset(ngram4, w1==word3 & w2==word4 & w3==word5)
    if(nrow(datasub) == 0) datasub <- subset(ngram3, w1==word4 & w2==word5)
    if(nrow(datasub) == 0) datasub <- subset(ngram2, w1==word5)
  }
  
  if (nrow(datasub)==0 & !is.na(word4)) {
    if(nrow(datasub) == 0) datasub <- subset(ngram5, w1==word1 & w2==word2 & w3==word3 & w4==word4)
    if(nrow(datasub) == 0) datasub <- subset(ngram4, w1==word2 & w2==word3 & w3==word4)
    if(nrow(datasub) == 0) datasub <- subset(ngram3, w1==word3 & w2==word4)
    if(nrow(datasub) == 0) datasub <- subset(ngram2, w1==word4)
  }
  
  if (nrow(datasub)==0 & !is.na(word3)) {
    if(nrow(datasub) == 0) datasub <- subset(ngram4, w1==word1 & w2==word2 & w3==word3)
    if(nrow(datasub) == 0) datasub <- subset(ngram3, w1==word2 & w2==word3)
    if(nrow(datasub) == 0) datasub <- subset(ngram2, w1==word3)
  }
  
  if (nrow(datasub)==0 & !is.na(word2)) {
    if(nrow(datasub) == 0) datasub <- subset(ngram3, w1==word1 & w2==word2)
    if(nrow(datasub) == 0) datasub <- subset(ngram2, w1==word2)
  }
  
  if (nrow(datasub)==0 & !is.na(word1)) {
    if(nrow(datasub) == 0) datasub <- subset(ngram2, w1==word1)
    if(nrow(datasub) == 0) datasub <- head(ngram1)
  }
  
  if(nrow(datasub) > 0){
    datasub$freq <- datasub$count / sum(datasub$count)
    as.data.frame(head(datasub[order(-freq)], min(n, nrow(datasub))))
  }
  
}

rm(corp)