library(reshape2)

#Declaring the data that belongs to neither the train or test folders
VariableLabels <- read.table("features.txt")
ActivityLabels <- read.table("activity_labels.txt")

#Declaring the data found in the train foder; This data was also combined to make one larger dataset
TrainVariables <- read.table("train/X_train.txt")
TrainActivity <- read.table("train/y_train.txt")
TrainSubjects <- read.table("train/subject_train.txt")
Train <- data.frame(TrainSubjects,TrainActivity,TrainVariables)

#Declaring the data found in the test folder; This data was also combined to make one larger dataset
TestVariables <- read.table("test/X_test.txt")
TestActivity <- read.table("test/y_test.txt")
TestSubjects <- read.table("test/subject_test.txt")
Test <- data.frame(TestSubjects,TestActivity,TestVariables)

#Combining the two larger datasets; Also ordering them, adding labels, and giving each activity a text value all for enhanced readability
CombinedData <- rbind(Train,Test)
OrderedData <- CombinedData[order(CombinedData$V1,CombinedData$V1.1),]
DataLabels <- append(c("Subject","Activity"),as.vector(VariableLabels$V2))
DataLabels <- gsub(pattern="\\(\\)", x=DataLabels, replacement="")
colnames(OrderedData) <- DataLabels
OrderedData$Activity <- factor(OrderedData$Activity, labels = ActivityLabels$V2)

#Creating new dataset that only includes variables dealing with mean or std; dataset is then extracted into a seperate file
MeanValues <- grep("mean", DataLabels)
STDValues <- grep("std", DataLabels)
IncludedValues <- append(c(1,2),append(MeanValues,STDValues))
MeanAndSTD <- OrderedData[,IncludedValues]
write.csv(MeanAndSTD, "./extracteddata.csv")

#Creating tidy dataset by melting earlier dataset and recasting with mean values for each variable for each activity and each subject
MeltedMAS <- melt(MeanAndSTD,id=c("Subject","Activity"),measure.vars= colnames(MeanAndSTD[3:81]))
FinalTidy <- dcast(MeltedMAS, Subject + Activity ~ variable,mean)
write.table(FinalTidy, "./finaltidy.txt")