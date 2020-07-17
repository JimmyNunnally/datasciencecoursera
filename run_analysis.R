library(dplyr)

#loading data
file <- "dataset3.zip"
fileURL <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(fileURL, file, method="curl")
unzip(file) 
#devloping table
features <- read.table("UCI HAR Dataset/features.txt", col.names = c("n","functions"))
activities_labels <- read.table("UCI HAR Dataset/activity_labels.txt", col.names = c("code", "activity"))
subject_test <- read.table("UCI HAR Dataset/test/subject_test.txt", col.names = "subject")
x_test <- read.table("UCI HAR Dataset/test/X_test.txt", col.names = features$functions)
y_test <- read.table("UCI HAR Dataset/test/y_test.txt", col.names = "code")
subject_train <- read.table("UCI HAR Dataset/train/subject_train.txt", col.names = "subject")
x_train <- read.table("UCI HAR Dataset/train/X_train.txt", col.names = features$functions)
y_train <- read.table("UCI HAR Dataset/train/y_train.txt", col.names = "code")

#Merge 
X <- rbind(x_train, x_test)
Y <- rbind(y_train, y_test)
Subject <- rbind(subject_train, subject_test)
Merged_Data <- cbind(Subject, Y, X)
#extracting mean and std
dataset <- Merged_Data %>% select(subject, code, contains("mean"), contains("std"))
#naming features with activities
dataset$code <- activities_labels[dataset$code, 2]
#appropriate labels
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
#second independent tidy data set with the average of each variable for each activity and each subject
tidy_data_set <- dataset %>%
  group_by(subject, activity) %>%
  summarise_all(funs(mean))
write.table(tidy_data_set, "tidy_data_set.txt", row.name=FALSE)


