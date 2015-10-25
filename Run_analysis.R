setwd("~/Documents/Coursera/UCI HAR Dataset")
set.seed(10)
library(dplyr)
library(rmarkdown)

#Training
subject=read.table(file = "subject_train.txt")
names(subject)="Subject"
x_train=read.table(file = "X_train.txt")
y_train=read.table(file = "y_train.txt")
names(y_train)="Activity"
train=cbind(subject, y_train, x_train)
dim(train)


#Test
subject=read.table(file = "subject_test.txt")
names(subject)="Subject"
x_test=read.table(file = "X_test.txt")
y_test=read.table(file = "y_test.txt")
names(y_test)="Activity"
test=cbind(subject, y_test, x_test)
dim(test)


# merging train and test sets
data=rbind(train, test)


# Uses descriptive activity names to name the activities in the data set
features=read.table(file = "features.txt")
f=as.character(features[,2])
names(data)=paste(c("Subject", "Activity", f), sep = " ")


# Extracts only the measurements on the mean and standard deviation for each measurement
d<-data[,grepl("\\bmean\\b|\\bstd\\b|subject|activity",colnames(data),ignore.case = T)]


#  Appropriately labels the data set with descriptive variable names
labels=read.table(file = "activity_labels.txt")
head(labels)
l=as.character(labels[,2])
l
d$Activity=as.factor(d$Activity)
levels(d$Activity)=l


# From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.
d$Subject=as.factor(d$Subject)
averages=aggregate(x = d[,3:ncol(d)], by = list(d$Subject, d$Activity), FUN = mean)
names(averages)[1]="Subject"
names(averages)[2]="Activity"

