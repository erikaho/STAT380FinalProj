library(data.table)
library(Rtsne)
library(caret)
library(xgboost)
library(Metrics)
library(ClusterR)

#load in data
submisson <- fread("./project/volume/data/raw/example_sub.csv")
kaggle_test <- fread("./project/volume/data/raw/kaggle_test.csv")
kaggle_train <- fread("./project/volume/data/raw/kaggle_train.csv")
test_emb <- fread("./project/volume/data/raw/test_emb.csv")
train_emb<- fread("./project/volume/data/raw/train_emb.csv")
master<-fread("./project/volume/data/interim/master.csv")

#convert to factor variable and then to integer 
kaggle_train$reddit<-as.factor(kaggle_train$reddit)
reddit <- as.integer(kaggle_train$reddit)-1

#convert to matrix for model
test_matrix<-as.matrix(test_emb)
train_matrix <- as.matrix(train_emb)

#parameters for xgboost model
param<- list(
    objective = 'multi:softprob',
    num_class = 11,
    gamma = 0.1, 
    booster = "gbtree",
    eval_metric = "mlogloss",
    eta = 0.01,
    max_depth = 3,
    min_child_weight = 1,
    subsample = 0.5,
    colsample_bytree = 1,
    tree_method = 'hist'
)
                                                                  
xgboost_model<- xgboost(data = train_matrix, label = reddit, params = param, nrounds = 1000, early_stopping_rounds = 25, verbose = 0)


#fit model to all data                                                                 
test_probability <- predict(xgboost_model, test_matrix)
results <- matrix(test_probability, ncol = length(unique(reddit)), byrow = TRUE)
results_df <- as.data.frame(results)

#create the column names from submission file                                                                  
column_names<-c("redditcars", "redditCFB", "redditCooking", "redditMachineLearning", "redditmagicTCG", "redditpolitics", "redditRealEstate", "redditscience", "redditStockMarket", "reddittravel", "redditvideogames")

#apply column names to results_df to change out V1,V2,...,V11
colnames(results_df)<-column_names

#bind submission id to the results_df data frame
results_df<- cbind(id = submisson$id, results_df)

fwrite(results_df, "./project/volume/data/processed/submission4.csv")
