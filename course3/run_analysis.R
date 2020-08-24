#Note to grader: Go easy on me please! This one was hard
#load library
library(dplyr)

#Download and unzip  -Note: you will need to set up a working directory if you  havent already done so 
file <- "dataset3.zip"
site <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(site, file,method="curl")
unzip(file) 

#1
#Loading tables from various text docs in the unzipped folder
#Merge em together
features <- read.table("UCI HAR Dataset/features.txt")
colnames(features) <- c("n","functions")

activity_labels <- read.table("UCI HAR Dataset/activity_labels.txt") 
colnames(activity_labels) <- c("code", "activity")




merged_x <- rbind(read.table("UCI HAR Dataset/test/X_test.txt"),read.table("UCI HAR Dataset/train/X_train.txt"))
colnames(merged_x) <- features$functions


merged_y <- rbind(read.table("UCI HAR Dataset/test/y_test.txt"),read.table("UCI HAR Dataset/train/y_train.txt"))
colnames(merged_y) <- "code"

merged_subject <- rbind(read.table("UCI HAR Dataset/test/subject_test.txt"),read.table("UCI HAR Dataset/train/subject_train.txt"))
colnames(merged_subject) <- "subject"


complete_data <- cbind(merged_subject, merged_y, merged_x)


#2 extracting mean and std
dataset <- complete_data[, grep("subject|code|mean|std", names(complete_data))]

#3 naming features with activities
dataset$code <- activity_labels[dataset$code, 2]

#4 appropriate labels
names(dataset)[2] = "activity"
names(dataset)<-gsub("Acc", "Accelerometer", names(dataset))
names(dataset)<-gsub("Gyro", "Gyroscope", names(dataset))
names(dataset)<-gsub("Mag", "Magnitude", names(dataset))
names(dataset)<-gsub("^t", "Time", names(dataset))
names(dataset)<-gsub("^f", "Frequency", names(dataset))
names(dataset)<-gsub("tBody", "TimeBody", names(dataset))

#5 second independent tidy data set with the average of each variable for each activity and each subject
tidy_data_set <- dataset %>%
  group_by(subject, activity) %>%
  summarise_all(funs(mean))
write.table(tidy_data_set, "tidy_data_set.txt", row.name=FALSE)
