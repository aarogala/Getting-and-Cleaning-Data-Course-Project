
labels_test<-read.table('UCI HAR Dataset/test/y_test.txt')
labels_train<-read.table('UCI HAR Dataset/train/y_train.txt')
test<-read.table('UCI HAR Dataset/test/x_test.txt')
train<-read.table('UCI HAR Dataset/train/x_train.txt')
features<-read.table('UCI HAR Dataset/features.txt')
activity_labels<-read.table('UCI HAR Dataset/activity_labels.txt')
subject_test<-read.table('UCI HAR Dataset/test/subject_test.txt')
subject_train<-read.table('UCI HAR Dataset/train/subject_train.txt')



test_labeled<-cbind(test,labels_test,subject_test)
train_labeled<-cbind(train,labels_train,subject_train)


data<-rbind(test_labeled,train_labeled)


features[,2]<-gsub('\\(\\)','',features[,2])
features[,2]<-gsub('-','_',features[,2])

colnames(data)<-c(as.character(features[,2]),'label','subject')

library(plyr)
data$activity_labels<-mapvalues(data$label,from=activity_labels[,1],to=as.character(activity_labels[,2]))

data_reduced<-data[,c(grep('mean',colnames(data)), grep('std',colnames(data)),562:564)]

library(dplyr)
analysis<-ddply(data_reduced,.(activity_labels,subject),numcolwise(mean))

write.table(analysis,'analysis.txt',row.name=FALSE)

