#load library
library(dplyr)

#Download and unzip  -Note: you will need to set up a working directory if you  havent already done so 
file <- "dataset3.zip"
site <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(site, file,method="curl")
unzip(file) 


#Loading tables from various text docs in the unzipped folder
#These tables need to be setup to be merged later on
features <- read.table("UCI HAR Dataset/features.txt")
colnames(features) <- c("n","functions")

activity_labels <- read.table("UCI HAR Dataset/activity_labels.txt") 
colnames(activity_labels) <- c("code", "activity")

subject_test <- read.table("UCI HAR Dataset/test/subject_test.txt")
colnames(subject_test) <- "subject"


x_test <- read.table("UCI HAR Dataset/test/X_test.txt")
colnames(x_test) <- features$functions


y_test <- read.table("UCI HAR Dataset/test/y_test.txt")
colnames(y_test) <- "code"


subject_train <- read.table("UCI HAR Dataset/train/subject_train.txt")
colnames(subject_train) <- "subject"


x_train <- read.table("UCI HAR Dataset/train/X_train.txt")
colnames(x_train) <- features$functions


y_train <- read.table("UCI HAR Dataset/train/y_train.txt")
colnames(y_train) <- "code"




#1 Merge  test train
merged_x <- rbind(x_train, x_test)
merged_y <- rbind(y_train, y_test)
merged_subject <- rbind(subject_train, subject_test)
complete_data <- cbind(merged_subject, merged_y, merged_x)


#2 extracting mean and std
dataset <- complete_data[, grep("activity|subject|mean|std", names(complete_data))]

#3 naming features with activities
dataset$code <- activity_labels[dataset$code, 2]
#4 appropriate labels
names(dataset)[2] = "activity"
names(dataset)<-gsub("Acc", "Accelerometer", names(dataset))
names(dataset)<-gsub("Gyro", "Gyroscope", names(dataset))
names(dataset)<-gsub("BodyBody", "Body", names(dataset))
names(dataset)<-gsub("Mag", "Magnitude", names(dataset))
names(dataset)<-gsub("^t", "Time", names(dataset))
names(dataset)<-gsub("^f", "Frequency", names(dataset))
names(dataset)<-gsub("tBody", "TimeBody", names(dataset))
names(dataset)<-gsub("-mean()", "Mean", names(dataset), ignore.case = TRUE)
names(dataset)<-gsub("-std()", "STD", names(dataset), ignore.case = TRUE)
names(dataset)<-gsub("-freq()", "Frequency", names(dataset), ignore.case = TRUE)
names(dataset)<-gsub("angle", "Angle", names(dataset))
names(dataset)<-gsub("gravity", "Gravity", names(dataset))
#5 second independent tidy data set with the average of each variable for each activity and each subject
tidy_data_set <- dataset %>%
  group_by(subject, activity) %>%
  summarise_all(funs(mean))
write.table(tidy_data_set, "tidy_data_set.txt", row.name=FALSE)
