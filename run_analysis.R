setwd("~/coursera/getting and cleaning/UCI HAR Dataset")
dane_test<-read.table("./test/X_test.txt")
labels_test<-read.table("./test/Y_test.txt")
subject_test<-read.table("./test/subject_test.txt")
dane_train<-read.table("./train/X_train.txt")
labels_train<-read.table("./train/Y_train.txt")
subject_train<-read.table("./train/subject_train.txt")
features<-read.table("./features.txt")
activity_labels<-read.table("./activity_labels.txt")

#adding column names from file features.txt

colnames(dane_test)<-features[,2]
colnames(dane_train)<-features[,2]

#replacing activity labels by descriptive labels

labels_test1<-merge(labels_test, activity_labels, by="V1")
labels_train1<-merge(labels_train, activity_labels, by="V1")

#adding labels to sets

dane_test$labels<-labels_test1$V2
dane_train$labels<-labels_train1$V2

#adding subject to sets

dane_test$subjects<-subject_test$V1
dane_train$subjects<-subject_train$V1


#merging data
data1<-rbind(dane_test,dane_train)

#extracting only columns with mean and standard deviation +labels (activity labels) and subject

data_clear<-data1[,grep("mean|std|labels|subjects",names(data1))]

library(dplyr)

#average for each activity

#grouping by activity and subject
by_activity <-group_by(data_clear,labels,subjects)

#summarizing - calculating mean gropued by activity and subject and creating new set of data - means
means<- summarize_each(by_activity,funs(mean))

write.table(means, file="./tidyData_means.txt", row.name=FALSE)