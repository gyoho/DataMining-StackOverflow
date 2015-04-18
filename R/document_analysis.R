# create data frame: import the data into R
> df <- read.delim("~/Class/Data Mining/Project/Dataset-AskUbuntu/data/questions-300.txt", header=FALSE)
> ids <- Vectorize(df[1])
> questions <- Vectorize(df[2])

# create corpus i.e) vector space model
# df[2]: access the entire 2nd vector
# df[[2]]: access the 2nd vecotr for every element
> doc.list <- as.list(as.data.frame(t(questions)))
> id.list <- as.list(as.data.frame(t(ids)))
> names(doc.list) <- paste0(c(id.list))

> question.docs <- VectorSource(doc.list)
> question.name <- names(doc.list)
> question.corpus <- Corpus(questions.docs)




# make lowercase
> question.corpus <- tm_map(question.corpus, content_transformer(tolower))

# exclude stopwords
> question.corpus <- tm_map(question.corpus, removeWords, stopwords("en"))
> question.corpus <- tm_map(question.corpus, removeWords, stopwords("SMART"))

# remove extra whitespace
> question.corpus <- tm_map(question.corpus, stripWhitespace)

# stem words in a text document with the snowball stemmers,
# which requires packages Snowball, RWeka, rJava, RWekajars
> question.corpus <- tm_map(question.corpus, stemDocument, mc.cores=1
                            
# convert to Term Document Matrix
> dtm <- DocumentTermMatrix(question.corpus, control = list(stopwords=myStopwords))
> dtmBin <- DocumentTermMatrix(question.corpus, control = list(weighting=weightBin, stopwords=myStopwords))
> dtmTfIdf <- DocumentTermMatrix(question.corpus, control = list(weighting=weightTfIdf, stopwords=myStopwords))
  
# convert dtm to matrix to work with Cosine distance
> dtm.matrix <- as.matrix(dtm)
> dtmBin.matrix <- as.matrix(dtmBin)
> dtmTfIdf.matrix <- as.matrix(dtmTfIdf)

# 
> colSums(dtmTfIdf.matrix^2)
> dtmBinNorm.matrix <- scale(dtmBin.matrix, center = FALSE, scale = sqrt(colSums(dtmBin.matrix^2)))
> dtmTfIdfNorm.matrix <- scale(dtmTfIdf.matrix, center = FALSE, scale = sqrt(colSums(dtmTfIdf.matrix^2)))

# A[1,]: 1st row
# A[,1]: 1st col
> query.vector <- dtmTfIdfNorm.matrix[1,]
> dtmTfIdfNormTarget.matrix <- dtmTfIdfNorm.matrix[2:length(doc.list),]
> doc.scores <- query.vector %*% t(dtmTfIdfNormTarget.matrix)



getCosineSimilarity <- function(dtm) {
  target.matrix <- dtm
  doc.scores <- matrix(nrow = 0, ncol = 300)
  
  for(i in seq(from = 1, to = length(doc.list), by = 1)) {
    query.vector <- dtm[i,]
    doc.score <- query.vector %*% t(target.matrix)
    doc.scores <- rbind(doc.scores ,doc.score)
  }
  return (doc.scores)
}


> colnames(docBin.scores) <- question.name
> write.csv(docBin.scores, "CosineBinScores.csv", row.names=question.name)
> write.csv(docBin.scores, "CosineBinScores_NoHeader.csv", row.names=FALSE, col.names=FALSE)


> colnames(docTfIdf.scores) <- question.name
> write.csv(docTfIdf.scores, "CosineTfIdfScores.csv", row.names=question.name)
> write.csv(docTfIdf.scores, "CosineTfIdfScores_NoRowNum.csv", row.names=FALSE, col.names=FALSE)