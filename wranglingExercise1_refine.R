library(ggplot2)
library ("tidyverse")
library("dplyr")

setwd("C:/work/dataScience/springboard/springboardIntro/assignments/SprinboardIntroAssignment")

##   You might also start by listing the files in your working directory

getwd() # where am I?
list.files() # files in the current folder

## Load the refine data
## ────────────────────────

# read the states data
refineRaw_df <- read.csv("refine.csv", header = TRUE)

refineRaw_df$company[substr(refineRaw_df$company,1,1) =='A' | substr(refineRaw_df$company,1,1) =='a'] = 'akzo'
refineRaw_df$company[substr(refineRaw_df$company,1,1) =='P' | substr(refineRaw_df$company,1,1) =='p'] = 'philips'
refineRaw_df$company[substr(refineRaw_df$company,1,1) =='V' | substr(refineRaw_df$company,1,1) =='v'] = 'van houten'
refineRaw_df$company[substr(refineRaw_df$company,1,1) =='U' | substr(refineRaw_df$company,1,1) =='u'] = 'unilever'

product_code  <- c("p", "x", "v", "q")
product_category <- c("Smartphone", "Laptop", "TV", "Tablet") 
lkupPC <- data.frame (product_code ,product_category)
lkupPC$product_code <- as.character(lkupPC$product_code)

refineRaw_df <- refineRaw_df %>% 
  mutate (product_code = substr(Product.code...number, 1, 1),
          product_number = substr(Product.code...number, 3, 1000000L),
          full_address = paste(address, city, country, sep = ","),
          company_philips = as.numeric((company == "philips")),
          company_akzo = as.numeric((company == "akzo")),
          company_van_houten = as.numeric((company == "van houten")),
          company_unilever = as.numeric((company == "unilever")) ) %>%
  left_join (lkupPC, by = c("product_code" )) %>%
  select (company:product_category) %>%
  mutate ( product_smartphone = as.numeric((product_category == "Smartphone")),
           product_tv = as.numeric((product_category == "TV")),
           product_laptop = as.numeric((product_category == "Laptop")),
           product_tablet = as.numeric((product_category == "Tablet")) )

refine_clean_df <- refineRaw_df %>%
  select (company, product_code, product_number, product_category, full_address, 
          company_philips:company_unilever, product_smartphone : product_tablet)

write.csv(refine_clean_df, "refine_clean.csv")

