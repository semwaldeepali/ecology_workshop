library(tidyverse)
library(lubridate)
library(ggplot2)

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

#mutate to create new columns.
surveys %>% 
  mutate(weight_kg = weight/1000, weight_lbs = weight_kg * 2.2) %>% 
  filter( !is.na(weight))

#combining multiple columns
surveys %>% 
  mutate(date = paste(day,month, year, sep = "-"))

#change column position
surveys %>% 
  mutate(date = paste(day, month, year, sep = "-")) %>% 
  relocate(date, .after = year)

#to convert date from char to date numeric type using 1. function from lubridate packgae
surveys %>% 
  mutate(date = paste(day, month, year, sep = "-"),
         date = dmy(date)) %>% 
  relocate(date, .after = year)
#to convert date from char to date numeric type using as.Date() needs YYYY-MM-DD format
surveys %>% 
  mutate(date = paste(year, month, day, sep = "-"),
         date = as.Date(date)) %>% 
  relocate(date, .after = year)

#using %>%  inside other function
surveys %>% 
  mutate(date = paste(day, month, year, sep = "-") %>% dmy()) %>% 
  relocate(date, .after = year)

#challenge 4 : Because the ggplot() function takes the data as its first argument, you can actually pipe data straight into ggplot(). Try building a pipeline that creates the date column and plots weight across date.
surveys %>% 
  mutate(date = paste(day, month, year, sep = "-") %>% dmy()) %>% 
  relocate(date, .after = year) %>% 
  ggplot(mapping = aes(x = date, y = weight)) + geom_point(aes(alpha = 0.1)) + theme(legend.position = "none") 


#split apply and combine approach
#dplyr package functions : groupby and summarize.

surveys %>% 
  group_by(sex) %>% 
  summarize(mean_weight = mean(weight, na.rm = T))

#summarizing more than one variable
surveys %>% 
  group_by(sex) %>% 
  summarize(mean_weight = mean(weight, na.rm = T), n = n())

#grouping based on multiple variables is also possible
surveys %>% 
  group_by(species_id, sex) %>% 
  summarize(mean_weight = mean(weight, na.rm = T), n = n())

#filtering NA weights
mean_weight_summary <- surveys %>% 
  filter(!is.na(weight)) %>% 
  group_by(species_id, sex) %>% 
  summarize(mean_weight = mean(weight, na.rm = T), n = n())

mean_weight_summary %>%  
  arrange(mean_weight) #order the output in ascending mean_weight 

mean_weight_summary %>%  
  arrange(desc(mean_weight)) #order the output in descending mean_weight

#remove groups at the end if not needed for future operations (Note: Read more on this.)
mean_weight_summary %>% 
  ungroup()

#Use mutate to create a new column that is the function of one or more summarized group variable (e.g. mean)
surveys %>% 
  filter(!is.na(weight)) %>% 
  group_by(species_id, sex) %>% 
  mutate(mean_weight = mean(weight, na.rm = T),
         weight_diff = weight - mean_weight)

#challenge 5 : Use the split-apply-combine approach to make a data.frame that counts the total number of animals of each sex caught on each day in the surveys data.
surveys %>% 
  filter(!is.na(sex)) %>% 
  mutate(date = paste(year, month, day, sep = "-") %>% ydm()) %>% 
  group_by(date,sex) %>% 
  summarise(total = n())

#challenge 6 : Now use the data.frame you just made to plot the daily number of animals of each sex caught over time. 
#It’s up to you what geom to use, but a line plot might be a good choice. You should also think about how to differentiate which data corresponds to which sex.