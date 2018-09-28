# set env
# install.packages ("dplyr")
# install.packages ("tidyverse")

# Set files dirctory from where to read data (csv files). 
filesDir <- "C:\\work\\dataScience\\springboard\\springboardIntro\\assignments\\SprinboardIntroAssignment"
#setwd(filesDir)
#getwd() # where am I?
#list.files() # files in the current folder

library ("tidyverse")
library("dplyr")


## Load the original titanic data spreadsheet
## ────────────────────────

titanicRaw_df <- read.csv("titanic_original.csv", header = TRUE, stringsAsFactors = FALSE)

# replace missing embark with S:
titanicClean_df <- titanicRaw_df #%>% filter(embarked == "" | is.na(embarked)) %>%
#  mutate (embarked <- "S")
titanicClean_df$embarked <- ifelse((titanicClean_df$embarked == "") | 
                                      (titanicClean_df$embarked == " "),
                                   "S", titanicClean_df$embarked)

# replace missing Age with mean Age:
titanicClean_df$age <- ifelse(is.na(titanicClean_df$age), 
                              mean(titanicClean_df$age, na.rm = TRUE),
                              titanicClean_df$age)

# replace missing lifeboat with dummy value "None":
titanicClean_df$boat <- ifelse (is.na(titanicClean_df$boat) | titanicClean_df$boat == "",
                                "None", titanicClean_df$boat)

# Missing Cabin values can be replaced wth "Missing"; 
# Some of the low fares also have cabins and some pclass of 1 don't;
# so its very likely that we have incomplete info on cabin
titanicClean_df$cabin <- ifelse(titanicClean_df$cabin == "", "Missing", titanicClean_df$cabin)

titanicClean_df <- titanicClean_df %>%
  mutate(has_cabin_number = ifelse(cabin=="Missing", 0,1))

# write out the cleaned data frame and submit the assignment!
write.csv(titanicClean_df, "titanic_clean.csv")



