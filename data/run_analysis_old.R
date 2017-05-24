## Set working directory
getwd()
setwd("C:/Users/bseely/OneDrive/R Projects/CourseraCleaningWeek4Project/CourseraCleaningWeek4Project/Week4FinalProject/data/UCI HAR Dataset")

## load tidyr, dplyr, and data.table
library(tidyr)
library(dplyr)
library(data.table)

## Read in activity labels
activity_labels <- read.table("./activity_labels.txt")
activity_labels

## Read in feature names
feature_names <- read.table("./features.txt")
feature_names

## Read in test data
X_test <- read.table("./test/X_test.txt")
head(X_test,20)
y_test <- read.table("./test/y_test.txt")
head(y_test,20)
subject_test <- read.table("./test/subject_test.txt")
head(subject_test,20)

## Read in train data
X_train <- read.table("./train/X_train.txt")
head(X_train,20)
y_train <- read.table("./train/y_train.txt")
head(y_train,20)
subject_train <- read.table("./train/subject_train.txt")
head(subject_train,20)

## Combine X_train and X_test using rbind
X_all<-rbind(X_train,X_test)
dim(X_all)
## Clean up X_train and X_test
rm(X_train, X_test)

## Combine y_train and y_test using rbind
y_all<-rbind(y_train,y_test)
dim(y_all)
## Clean up y_train and y_test
rm(y_train, y_test)

## Combine subject_train and subject_test using rbind
subject_all<-rbind(subject_train,subject_test)
dim(subject_all)
## Clean up y_train and y_test
rm(subject_train, subject_test)

## Add the column names, subjects and activities
names(X_all)<-feature_names$V2
names(subject_all)<-"subject"
names(y_all)<-"activity_idx"
names(activity_labels) <- c("activity_idx", "activity")

## Drop columns not containing mean, std deviation
X_all<-subset(X_all, select = grep("mean\\(|std", names(X_all)))
head(X_all)

## Append columns for y and subject labels
allData<-cbind.data.frame(subject_all, y_all, X_all)
rm(subject_all, y_all, X_all)

## Add activity labels
allData<-merge(allData, activity_labels, by = "activity_idx")

## Add rownames as a column to allow soring in original order
allData<-tibble::rownames_to_column(allData, "orig_order")

## Make backup copy of allData
allDatacc<-allData

## restore allData from backup copy
## allData<-allDatacc

## Make tab-delimited file of allData
write.table (allData, "./allData.txt", sep="\t", row.names=FALSE)

## reshape data into rows for measure
allData<-gather(allData, key, value, -orig_order, -subject, -activity_idx, -activity)
allData<-cbind(allData,key2=rep(allData$key))
allData<-separate(allData, key2, c("measure", "statistic", "measurement_axis"), "-", fill="right")
allData<-allData[ , !(names(allData) %in% c("activity_idx","measure","measurement_axis"))]

## Eliminate mean() and std() from the key
allData$key<-sub("-mean\\(\\)","", allData$key)
allData$key<-sub("-std\\(\\)","", allData$key)

## Get everything in order
(allData%>%select(subject, activity, key, statistic, orig_order, value)%>%
        arrange(subject, activity, key, statistic, orig_order)) -> allData_thin

## Make tab-delimited file of allDatat_thin
write.table (allData_thin, "./allData_thin.txt", sep="\t", row.names=FALSE)

## Create wide table with means
## OLD STEP ONE group_by(subject, activity, key, statistic)%>%

(allData %>% spread(statistic, value, fill=NA)%>%
        group_by(subject, activity, key) %>%
        select(-orig_order)%>%
        summarise_each(funs(mean))) -> allAverages

## Make tab-delimited file of allAverages
write.table (allAverages, "./allAverages.txt", sep="\t", row.names=FALSE)

str(allAverages)
names(allAverages)
head(allAverages)
tail(allAverages)


