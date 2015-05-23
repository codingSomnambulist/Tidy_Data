

library(dplyr)
xtest <- read.table("./UCI HAR Dataset/test/X_test.txt")
xtrain <- read.table("./UCI HAR Dataset/train/X_train.txt")
xtest <- tbl_df(xtest)
xtrain <- tbl_df(xtrain)
ytest <- tbl_df(read.table("./UCI HAR Dataset/test/Y_test.txt"))
ytrain <- tbl_df(read.table("./UCI HAR Dataset/train/Y_train.txt"))
features_tbl <- read.table("./UCI HAR Dataset/features.txt")
subjecttest <- read.table("./UCI HAR Dataset/test/subject_test.txt")
subjecttrain <- read.table("./UCI HAR Dataset/train/subject_train.txt")
colnames(ytest) <- "activity_code"
testxy <- cbind(ytest, xtest)
colnames(subjecttest)<- "subject"
test <- cbind(subjecttest, testxy)
test <- tbl_df(test)
colnames(ytrain) <- "activity_code"
trainxy <- cbind(ytrain, xtrain)
colnames(subjecttrain)<- "subject"
train <- cbind(subjecttrain, trainxy)
train <- tbl_df(train)
full_set <- rbind(test, train)
full_set <- tbl_df(full_set)
activity_labels <- tbl_df(read.table("./UCI HAR Dataset/activity_labels.txt"))
colnames(activity_labels) <- c("code", "activity")
label_set <- merge(full_set, activity_labels, by.x="activity_code", by.y="code")
label_set<-tbl_df(label_set)
concise <- select(label_set, c(subject, activity, V1,V2,V3,V4,V5,V6))
colnames(concise)[2:8] <- c("Activity", "TotalAccX","TotalAccY","TotalAccZ", "TotalStdX","TotalStdY","TotalStdZ")
sorted <- arrange(concise, subject, Activity)
sorted <- tbl_df(sorted)
Average <- mutate(sorted, Avg = rowMeans(sorted[3:5]))
sd <- mutate(Average, SD= apply(Average[6:8], 1, sd))
SD <- tbl_df(sd)
almost_tidy <- select(sd, subject, Activity, Avg, SD)
TidyData <- summarize(group_by(almost_tidy, subject, Activity), AvgMean= mean(Avg), AvgSD = mean(SD))
TidyData


