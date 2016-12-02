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
y_test <- fread("UCI HAR Dataset/test/y_test.txt", header=FALSE, strip.white=TRUE)

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

# THERE ARE LOTS OF FEATURES
names(features) <- c("featureId", "featureDesc")
head(features) # there are 561 features
nrow(features)

# Each window was 128 readings, a vector of features obtained

names(subject_test) <- c("subjectId")
head(subject_test)
nrow(subject_test) # 2947 window samples
table(subject_test)


head(x_test)
nrow(x_test) # 2947
ncol(x_test) # 561

length(inertial_signals_train) # 9 iniertial signals

head(inertial_signals_train[[1]])
nrow(inertial_signals_train[[1]])   # 7352
ncol(inertial_signals_train[[1]])   # 128 cols

head(inertial_signals_train[[2]])
nrow(inertial_signals_train[[2]])   # 11337 rows ?!?!?!
ncol(inertial_signals_train[[2]])   # 196 cols ?!?!?!

# ....

head(y_test)
nrow(y_test) # 2947
ncol(y_test) # 1 col

#        ~ fin ~





























