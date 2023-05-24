
while (!is.null(dev.list())) dev.off()
rm(list = ls())
cat('\014')

library(dplyr)
library(tidyverse)
library(ggplot2)
library(lubridate)

#1
imdb <- read.csv(file.choose()) 
head(imdb)

#2
imdb <- imdb %>% mutate(Runtime_num = str_remove(Runtime, "min")) 
imdb$Runtime_num <- as.numeric(imdb$Runtime_num)
# Created column Runtime_num by using str_remove to remove "min" from the Runtime column.
# Changed Runtime_num to numeric in order to plot it

#3
imdb$Released_Year <- year(as.Date(imdb$Released_Year, format = "%Y")) 

imdb2 <- imdb %>%
  select(Released_Year, Runtime_num) %>%
  group_by(Released_Year) %>%
  summarise(avg_runtime = mean(Runtime_num),
            med_runtime = median(Runtime_num))
view(imdb2)
ggplot(imdb2, aes(x = Released_Year)) +
  geom_line(aes(y = avg_runtime), color = "red") +
  geom_line(aes(y = med_runtime), color = "blue") 
# Yes, the the length of the movies is getting longer over the years. The median and average are highly correlated.
# However, it isn't quite a linear progression, there are a few outliers. While for the most part is increases overtime, it actually peaks in the 1930s and 1960s. 
# We converted the Released_Year column from a character into a date. We then created a data frame summarizing the average and median runtime per year and used that to plot.

#4
imdb <- imdb %>% mutate(isComedy = str_detect(Genre, "Comedy")) 
# Used str_detect to detect "Comedy" in the genre column and then proceeded to make a column indicating whether a movie is in the comedy genre with "true" and "false".

#5
imdb3 <- imdb %>% rowwise() %>% mutate(Length_Series_Title = length(strsplit(Series_Title, " ")[[1]]))
  
imdb3 <- imdb3 %>%
    group_by(Released_Year) %>%
    select(Length_Series_Title, Released_Year) %>%
    filter(Length_Series_Title == max(Length_Series_Title)) %>%
    arrange(desc(Length_Series_Title)) %>% distinct()
  
ggplot(imdb3, aes(x = Released_Year, y = Length_Series_Title)) + geom_point()
view(imdb3)
# For the most part, yes, the titles do get longer over the years. However, there is one noteworthy outlier/anomaly 
# in 1964 which has the longest title with 13 words. We first created a column using strsplit to count the words 
# and rowwise which allows us to calculate a row at a time.
# We then filtered to find the max title length of each each year, and plotted accordingly.

#6 - bonus
Genre_Table <- as.matrix(imdb$Series_Title, drop = FALSE)
Genre_Table <- Genre_Table %>% cbind(str_split(imdb$Genre, pattern = ",", simplify = TRUE)) 
Genre_Table <- ifelse(Genre_Table == "", NA, Genre_Table)
Genre_Table <- as.data.frame(Genre_Table)
Genre_Table <- Genre_Table %>% rename(Series_Title = V1, V1 = V2, V2 = V3, V3 = V4)  %>% arrange(Series_Title)
view(Genre_Table)
# We converted The Series_Title column into a matrix in order to split the genre column. 
# We used str_split to split the column by the commas and cbind to match the columns and put them in the same row.  
# We then used an ifelse statement to replace the blanks with NAs. We then converted it into a data frame to make changing the columns easier.

