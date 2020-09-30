library(tidyr)
library(dplyr)

get_data <- function(data_url) {
  tfile = tempfile()
  download.file(data_url, tfile)
  tfile
}

#' Process the two data frams and attach
#' xtable is extracted for features with mean() and std()
#' ytable is merged with the extracted features
#'
#' @param xtable Data frame of observations
#' @param ytable Data frame of classifications
#' @return Resulting Data frame
process_data = function(xtable, ytable) {
    new_table =  xtable %>%
        # extract columns with are processed means and standard deviations
        select(contains("mean()")|contains("std()")) %>%
        # of the selected columns, reformat column names to be
        # lower case and _ delimieted
        # also remove `-,()` characters
        rename_with(
            ~ tolower(.x) %>%
                gsub("[-,()]","_", .) %>%
                gsub("[_]+", "_", .) %>%
                gsub("[_]+$", "", .)
        )

    # add activity column from ytable
    new_table["activity"] = ytable %>%
        # remap the values in the column to the actual activity names
        transmute(activity=activity_names[V1]) %>%
        # select transmuted column
        select(activity)

    new_table
}

#' The main function of the script
#' will download, unzip, and load the data into memory
main = function(){
    data_set_dir = "UCI HAR Dataset"

    if (file.exists(data_set_dir)) {
        data_url = "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
        data_file = get_data(data_url)
        unzip(data_file)
    }

    activity_names_path = file.path("UCI HAR Dataset","activity_labels.txt")
    feature_names_path = file.path("UCI HAR Dataset","features.txt")
    x_test_path = file.path("UCI HAR Dataset","test","X_test.txt")
    y_test_path = file.path("UCI HAR Dataset","test","y_test.txt")
    x_train_path = file.path("UCI HAR Dataset","train","X_train.txt")
    y_train_path = file.path("UCI HAR Dataset","train","y_train.txt")

    feature_names = read.table(feature_names_path)
    feature_names = feature_names$V2
    activity_names = read.table(activity_names_path)
    # assign variable to global scope
    activity_names <<- activity_names$V2

    x_test = read.table(x_test_path)
    y_test = read.table(y_test_path)
    names(x_test) = feature_names

    x_train = read.table(x_train_path)
    y_train = read.table(y_train_path)
    names(x_train) = feature_names

    new_test = process_data(x_test, y_test)
    new_train = process_data(x_train, y_train)
    full_data = new_test %>% bind_rows(new_train)

    write.table(full_data, file="uci_har_dataset.csv", row.name=FALSE)

    return(full_data)
}

main()
