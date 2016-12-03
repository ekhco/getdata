## CODEBOOK for tidydata.txt

Copyright Eric Chow 2016
Baltimore, MD
eric.khc@gmail.com

this codebook describes the variables, methods, and sources of the dataset tidydata.txt.  Tidydata.txt was created using the run_analysis.R file.  

## Sources
The tidydata.txt dataset was extracted from data available at https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip.  This data was originally partitioned into a test and training dataset.

## Methods and Aggregations
the test and training data were recombined into a single dataset.  A total of n=10299 sample measurements were included.  These samples came from 1...30 subjects (originally divided into test and training subjects), who each performed 1...6 activities, including walking, walking upstairs, walking downstairs, sitting, standing, and laying.

Originally 561 measurements were taken (called 'features'). Only features that had the keywords 'mean()' or "std()' were retained. Out of the original 561, only 66 measurements were retained.  For each subject-activity, the average of the measurements across samples (varies by subject-activity) was taken and is represented in columns 4:69 in tidydata.txt.

## Variables
* subjectId: uniquely identifies 1...30 subjects.
* activityId: uniquely identifies 1...6 activities.
* activity: a factor with it's corresponding activityId, gives a description of what the activity is
* tBodyAccmeanX, tBodyAccmeanY, ... , fBodyBodyGyroJerkMagstd: 66 averaged (across samples) of mean and std measurements taken from accelerometers of the subjects doing each activity.

## Contact
Please email eric at eric.khc@gmail.com for questions regarding this data or code.

## License and Citation
[1] Davide Anguita, Alessandro Ghio, Luca Oneto, Xavier Parra and Jorge L. Reyes-Ortiz. Human Activity Recognition on Smartphones using a Multiclass Hardware-Friendly Support Vector Machine. International Workshop of Ambient Assisted Living (IWAAL 2012). Vitoria-Gasteiz, Spain. Dec 2012

This dataset is distributed AS-IS and no responsibility implied or explicit can be addressed to the authors or their institutions for its use or misuse. Any commercial use is prohibited.
