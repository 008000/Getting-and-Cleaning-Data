features <- read.table('data/features.txt', col.names = c('number', 'feature'))
activityLabels <- read.table('data/activity_labels.txt', col.names = c('code', 'activity'), colClasses = c('factor', 'factor'))

# TODO: read all data (remove nrow limit)
trainSubject <- read.table('data/train/subject_train.txt', nrows = 20, col.names = c('subject'), colClasses = c('factor'))
testSubject <- read.table('data/test/subject_test.txt', nrows = 20, col.names = c('subject'), colClasses = c('factor'))

trainActivity <- read.table('data/train/y_train.txt', nrows = 20, col.names = c('activity'), colClasses = c('factor'))
testActivity <- read.table('data/test/y_test.txt', nrows = 20, col.names = c('activity'), colClasses = c('factor'))

trainData <- read.table('data/train/X_train.txt', nrows = 20, col.names = features$feature)
testData <- read.table('data/test/X_test.txt', nrows = 20, col.names = features$feature)

#move to function
selectedColumns <- grep("mean|std", names(trainData), ignore.case = TRUE)
selctedData <- trainData[, selectedColumns]
