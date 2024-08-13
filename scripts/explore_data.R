library(tidyverse)
library(ratdat)

#chack the type of comlete_old
class(complete_old)

#veiw structure of the data
str(complete_old)

#view firt few rows; by default shows 6 lines
head(complete_old)

#view last few lines
tail(complete_old)

#to get more info about any function put ? before the function name
?head

#to get the summary of each variable in the data
summary(complete_old)

#creating vector from scratch 
num <- c(1,2,3)
class(num)

char <- c("a","b","c")
class(char)

logi <- c(T,F,F,T)
class(logi)

#different type in a vector
num_logi <- c(1, 4, 6, TRUE) 
class(num_logi) #numeric

num_char <- c(1, 3, "10", 6) #
class(num_char) #character

char_logi <- c("a", "b", TRUE)
class(char_logi) #character

tricky <- c("a", "b", "1", FALSE)
class(tricky) #chararcter

combined <- c(num_logi, char_logi)
class(combined)
combined

#hierarchy of data type coercion: logical -> integer -> numerical -> character
#This is based on the increasing space each type can occupy.

#================= Missing Data =========================================#
# missing data is represented as NA in R. NA stands for something that is unknown.
weights <- c( 23, 54, NA, 80)
class(weights)

min(weights)  # Returns NA. since R does not know anything about NA, the minimum of this vector is unknown to R

#exclude missing values from a vector set remove NA to TRUE
min(weights, na.rm = TRUE)

#quantile 
quantile(complete_old$weight, probs = 0.25, na.rm = TRUE)
quantile(complete_old$weight, probs = c(0.25, 0.50, 0.75), na.rm = TRUE)

#generate sequence of integers. n1:n2 generates number including n1, n2
1:10

#using seq() we can generate sequence starting at n1 ending at n2 with a given gap. We can also give the option of the length of generated sequence vector
seq(from = 1, to = 10, by = 2)
seq(from = 0, to = 1, length.out = 20)

#rep() repeates a given value a given number of times
rep("a", times = 10)
rep(c(1,2,3), times = 2)
rep(1:10, times = 3)

#challenge 1
rep(-3:3, times = 3)

#Calculate the quantiles for the complete_old hindfoot lengths at every 5% level (0%, 5%, 10%, 15%, etc.)
quantile_vector <-  seq(from = 0, to = 1, by = 0.05)
quantile_vector
hindfoot_quantile <- quantile(complete_old$hindfoot_length, probs = quantile_vector, na.rm = T)
hindfoot_quantile
min(complete_old$hindfoot_length, na.rm = T)
max(complete_old$hindfoot_length, na.rm = T)

#Factors : categorical variables expressed as levels
sex <- factor(c("male","female","male","male",NA))
sex

levels(sex)

#library for working easily with factors
library(forcats)
#to change level orders'
fct_relevel(sex, c("male","female"))
#change level names
fct_recode(sex,"M" = "male", "F" = "female")

#turns missing values (NA) into factor level
fct_na_value_to_level(sex, "(Missing)")

#convert factor int character vector
as.character(sex)

#beaware
int_factor = factor(c(1990,1991, 1992, 1992))
int_factor
#doing as as.numeric on integer factor will pull out levels and not actual factor year value
as.numeric(int_factor)
#we need to first convert to character than numeric
as.numeric(as.character(int_factor))
