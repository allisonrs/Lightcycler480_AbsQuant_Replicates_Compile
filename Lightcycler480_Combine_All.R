#set environment, install tidyverse and rio as needed
#setwd("C:/users/asmit/Desktop/qPCR_datafiles_LASV/Processed_Nikisins")
#install.packages("tidyverse", "rio")
library(tidyverse)
library(rio)

#take final.csv files from Lightcycler480_Replicates_Name script and merge them all together into one big tibble
files <- list.files(path = ".", pattern = "[final]\\.csv")
merged_tibble <- import_list(files, rbind = TRUE, rbind_label = "File",  setclass = "tibble")

merged_tibble %>%
  filter(!str_detect(Name,'1E\\d')) %>% #filter out standards and drop non-replicates/no concentration (NA)
  tibble() %>%
  drop_na() %>%
  select(-(MeanCp:`STD Cp`)) %>% #remove Cp columns (MeanCp and STD Cp)
  mutate(Dilution = if_else(str_detect(File, ".*1.10_final"), "1:10", "full_strength")) %>% #create column for Dilution strength
  select(-(File)) %>%
  write_csv(file = "LASV_Nikisins_2nd_Derivative_Max_Cleaned_All.csv") #edit filename to what you want it to be
