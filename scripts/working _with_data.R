library(tidyverse)

#read the csv data in source object. Our working directory is the the top folder.
surveys <- read_csv("data/cleaned/surveys_complete_77_89.csv")

#check the surveys class which is tibble.
class(surveys)

#select() - for selecting columns of a given data frame. 
selected_surveys <- select(surveys, plot_id, species_id, hindfoot_length)
selected_surveys

#select all column except few given
selected_surveys <- select(surveys, -record_id, -year)
selected_surveys

#select column based on numerical order e.g. 3rd, 4th, 5th and 10th
selected_surveys <- select(surveys, c(3:5, 10))
selected_surveys

#select column based on certain criteria
selected_surveys <- select(surveys, where(is.numeric))
selected_surveys

selected_surveys <- select(surveys, where(anyNA)) # returns all the column which has NA as one of its value
selected_surveys

#filter() - for filtering out rows from the data frame on the basis of a given criteria.
filtered_surveys <- filter(surveys, year == 1985)
filtered_surveys

filtered_surveys <- filter(surveys, species_id %in% c("RM","DO"))
filtered_surveys
# we can have more than one condition for filtering.
filtered_surveys <- filter(surveys, year <= 1988 & !is.na(hindfoot_length))
filtered_surveys

#challenge1 : Use the surveys data to make a data.frame that has only data with years from 1980 to 1985.
surveys_subset_1 = filter(surveys, year >= 1980 & year <= 1985)
surveys_subset_1

#challenge2 : Use the surveys data to make a data.frame that has only the following columns, in order: year, month, species_id, plot_id.
source_subset_2 <- select(source, year, month, species_id, plot_id) 
source_subset_2


#Using select() and filter() together.
#1. Nesting
surveys_subset <- filter(select(surveys, -day), month >= 7)
surveys_subset

#2. intermediate object, essentially nesting explicitly for more readability but require intermediate objects
selected_surveys <- select(surveys, -day)
surveys_subset <- filter(selected_surveys, month >=7)
surveys_subset

#3. Piping
surveys_subset <- surveys %>% 
  select(-day) %>% 
  filter(month >=7)
surveys_subset

#challenge3 : Use the surveys data to make a data.frame that has the columns record_id, month, and species_id, with data from the year 1988. Use a pipe between the function calls.
#we need to filter first as we will loose the year column information if we select first.
surveys_subset_3 <- surveys %>% 
  filter(year == 1988) %>% 
  select(record_id, month, species_id)
surveys_subset_3
