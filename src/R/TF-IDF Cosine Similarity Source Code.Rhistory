#import the dataset
the.data <- read.csv("E:/RWorkingDirectory/largedata/1000.txt", header=FALSE)
View(the.data)

# load essential library
library("tm", lib.loc="d:/Program Files/R/R-3.1.3/library")
library("SnowballC", lib.loc="d:/Program Files/R/R-3.1.3/library")
library("slam", lib.loc="d:/Program Files/R/R-3.1.3/library")


create a VCorpus data type for R to process
my.corpus <- Corpus(VectorSource(the.data[[2]]))

# Save the number of questions
N.questions <- length(the.data[[2]])

# Data cleansing with tm package functions
my.corpus <- tm_map(my.corpus, removePunctuation)
my.corpus <- tm_map(my.corpus, removeNumbers)
my.corpus <- tm_map(my.corpus, content_transformer(tolower))
my.corpus <- tm_map(my.corpus, removeWords, stopwords("SMART"))
my.corpus <- tm_map(my.corpus, stemDocument)
my.corpus <- tm_map(my.corpus, stripWhitespace)
my.corpus$content[7]

# get term frequency matrix
term.q.matrix <- TermDocumentMatrix(my.corpus)
inspect(term.q.matrix[300:400, 0:5])

# Reduce sparsity to save space because R stores "0" as well
the.matrix <- removeSparseTerms(term.q.matrix, 0.99999)
term.q.matrix.den <- as.matrix(the.matrix)

get.weights.per.term.vec <- function(tfidf.row) {
term.df <- sum(tfidf.row > 0)
tf.idf.vec <- get.tf.idf.weights(tfidf.row, term.df)
return(tf.idf.vec)
}

# Computes tf-idf weights from a term frequency vector and a set of document #containing the term
weight = rep(0, length(tf.vec))
weight[tf.vec > 0] = (1 + log(1 + log(tf.vec[tf.vec > 0]))) * log2((1 + N.questions)/dt)
weight
}

# apply functions to the matrix 
tfidf.matrix <- t(apply(term.q.matrix.den, c(1), FUN = get.weights.per.term.vec))
tfidf.matrix[401:405, 17:47]

# Make the norm of the Axis to 1
tfidf.matrix <- scale(tfidf.matrix, center = FALSE, scale = sqrt(colSums(tfidf.matrix^2)))

# Calculate two matrix dot product
q.scores <- t(tfidf.matrix) %*% tfidf.matrix

# Save the result
results.df <- data.frame(score = t(q.scores))

# Export .csv file to hard drive
write.table(results.df, file = "the.1000.similarity.csv")

# Export history of console command lines
savehistory("E:/RWorkingDirectory/largedata/for submission.Rhistory")
