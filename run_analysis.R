rm(list=ls())
gc()
setwd("~/Dropbox (Personal)/coursera/getdata")
# --------------------------------------------------------
# copyright Eric Chow 2016
#
# Getting and Cleaning Data Course Project.
# merges the training and test sets to create one dataset
# extracts only measurements on mean (SD) for each measure
# renames activities using descriptives, and label vars
# create a second, ind tidy dataset, avg-var-act-subj
# --------------------------------------------------------

library(stringr)
library(plyr)
library(data.table)

activity_labels <- fread("UCI HAR Dataset/activity_labels.txt", header=FALSE, strip.white=TRUE, data.table=FALSE)
features  <- fread("UCI HAR Dataset/features.txt", header=FALSE, strip.white=TRUE, data.table=FALSE)

# read test data --------------------------------------
subject_test <- fread("UCI HAR Dataset/test/subject_test.txt", header=FALSE, strip.white=TRUE, data.table=FALSE)
x_test <- fread("UCI HAR Dataset/test/x_test.txt", header=FALSE, strip.white=TRUE, data.table=FALSE)
y_test <- fread("UCI HAR Dataset/test/y_test.txt", header=FALSE, strip.white=TRUE, data.table=FALSE)

inertial_signals_test <- NULL
test_inert <- list.files("UCI HAR Dataset/test/Inertial Signals")
for (file in test_inert) {
	message("reading in inertial signal: ", file, "...")
	inertial_signals_test[[file]] <- fread(sprintf("UCI HAR Dataset/test/Inertial Signals/%s",file), header=FALSE, strip.white=TRUE, data.table=FALSE)
}
names(inertial_signals_test)

# read train data --------------------------------------
subject_train <- fread("UCI HAR Dataset/train/subject_train.txt", header=FALSE, strip.white=TRUE, data.table=FALSE)
x_train <- fread("UCI HAR Dataset/train/x_train.txt", header=FALSE, strip.white=TRUE, data.table=FALSE)
y_train <- fread("UCI HAR Dataset/train/y_train.txt", header=FALSE, strip.white=TRUE, data.table=FALSE)

inertial_signals_train <- NULL
train_inert <- list.files("UCI HAR Dataset/train/Inertial Signals")
for (file in train_inert) {
	message("reading in inertial signal: ", file, "...")
	inertial_signals_train[[file]] <- fread(sprintf("UCI HAR Dataset/train/Inertial Signals/%s",file), header=FALSE, strip.white=TRUE, data.table=FALSE)
}
names(inertial_signals_train)

# look at data -----------------------------------------------

# THERE ARE 6 ACTIVITIES
names(activity_labels) <- c("activityId", "activityDesc")
head(activity_labels) # there are 6 activities
nrow(activity_labels)

# THERE ARE 561 FEATURES
names(features) <- c("featureId", "featureDesc")
head(features) # there are 561 features
nrow(features)
features$featureLabel <- gsub("[-()]", "", features$featureDesc) # make a safe var name


# these are the features specifying means or standard deviations
f_mean <- grep("mean()", features$featureDesc, fixed=TRUE)
f_std <- grep("std()", features$featureDesc, fixed=TRUE)
meanstd <- sort(c(f_mean, f_std))

features$featureDesc[meanstd]


# TEST ---------------------------------------------------------
names(subject_test) <- c("subjectId")
head(subject_test)
nrow(subject_test)  # 2947 window samples
table(subject_test)

# the test set
head(x_test)
nrow(x_test) # 2947 window samples
ncol(x_test) # 561 features

# the test labels? - 1 of 6 activities
names(y_test) <- c("activityId")
head(y_test)
nrow(y_test) # 2947 window samples
ncol(y_test) # 1
table(y_test)

# TRAIN ---------------------------------------------------------
names(subject_train) <- c("subjectId")
head(subject_train)
nrow(subject_train)  # 2947 window samples
table(subject_train)

# the train set
head(x_train)
nrow(x_train) # 7352 window samples
ncol(x_train) # 561 features

# the train labels? - 1 of 6 activities
names(y_train) <- c("activityId")
head(y_train)
nrow(y_train) # 7352 window samples
ncol(y_train) # 1
table(y_train)

#
# # Each window was 128 readings, a vector of features obtained
#
# length(inertial_signals_test) # 9 iniertial signals
#
# head(inertial_signals_test[[1]])
# nrow(inertial_signals_test[[1]])   # 2947 samples
# ncol(inertial_signals_test[[1]])   # 128 cols
# # ....
# head(inertial_signals_test[[9]])
# nrow(inertial_signals_test[[9]])   # 2947
# ncol(inertial_signals_test[[9]])   # 128 cols
#
# Tidy dataset: avg of each variable, activity (6), subject (30)


# -------------------------------------------------------------
# 1. Merge the training and test datasets
# -------------------------------------------------------------
subject <- rbind(subject_test, subject_train)
x <- rbind(x_test, x_train)
y <- rbind(y_test, y_train)

data <- cbind(subject, y, x)

# -------------------------------------------------------------
# 2. Extract only measurements on mean and std
# -------------------------------------------------------------
meanstd2 <- meanstd + 2 # shift right by 2 to skip subject and activity ID
data_ <- data[,c(1:2, meanstd2)]  # select only rows with mean() or std() in vars
head(data_)

# -------------------------------------------------------------
# 3. Uses descriptive activity names
# -------------------------------------------------------------
data_$activity <- factor(data_$activity, label=activity_labels$activityDesc)

# -------------------------------------------------------------
# 4. label the dataset with variable names
# -------------------------------------------------------------
names(data_) <- c("subjectId", "activityId", features[meanstd,"featureLabel"], "activity")
data_ <- data_[,c(1,2,ncol(data_),3:(ncol(data_)-1))] # reorder cols
head(data_)

data_$tBodyAcc-mean()-X




#        ~ fin ~
