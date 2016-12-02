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

# read train data --------------------------------------
subject_train <- fread("UCI HAR Dataset/train/subject_train.txt", header=FALSE, strip.white=TRUE, data.table=FALSE)
x_train <- fread("UCI HAR Dataset/train/x_train.txt", header=FALSE, strip.white=TRUE, data.table=FALSE)
y_train <- fread("UCI HAR Dataset/train/y_train.txt", header=FALSE, strip.white=TRUE, data.table=FALSE)

# look at data -----------------------------------------------

# THERE ARE 6 ACTIVITIES
names(activity_labels) <- c("activityId", "activityDesc")

# THERE ARE 561 FEATURES
names(features) <- c("featureId", "featureDesc")
features$featureLabel <- gsub("[-()]", "", features$featureDesc) # make a safe var name

# these are the features specifying means or standard deviations
f_mean <- grep("mean()", features$featureDesc, fixed=TRUE)
f_std <- grep("std()", features$featureDesc, fixed=TRUE)
meanstd <- sort(c(f_mean, f_std))

features$featureDesc[meanstd]


# TEST ---------------------------------------------------------
names(subject_test) <- c("subjectId")
# the test labels? - 1 of 6 activities
names(y_test) <- c("activityId")

# TRAIN ---------------------------------------------------------
names(subject_train) <- c("subjectId")
# the train labels? - 1 of 6 activities
names(y_train) <- c("activityId")

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

# -------------------------------------------------------------
# 5. create independent tidy dataset with average of variable
# for each activity (walk, etc n=6), and each subject (n=1..30)
# -------------------------------------------------------------
table(data_$subjectId, data_$activity)
tidy <- expand.grid(subjectId=sort(unique(data_$subjectId)), activity=sort(unique(data_$activity)))
summary(tidy)
head(tidy)

#  for a given subject-activity
meansarray <- NULL
for (i in 1:nrow(tidy)) { # calculate the col means
	b <- data_[(data_$subjectId==tidy[i,"subjectId"]) & (data_$activity==tidy[i,"activity"]), -c(1:3) ]
	means <- apply(b,2,FUN=mean)
	meansarray <- rbind(meansarray, means)
}
# if it all worked out, bind the subject and means together
if (nrow(meansarray) == nrow(tidy)) {
		row.names(meansarray) <- 1:nrow(meansarray)
		tidydata = cbind(tidy, meansarray)
}

# write it to file
write.table(tidydata, file="tidydata.txt", sep=", ", col.names=TRUE, row.names=FALSE)


#        ~ fin ~
