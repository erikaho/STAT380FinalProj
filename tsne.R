library(data.table)
library(Rtsne)
library(caret)
library(Metrics)
library(ClusterR)

#load data
submisson <- fread("./project/volume/data/raw/example_sub.csv")
kaggle_test <- fread("./project/volume/data/raw/kaggle_test.csv")
kaggle_train <- fread("./project/volume/data/raw/kaggle_train.csv")
test_emb <- fread("./project/volume/data/raw/test_emb.csv")
train_emb<- fread("./project/volume/data/raw/train_emb.csv")

master <- rbind(kaggle_test,kaggle_train, fill=TRUE)

id<-master$id
reddit<-master$reddit
train<-master$train

master$train<- NULL
master$id<-NULL
master$reddit<-NULL

set.seed(3)

tsne<- Rtsne(master, pca = T, perplexity = 190, check_duplicates = F)

# grab out the coordinates
tsne_dt<-data.table(tsne$Y)

tsne_dt$reddit<-reddit
tsne_dt$train<-train
