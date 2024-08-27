library(data.table)
library(Rtsne)
library(caret)
library(Metrics)
library(ClusterR)

#load data
kaggle_test <- fread("./project/volume/data/raw/kaggle_test.csv")
kaggle_train <- fread("./project/volume/data/raw/kaggle_train.csv")
test_emb <- fread("./project/volume/data/raw/test_emb.csv")
train_emb<- fread("./project/volume/data/raw/train_emb.csv")

#create master table
master <- rbind(kaggle_test,kaggle_train, fill=TRUE)

#save master table to interim
fwrite(master, "./project/volume/data/interim/master.csv")
