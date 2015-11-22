library(reshape2)

setwd("C:/Users/mmahajan/Desktop/Temp Files/Kag/R/getdata-projectfiles-UCI HAR Dataset/UCI HAR Dataset")


# Read in the data from files
features     = read.table('./features.txt',header=FALSE); #imports features.txt
activityType = read.table('./activity_labels.txt',header=FALSE); #imports activity_labels.txt
subjectTrain = read.table('./train/subject_train.txt',header=FALSE); #imports subject_train.txt
xTrain       = read.table('./train/x_train.txt',header=FALSE); #imports x_train.txt
yTrain       = read.table('./train/y_train.txt',header=FALSE); #imports y_train.txt




# Load activity labels + features
activityLabels <- read.table("./activity_labels.txt")
activityLabels[,2] <- as.character(activityLabels[,2])
features <- read.table("./features.txt")
features[,2] <- as.character(features[,2])


# Extract only the data on mean and standard deviation
featuresWanted <- grep(".*mean.*|.*std.*", features[,2])
featuresWanted.names <- features[featuresWanted,2]
featuresWanted.names = gsub('-mean', 'Mean', featuresWanted.names)
featuresWanted.names = gsub('-std', 'Std', featuresWanted.names)
featuresWanted.names <- gsub('[-()]', '', featuresWanted.names)

print(featuresWanted.names)


# Load the datasets
train <- read.table("./train/x_train.txt")[featuresWanted]
trainActivities <- read.table("./train/Y_train.txt")
trainSubjects <- read.table("./train/subject_train.txt")
train <- cbind(trainSubjects, trainActivities, train)

test <- read.table("./test/X_test.txt")[featuresWanted]
testActivities <- read.table("./test/Y_test.txt")
testSubjects <- read.table("./test/subject_test.txt")
test <- cbind(testSubjects, testActivities, test)

# merge datasets and add labels
allData <- rbind(train, test)

colnames(allData) <- c("subject", "activity", featuresWanted.names)


# turn activities & subjects into factors
allData$activity <- factor(allData$activity, levels = activityLabels[,1], labels = activityLabels[,2])
allData$subject <- as.factor(allData$subject)

allData.unique <- melt(allData, id = c("subject", "activity"))
allData.avg <- dcast(allData.unique, subject + activity ~ variable, mean)

write.table(allData.avg, "tidy.txt", row.names = FALSE, quote = FALSE)
