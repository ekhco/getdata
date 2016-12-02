rm(list=ls())
gc()
setwd("~/Dropbox (Personal)/coursera/get_data_assignment")
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

activity_labels <- read.csv("UCI HAR Dataset/activity_labels.txt", header=FALSE, sep=" ")
features  <- read.csv("UCI HAR Dataset/features.txt", header=FALSE, sep=" ")

# read test data --------------------------------------
subject_test <- read.csv("UCI HAR Dataset/test/subject_test.txt", header=FALSE, sep=" ")
x_test <- read.csv("UCI HAR Dataset/test/x_test.txt", header=FALSE, sep=" ")
y_test <- read.csv("UCI HAR Dataset/test/y_test.txt", header=FALSE, sep=" ")

inertial_signals_test <- NULL
test_inert <- list.files("UCI HAR Dataset/test/Inertial Signals")
for (file in test_inert) {
	message("reading in inertial signal: ", file, "...")
	inertial_signals_test[[file]] <- read.csv(sprintf("UCI HAR Dataset/test/Inertial Signals/%s",file), sep=" ", header=FALSE, strip.white=TRUE)
}
names(inertial_signals_test)

# read train data --------------------------------------
subject_train <- read.csv("UCI HAR Dataset/train/subject_train.txt", header=FALSE, sep=" ")
x_train <- read.csv("UCI HAR Dataset/train/x_train.txt", header=FALSE, sep=" ")
y_train <- read.csv("UCI HAR Dataset/train/y_train.txt", header=FALSE, sep=" ")

inertial_signals_train <- NULL
train_inert <- list.files("UCI HAR Dataset/train/Inertial Signals")
for (file in train_inert) {
	message("reading in inertial signal: ", file, "...")
	inertial_signals_train[[file]] <- read.csv(sprintf("UCI HAR Dataset/train/Inertial Signals/%s",file), sep=" ", header=FALSE, strip.white=TRUE)
}
names(inertial_signals_train)

# take a look at data
head(activity_labels) # there are 6 activities
nrow(activity_labels)

head(features) # there are 561 features
nrow(features)

head(subject_test)
nrow(subject_test) # 2947 rows for 9 subjects: 2, 4, 9, 10, 12, 13, 18, 20, 24
table(subject_test)

head(x_test)
nrow(x_test) # 4312
ncol(x_test) # 667 cols

length(inertial_signals_train) # 9 iniertial signals

head(inertial_signals_train[[1]])
nrow(inertial_signals_train[[1]])   # 7615 rows
ncol(inertial_signals_train[[1]])   # 219 cols

head(inertial_signals_train[[2]])
nrow(inertial_signals_train[[2]])   # 11337 rows ?!?!?!
ncol(inertial_signals_train[[2]])   # 196 cols ?!?!?!

# ....

head(y_test)
nrow(y_test) # 2947
ncol(y_test) # 1 col

#        ~ fin ~





























