library(dplyr)

# Setting up a file to read, combine, and analyse UCI Data on Samsung smart phone

## Human Activity Recognition Using Smartphone Dataset
# Link: http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones

# First, let's set our Working Directory
setwd("C:/Users/castillo/Downloads/UCI HAR Dataset/")

# Next, we'll assign the different text files to variables
data_activity_label <- read.table("features.txt", stringsAsFactors = F)

## Training Data Set

train_subject <- read.table("train/subject_train.txt")
train_label <- read.table("train/y_train.txt")
train_data <- read.table("train/X_train.txt")

## Let's label the activity first
colnames(train_data) <- data_activity_label$V2

## Training data mostly ready (aside from the Triaxial accelerations of x,y,z)
## We'll also mark what dataset these came from
train_data <- tbl_df(cbind.data.frame(train_data, person = train_subject$V1, activity = train_label$V1, data_source = "train"))

## Let's load the Testing Data set
test_subject <- read.table("test/subject_test.txt")
test_label <- read.table("test/y_test.txt")
test_data <- read.table("test/X_test.txt")

colnames(test_data) <- data_activity_label$V2
## We won't label these columns since they'll be merged with the Train dataset
test_data <- tbl_df(cbind.data.frame(test_data, person = test_subject$V1, activity = test_label$V1, data_source = "test"))


# Now let's make a big database... but we'll clear out some memory first:
rm(data_activity_label, test_label, test_subject, train_label, train_subject)

full_data <- rbind(test_data, train_data)

rm(test_data, train_data)
#####
# We will extract columns containing Mean and StdDev
#####

# Note: Using 4 lines to do the same thing? Surely there's a better way...
c_means <- which(grepl("mean", colnames(full_data)), arr.ind = T)
means_df <- full_data[, c_means]

c_stdev <- which(grepl("std", colnames(full_data)), arr.ind = T)
std_df <- full_data[, c_stdev]


# We'll combine the two mini-df's, and then clear the steps to free up some memory
df_stats <- cbind(means_df, std_df, ActivityLabel = full_data$activity, Subject = full_data$person)

rm(means_df, std_df)

# Next we'll add in the Activity Index
activity_key <- c("walking", "walking_upstairs", "walking_downstairs", "sitting", "standing", "laying")
df_stats <- df_stats %>% mutate(ActivityName = activity_key[ActivityLabel])

# Lastly, we summarize the stats

df_stats %>% group_by(ActivityName)
