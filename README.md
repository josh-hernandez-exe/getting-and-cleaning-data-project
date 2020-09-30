# Introduction

This project processes data from *Human Activity Recognition Using Smartphones Dataset* for the course project of **Getting and Cleaning Data** for the Data Science specialization from Johns Hopkins University.

# Contents

`run_analysis.R`
- The main script.
    - It will download the data set if not in the current directory, then load the relevent csv files into memory.
    - All features that contain `mean()` and `std()` are extracted for the `X_train.csv` and `X_test.csv` data sets.
    - The features are renamed to be lower case, but still have `_` for easier readability.
    - The  `Y` data sets are appended to the training data sets.
    - The `Y` values are reassigned to the activity names.
    - The test and traning sets are then combined into one data set.
    - The resulting data frame is written to a file `uci_har_dataset.csv`.

`CodeBook.md` describes the variables that are extracted from the original data set.
