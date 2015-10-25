setting working directory with all the data and the labels
==========================================================

    setwd("~/Documents/Coursera/UCI HAR Dataset")

settng seeds for random values. this makes reproducible the results
===================================================================

    set.seed(10)
    library(dplyr)

    ## 
    ## Attaching package: 'dplyr'
    ## 
    ## The following objects are masked from 'package:stats':
    ## 
    ##     filter, lag
    ## 
    ## The following objects are masked from 'package:base':
    ## 
    ##     intersect, setdiff, setequal, union

    library(rmarkdown)

Reading the 3 different files containing data for the training set
==================================================================

    setwd("~/Documents/Coursera/UCI HAR Dataset")
    subject=read.table(file ="subject_train.txt")
    names(subject)="Subject"
    x_train=read.table(file = "X_train.txt")
    y_train=read.table(file = "y_train.txt")
    names(y_train)="Activity"

merging the datasets by columns
===============================

    train=cbind(subject, y_train, x_train)

Cheking dims of the dataset
===========================

    dim(train)

    ## [1] 7352  563

Reading the 3 different files containing data for the test set
==============================================================

    setwd("~/Documents/Coursera/UCI HAR Dataset")
    subject=read.table(file = "subject_test.txt")
    names(subject)="Subject"
    x_test=read.table(file = "X_test.txt")
    y_test=read.table(file = "y_test.txt")
    names(y_test)="Activity"

merging the datasets by columns
===============================

    test=cbind(subject, y_test, x_test)

Cheking dims of the dataset
===========================

    dim(test)

    ## [1] 2947  563

merging train and test sets to get the complete dataset
=======================================================

    data=rbind(train, test)

Reading "features.txt" to get the names to name the activities in the data set
==============================================================================

    setwd("~/Documents/Coursera/UCI HAR Dataset")
    features=read.table(file = "features.txt")
    f=as.character(features[,2])
    names(data)=paste(c("Subject", "Activity", f), sep = " ")

By using grepl function, code searchs for columns in dataset that contain: "mean" OR "std" by ignoring other caracters at the beginning or at the end of the string. Code also looks for "subject" or "activity" to include other relevant variables in the dataset. ignore.case=TRUE makes the code search for desired strings witout taking care of capital letters.
======================================================================================================================================================================================================================================================================================================================================================================

    d<-data[,grepl("\\bmean\\b|\\bstd\\b|subject|activity",colnames(data),ignore.case = T)]

By reading activities labels from .txt files, code uses the labels to name the 6 levels of the factor variable Activity.
========================================================================================================================

    setwd("~/Documents/Coursera/UCI HAR Dataset")
    labels=read.table(file = "activity_labels.txt")
    head(labels)

    ##   V1                 V2
    ## 1  1            WALKING
    ## 2  2   WALKING_UPSTAIRS
    ## 3  3 WALKING_DOWNSTAIRS
    ## 4  4            SITTING
    ## 5  5           STANDING
    ## 6  6             LAYING

    l=as.character(labels[,2])
    l

    ## [1] "WALKING"            "WALKING_UPSTAIRS"   "WALKING_DOWNSTAIRS"
    ## [4] "SITTING"            "STANDING"           "LAYING"

    d$Activity=as.factor(d$Activity)
    levels(d$Activity)=l

By using aggregate function, code calculates the means of all the variables in the dataset by groupping by Subject and Activity type.
=====================================================================================================================================

    d$Subject=as.factor(d$Subject)
    averages=aggregate(x = d[,3:ncol(d)], by = list(d$Subject, d$Activity), FUN = mean)
    names(averages)[1]="Subject"
    names(averages)[2]="Activity"
