
while (!is.null(dev.list())) dev.off()
rm(list = ls())
cat('\014')

library(dplyr)
library(tidyverse)
library(lubridate)

netflix <- read.csv(file.choose())
hulu <- read.csv(file.choose())
disney <- read.csv(file.choose())

#QUESTION 2
netflix$date_added <- mdy(netflix$date_added)
hulu$date_added<- mdy(hulu$date_added)
disney$date_added <- mdy(disney$date_added)
# permanently parsed the date using "mdy" function 


#QUESTION 3
#CREATED YEAR MONTH AND Titles added columns to each data set
netflix<- mutate(netflix, yearmonth = 
format(date_added,"%Y-%m"))
view(netflix)

netflix_titlesadded<- (group_by(netflix, yearmonth, type)) %>%  summarise(titles_added_netflix = n())
netflix_titlesadded

hulu<- mutate(hulu, yearmonth = 
format(date_added,"%Y-%m"))

hulu_titlesadded <- (group_by(hulu, yearmonth, type)) %>%  summarise(titles_added_hulu = n())
hulu_titlesadded

disney<- mutate(disney, yearmonth = 
format(date_added,"%Y-%m"))

disney_titlesadded <- (group_by(disney, yearmonth, type)) %>%  summarise(titles_added_disney = n())
disney_titlesadded
# For each platform, created columns indicating the year and month a title was added.
# We then proceeded to summarize how many titles were added in each year/month.

#QUESTION 4
table4.1<- merge(netflix_titlesadded,hulu_titlesadded, all = TRUE) %>% merge(disney_titlesadded,all = TRUE)
view(table4.1)

Year_month <- expand.grid(yearmonth=format(ymd("2008-01-01")+ months(0:166),"%Y-%m"), type = c("Movie", "TV Show"))

table4<- Year_month%>%left_join(table4.1)
view(table4)
#Merged the titlesadded tables. We then used the Year_month table provided in the template and left joined table 4.1 to it in order to get the date information.

#QUESTION 5
table5<- table4 %>% group_by(type) %>% mutate(netflix = cumsum(replace_na(titles_added_netflix,0)),
hulu = cumsum(replace_na(titles_added_hulu,0)),
disney_plus = cumsum(replace_na(titles_added_disney,0))) %>% select("yearmonth", "type", "netflix", "hulu", "disney_plus")

view(table5)
# To create table5 we grouped table4 by type and using the cumsum function, made a column for each platform indicating the cumulative number of titles by month and type.

#QUESTION 6 
plotdata<- (table5  %>% gather(platform, num_of_titles, netflix:disney_plus, factor_key=TRUE) %>% mutate(yearmonth=as.Date(format(ym(yearmonth)))))
view(plotdata)
# To create table6 we reformatted table5 and used the gather function to transform data set from wide to long, 
# and created a platform column to prepare the data to be plotted. 

#QUESTION 7 
ggplot(plotdata, aes(x = yearmonth, y = num_of_titles, color = platform))+ geom_line()+
  facet_grid(type~.) + scale_x_date(date_labels = "%m-%Y",date_breaks = "1 year")
# Used ggplot to visualize the increase in number of titles on each platform overtime. From 2008 to 2015, TV and movies remained quite stagnant for all of the platforms.
# In 2016, the number of TV and movie titles begins to steadily increase. However, there is one exception. Netflix's number of movie titles begins to drastically increase in 2016.
# With the aes function, we indicated what to put on the x and y axis, as well as what the colors of the lines represent. Geom_line indicates to use a lines for the graph.
# Facet_grid breaks it up into two graphs based on the type (TV, Movies). And finally, scale_x_date indicates how to label the dates and break up the dates.

#QUESTION 8
growthrate<-plotdata %>% group_by(platform,type) %>% mutate(Diff_growth = num_of_titles - lag(num_of_titles), 
                                              Rate_percent =  ((Diff_growth)/ lag(num_of_titles)) * 100) %>% print(n=Inf)
view(growthrate)
# Using plotdata, created data frame "growthrate". Created two columns: growth rate (Diff_growth) and growth rate percentage (Rate_percent). 
# To calculate growth rate (Diff_growth), we took the number of titles of a respective row, and subtracted it by the number of titles from the previous row using the lag function.
# To calculate the percentage, we took Diff_growth and divided it by the lag(num_of_titles), or in other words, the number of titles from the previous row.

#QUESTION 9
NetflixOriginal <- netflix%>%anti_join(hulu, by="title")%>%anti_join(disney, by="title")
Numnetflixoriginal<-8538
Numnetflix<-8807
percnetflixoriginal <- Numnetflixoriginal/Numnetflix

HuluOriginal <-hulu%>% anti_join(disney, by="title")%>%anti_join(netflix, by="title")
Numhuluoriginal<-2815
Numhulu<-3073
perchuluoriginal <- Numhuluoriginal/Numhulu

DisneyOriginal <- disney%>%anti_join(hulu, by="title")%>%anti_join(netflix, by="title")
Numdisoriginal<-1380
Numdis<-1450
percdisoriginal <- Numdisoriginal/Numdis
# Created 3 data frames for the respective companies (netflix, hulu, disney). In each data frame we individually anti-joined 
# each platform in order to identify the exclusive titles. We then assigned values to the exclusive and overall titles for each platform
# and divided them to find the percentage. The following are the percentage of exclusive titles on each platform: 
# netflix= 97%, hulu = 92%, disney = 95%

#QUESTION 10
sharedtitles<- netflix %>% inner_join(hulu,by="title") %>% inner_join(disney,by="title")
sharedtitles
# Inner-joined hulu to netflix, and then ultimately, inner-joined disney to create the sharedtitles data frame. 
# There are 5 titles that show up on all 3 platforms.
