### environment setup; change folder with .tsv files accordingly. Install tidyverse if needed.

#setwd("C:/Users/asmit/Desktop/qPCR_datafiles_LASV/Processed_Nikisins")
#install.packages(tidyverse)

library(tidyverse)

###import .tsv of individual well PCR results, formatting, natural sort. Export cleaned file as .csv.
singlet_files <- list.files(path = ".", pattern = "[^replicates]\\.tsv")

tibble_singlet <- function(x) { ###function to create tibble from singlet files
  cleanup_tibble <- as_tibble(read_tsv(x, col_names = TRUE, skip = 1))
}

singlet_cleanup <- function(x) { ##function to clean singlet files
  new_file <- str_replace(x, "(.*).tsv", "\\1_cleaned.csv")
  tibble_singlet(x) %>%
    select("Pos", "Name", "Cp", "Concentration") %>%
    .[str_order(.$Pos, numeric = TRUE),] %>%
    write_csv(file = new_file)
}

lapply(singlet_files, singlet_cleanup) ##run (singlet_cleanup) on files in singlet_files

###import .tsv of Replicates file, split $Samples column in two and re-combine in Replicates.
singlet_cleaned <- list.files(path = ".", pattern = "[_cleaned]\\.csv")
matching_pair_files <- list.files(path = ".", pattern = "[replicates]\\.tsv")

cleaned_tibble <- function(y) { ##function to read cleaned .csv files as tibble
  Pos_tibble <- as_tibble(read_csv(y, col_names = TRUE)) 
}

match <- function(m){ ##function to make tibble of replicate file
  match_tibble <- as_tibble(read_tsv(m, col_names = TRUE, skip = 1))
}

merged <- function(m,y){ ##function to merge match tibble with specific column of cleaned_tibble tibble
  organ <- regmatches(m, regexpr("(Liver|Lung|Kidney|Spleen|AVL)", m)) #optional, indicates tissue from file name
  output_file <- str_replace(m, "(.*)_replicates.tsv", "\\1_final.csv")
  match(m) %>%
    mutate("R1" = gsub(x = .$Samples, pattern = "^(.*),.*", replacement = "\\1")) %>%
    mutate("R2" = gsub(x = .$Samples, pattern = ".*,\\s(.*)", replacement = "\\1")) %>%
    pivot_longer(cols = c("R1", "R2"), names_to ="Well Pairs", values_to = "Wells") %>%
    select("MeanCp", "STD Cp", "Mean conc", "STD conc", "Wells") %>%
    relocate("Wells", 1) %>%
    right_join((cleaned_tibble(y)), by = c("Wells"="Pos")) %>%
    .[str_order(.$Wells, numeric = TRUE),] %>%
    select("Name", "MeanCp", "STD Cp", "Mean conc", "STD conc") %>%
    distinct(Name, .keep_all = TRUE) %>%
    add_column(Organ = organ) %>% #optional if not needing to indicate tissue type
    write_csv(file = output_file) ###Export modified Replicates tibble to new .csv file.
}

mapply(merged, matching_pair_files, singlet_cleaned, SIMPLIFY = FALSE)
