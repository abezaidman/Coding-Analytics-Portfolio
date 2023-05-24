
#Part1

df <- read.csv(file.choose())

library(tidyverse)
str(df)
duplicated (df)
df<- unique(df)

#Question 1: This data has 14 variables and a total of 660 observations. 
#There are some duplicated records which have been removed using the unique function.

df %>%mutate(is_at_same_location = ifelse(df$Location == df$Headquarters,0,1), 
             avg_salary = ((df$max_salary + df$min_salary)/2), 
             gap_salary = (df$max_salary - df$min_salary))

#Question 2: Created a new column called is_at_same_location which compares if 
# location and headquarters are equal for each observation and assigns 0 if they are the
#same and 1 if they are different.
# There are also two columns avg_salary and gap_salary which get the mean and difference 
#between max and min salaries.

sum(duplicated(df$Job.Title))

str(unique(df$Job.Title))

str(df$Job.Title)

#Question 3: There are 168 unique job tiles under the job titles column.The data in this column is clean 
# because many people in this world have the same job titles as other people in the world. Each observation
# is not a duplicate but a unique observation of a different person and has many different pieces of information associated with it.

str(df)

df <- filter(df, Sector !=-1)

unique(df$Sector)

df<- na.omit(df)

df %>% group_by(Sector) %>% summarise(Count = n()) %>% print(n=23)


df %>% group_by(Sector, job_state) %>% summarise(Count = n()) %>% arrange(desc(Count))

#Question 4: Line 32 of code if executed shows how many jobs each sector has. There are 60 jobs that do no have a sector as they have a value -1.They have
# been removed in line 30 where the filter function is used and any row that has a sector value of -1 is filtered out of this data frame.
# One finding from the code on line 36 is that most information technology jobs are in California and Virginia. Another statement we can make is that
# Virginia has the highest concentration of Aerospace & Defense Jobs. 


df %>% group_by(Sector, job_state) %>% summarise(
                                                 mean_max_salary = mean(max_salary),
                                                 median_max_salary = median(max_salary),
                                                 max_max_salary = max(max_salary),
                                                 min_max_salary = min (max_salary),
                                                 sd_max_salary = sd(max_salary),
                                                 
                                                 mean_min_salary = mean(min_salary),
                                                 max_min_salary = max(min_salary),
                                                 min_min_salary = min (min_salary),
                                                 sd_min_salary = sd(min_salary),
                                                 median_min_salary = median(min_salary),
                                                 
                                                 mean_avg_salary = mean((df$max_salary + df$min_salary)/2),
                                                 max_avg_salary = max((df$max_salary + df$min_salary)/2),
                                                 min_avg_salary = min((df$max_salary + df$min_salary)/2),
                                                 sd_avg_salary = sd((df$max_salary + df$min_salary)/2),
                                                 median_avg_salary = median((df$max_salary + df$min_salary)/2))

#Question 5 : Run the code on line 64 to get all the summary statistics for each column. I used the summarize function to get these stats

#Part 2

#Question 1
# The mean of the laptops selling price is 508.1 the median is 500 the max is 890 and the min is 168/ There is also a histogram that shows the price
# and frequency relationship on line 76 that can be run. 
library(tidyverse)
df2 <- read.csv(file.choose())

str(df2)

summary(df2$Retail.Price)
hist(df2$Retail.Price)


#Question 2
# Over the course of 11 months the average price of laptops has changed a decent amount. 
# From January to June the price was decreasing and then shot up drastically from July to August
# From August to November the price has decreased slightly. 

Date_mean <- df2 %>% group_by(Date = as.Date(Date)) %>% summarise(mean = mean(Retail.Price)) %>% na.omit()
plot(Date_mean$Date, Date_mean$mean, type = 'l')



#question 3--There are 16 unique stores. 
#Mean of each(CR7:$472,E2:$520,E7:$467,KT2:$522,N17:$523,N3:$471,NW5:$521,SE1:$520,SE8:$521,
#SW12:$521,SW18:$520,SW1P:$470,SW1v:$520,W10:$520,W4:$469)
#The prices do not vary greatly across stores. 
df2 %>% group_by(Store.Postcode)%>% 
  filter(Retail.Price!="NA") %>% 
  summarise(AvgPrice=mean(Retail.Price))


#question4--The average price per store ranges from $469 to $523.
#The prices are relatively similar. Most are above $500.

#question 5--Customers from SW1P 1DN are buying the most laptops.
#Customers from N17 6QA generated the most revenue. 
df2 %>% group_by(Customer.Postcode) %>%
  count() %>%
  arrange(desc(n))

df2 %>% group_by(Customer.Postcode) %>%
  summarise(count = n(),totalrev = sum(Retail.Price, na.rm = TRUE)) %>%
  filter(count > 1) %>%
  arrange(desc(totalrev))

#question 6--Revenue of each store(SW1P:$24338073,SE1:$23220815,SW1V:$22618985,NW5:$16364055,E2:$15972845,SE8:$86,SW18:$73234210,SW12:$6611185,
#W10:$61,CR7:$3117845,W4:$2583049,N17:$2480320,KT2:$2261810,E7:$1479286,N3:$1185805)
#To find the revenue of each store, we created a data frame called temp1,grouped by the 
#Store.Postcode, calculated the total revenue with the sum function, and then arranged it in descending order.
#At every single store, the majority of revenue comes from selling 15 inch laptops.
#However,it is quite balanced. 15 inch laptops never exceed 60% of revenue.
#To find the percentages of each laptop, we created another data frame called temp2. 
#We essentially did the same thing we did for revenue, however, we also grouped by Screen.Size.
#We then joined the two data frames with right_join, which combines the corresponding values in each.
#Finally, we created a column with the percentages by dividing the revenue of each laptop size 
#from their respective stores, by the total revenue of their respective stores.
temp1<- df2 %>% group_by(Store.Postcode) %>%
  summarise(totalrev = sum(Retail.Price, na.rm = TRUE)) %>%
  arrange(desc(totalrev))

df2 %>% group_by(Store.Postcode,Screen.Size..Inches.) %>% 
  summarise(totalrev1 = sum(Retail.Price, na.rm = TRUE)) ->temp2

right_join(temp2,temp1) %>% mutate(percentage=(totalrev1/totalrev)) %>% print(n=Inf)


#question 7--Prior to creating the tibble, we had to calculate the number of laptops sold by 
#each store and then store it in a data frame.We then proceeded to create the columns for 
#the tibble, utilizing existing data frames.We then turned our tibble data frame into an actual tibble.
#There were two Store.Postcode columns so we had to delete one of them
laptopssold<- df2 %>% group_by(Store.Postcode) %>% count() %>% arrange(desc(n)) %>% select(n)
  
tibble<-data.frame(revenue_stores=temp1,laptops_sold=laptopssold,percentrev=100*(temp1$totalrev/sum(temp1$totalrev)),
                   percentsales=100*(laptopssold$n/sum(laptopssold$n))) 
tibble<-tibble[,-3] %>% as_tibble(tibble)

tibble
