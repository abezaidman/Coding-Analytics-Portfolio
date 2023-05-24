while (!is.null(dev.list())) dev.off()
rm(list = ls())
cat('\014')

library(dplyr)
library(tidyverse)
library(ggplot2)
library(lubridate)

df <- read.csv(file.choose())

str(df)

rb <- df %>% filter(pos == 'RB')

str(rb)

df$game_date <- ymd(df$game_date)
rb$game_date <- ymd(rb$game_date)

df2019 <- filter(df, year(df$game_date) == '2019')
df2020 <- filter(df, year(df$game_date) == '2020')
df2021 <- filter(df, year(df$game_date) == '2021')
df2022 <- filter(df, year(df$game_date) == '2022')


rb2019 <- filter(rb, year(rb$game_date) == '2019')
rb2020 <- filter(rb, year(rb$game_date) == '2020')
rb2021 <- filter(rb, year(rb$game_date) == '2021')
rb2022 <- filter(rb, year(rb$game_date) == '2022')



ypc2019 <- group_by(rb2019, player_id) %>% mutate(Total_Rushing_Yards = sum(rush_yds),
                                               Total_Rushing_Attempts = sum(rush_att),
                                               Rushing_YPC =Total_Rushing_Yards/Total_Rushing_Attempts,
                                               Total_Receptions = sum(rec),
                                               Total_Reciving_Yards = sum(rec_yds),
                                               Reciving_YPC = Total_Reciving_Yards/ Total_Receptions,
                                               Total_yards = Total_Reciving_Yards + Total_Rushing_Yards)

ypc2019<- ypc2019 %>% select ('player_id','player', 'team','Total_Rushing_Yards', 'Total_Rushing_Attempts', 'Rushing_YPC',
                              'Total_Receptions', 'Total_Reciving_Yards', 'Reciving_YPC', 'Total_yards')%>% 
                              distinct(player_id, .keep_all = TRUE) %>% arrange(desc(Total_yards))
lf<- rbind(filter(ypc2019, team =='GNB'&Total_Rushing_Attempts > 30),
           filter(ypc2019, team =='CAR'&Total_Rushing_Attempts > 30),
           filter(ypc2019, team =='MIN'&Total_Rushing_Attempts > 30),
           filter(ypc2019, team =='TEN'&Total_Rushing_Attempts > 30),
           filter(ypc2019, team =='DAL'&Total_Rushing_Attempts > 30),
           filter(ypc2019, team =='NYJ'&Total_Rushing_Attempts > 30),
           filter(ypc2019, team =='JAX' &Total_Rushing_Attempts > 30),
           filter(ypc2019, team =='CLE'&Total_Rushing_Attempts > 30))

ggplot(data = lf, aes(x = Total_Rushing_Yards, y = Rushing_YPC, col = team))+ geom_point()+ geom_text(aes(label = player)) + labs(title = "Over 30 Attempts 2019 RB's")



Team2019<- group_by(df2019, team) %>% mutate(Team_yards = sum(pass_yds) + sum(rush_yds))

Team2019 %>% select('Team_yards', 'player_id')
Team2019 <- Team2019 %>% select('Team_yards', 'player_id')

Test<- ypc2019 %>% select('player_id', 'player', 'Total_yards') %>% left_join(Team2019, on = player_id) %>%  distinct(player_id, .keep_all = TRUE) %>% 
  mutate(Usage = Total_yards/Team_yards) %>% arrange(desc(Usage))


Test
summary(Test$Usage)
boxplot(Test$Usage)

boxplot(Test$Team_yards)
#THIS IF FOR 2019 

ypc2020 <- group_by(rb2020, player_id) %>% mutate(Total_Rushing_Yards = sum(rush_yds),
                                                  Total_Rushing_Attempts = sum(rush_att),
                                                  Rushing_YPC =Total_Rushing_Yards/Total_Rushing_Attempts,
                                                  Total_Receptions = sum(rec),
                                                  Total_Reciving_Yards = sum(rec_yds),
                                                  Reciving_YPC = Total_Reciving_Yards/ Total_Receptions,
                                                  Total_yards = Total_Reciving_Yards + Total_Rushing_Yards)

ypc2020<- ypc2020 %>% select ('player_id','player', 'team','Total_Rushing_Yards', 'Total_Rushing_Attempts', 'Rushing_YPC',
                              'Total_Receptions', 'Total_Reciving_Yards', 'Reciving_YPC', 'Total_yards')%>% 
  distinct(player_id, .keep_all = TRUE) %>% arrange(desc(Total_yards))


ggplot(data = filter(ypc2020, Total_Rushing_Attempts > 100 & Rushing_YPC >4), aes(x = Total_Rushing_Yards, y = Rushing_YPC, col = team))+ geom_point()+ geom_text(aes(label = player)) + labs(title = "Over 100 Attempts 2020 RB's")

Team2020 <- group_by(df2020, team) %>% mutate(Team_yards = sum(pass_yds) + sum(rush_yds))

Team2020 %>% select('Team_yards', 'player_id')
Team2020 <- Team2020 %>% select('Team_yards', 'player_id')

Test2 <- ypc2020 %>% select('player_id', 'player', 'Total_yards') %>% left_join(Team2020, on = player_id) %>%  distinct(player_id, .keep_all = TRUE) %>% 
  mutate(Usage = Total_yards/Team_yards) %>% arrange(desc(Usage))


Test2
summary(Test2$Usage)
boxplot(Test2$Usage)
#THIS IS FOR 2020

ypc2021 <- group_by(rb2021, player_id) %>% mutate(Total_Rushing_Yards = sum(rush_yds),
                                                  Total_Rushing_Attempts = sum(rush_att),
                                                  Rushing_YPC =Total_Rushing_Yards/Total_Rushing_Attempts,
                                                  Total_Receptions = sum(rec),
                                                  Total_Reciving_Yards = sum(rec_yds),
                                                  Reciving_YPC = Total_Reciving_Yards/ Total_Receptions,
                                                  Total_yards = Total_Reciving_Yards + Total_Rushing_Yards)

lf2<- rbind(filter(ypc2021, team =='GNB'&Total_Rushing_Attempts > 30),
            filter(ypc2021, team =='CAR'&Total_Rushing_Attempts > 30),
            filter(ypc2021, team =='MIN'&Total_Rushing_Attempts > 30),
            filter(ypc2021, team =='TEN'&Total_Rushing_Attempts > 30),
            filter(ypc2021, team =='DAL'&Total_Rushing_Attempts > 30),
            filter(ypc2021, team =='NYJ'&Total_Rushing_Attempts > 30),
            filter(ypc2021, team =='TAM' &Total_Rushing_Attempts > 30),
            filter(ypc2021, team =='CLE'&Total_Rushing_Attempts > 30))

ggplot(data = lf2, aes(x = Total_Rushing_Yards, y = Rushing_YPC))+ geom_point()+ geom_text(aes(label = player))+ labs(title = "2021 RB's")

ypc2021<- ypc2021 %>% select ('player_id','player', 'team','Total_Rushing_Yards', 'Total_Rushing_Attempts', 'Rushing_YPC',
                              'Total_Receptions', 'Total_Reciving_Yards', 'Reciving_YPC', 'Total_yards')%>% 
  distinct(player_id, .keep_all = TRUE) %>% arrange(desc(Total_yards))


Team2021 <- group_by(df2021, team) %>% mutate(Team_yards = sum(pass_yds) + sum(rush_yds))

Team2021 %>% select('Team_yards', 'player_id')
Team2021 <- Team2021 %>% select('Team_yards', 'player_id')

Test3 <- ypc2021 %>% select('player_id', 'player', 'Total_yards') %>% left_join(Team2021, on = player_id) %>%  distinct(player_id, .keep_all = TRUE) %>% 
  mutate(Usage = Total_yards/Team_yards) %>% arrange(desc(Usage))


Test3
summary(Test3$Usage)
boxplot(Test3$Usage)
#THIS IS FOR 2021


ypc2022 <- group_by(rb2022, player_id) %>% mutate(Total_Rushing_Yards = sum(rush_yds),
                                                  Total_Rushing_Attempts = sum(rush_att),
                                                  Rushing_YPC =Total_Rushing_Yards/Total_Rushing_Attempts,
                                                  Total_Receptions = sum(rec),
                                                  Total_Reciving_Yards = sum(rec_yds),
                                                  Reciving_YPC = Total_Reciving_Yards/ Total_Receptions,
                                                  Total_yards = Total_Reciving_Yards + Total_Rushing_Yards)

ypc2022<- ypc2022 %>% select ('player_id','player', 'team','Total_Rushing_Yards', 'Total_Rushing_Attempts', 'Rushing_YPC',
                              'Total_Receptions', 'Total_Reciving_Yards', 'Reciving_YPC', 'Total_yards')%>% 
  distinct(player_id, .keep_all = TRUE) %>% arrange(desc(Total_yards))


Team2022 <- group_by(df2022, team) %>% mutate(Team_yards = sum(pass_yds) + sum(rush_yds))

Team2022 %>% select('Team_yards', 'player_id')
Team2022 <- Team2022 %>% select('Team_yards', 'player_id')

Test4 <- ypc2022 %>% select('player_id', 'player', 'Total_yards') %>% left_join(Team2022, on = player_id) %>%  distinct(player_id, .keep_all = TRUE) %>% 
  mutate(Usage = Total_yards/Team_yards) %>% arrange(desc(Usage))


Test4
summary(Test4$Usage)
boxplot(Test4$Usage)
#THIS IS FOR 2022


CMAC <- rbind(filter(Test,player_id == 'McCaCh01'),filter(Test2,player_id == 'McCaCh01'),filter(Test3,player_id == 'McCaCh01'),filter(Test4,player_id == 'McCaCh01'))
CMAC$Year <- c('2019','2020','2021','2022')
plot(CMAC$Year, CMAC$Usage, type = 'l')

NCHUB <- rbind(filter(Test,player_id == 'ChubNi00'),filter(Test2,player_id == 'ChubNi00'),filter(Test3,player_id == 'ChubNi00'),filter(Test4,player_id == 'ChubNi00'))
NCHUB$Year <- c('2019','2020','2021','2022')
plot(NCHUB$Year, NCHUB$Usage, type = 'l')

LFOURN <- rbind(filter(Test,player_id == 'FourLe00'),filter(Test2,player_id == 'FourLe00'),filter(Test3,player_id == 'FourLe00'),filter(Test4,player_id == 'FourLe00'))
LFOURN$Year <- c('2019','2020','2021','2022')
plot(LFOURN$Year, LFOURN$Usage, type = 'l')

DHENRY <- rbind(filter(Test,player_id == 'HenrDe00'),filter(Test2,player_id == 'HenrDe00'),filter(Test3,player_id == 'HenrDe00'),filter(Test4,player_id == 'HenrDe00'))
DHENRY$Year <- c('2019','2020','2021','2022')
plot(DHENRY$Year, DHENRY$Usage, type = 'l')

DCOOK <- rbind(filter(Test,player_id == 'CookDa01'),filter(Test2,player_id == 'CookDa01'),filter(Test3,player_id == 'CookDa01'),filter(Test4,player_id == 'CookDa01'))
DCOOK$Year <- c('2019','2020','2021','2022')
plot(DCOOK$Year, DCOOK$Usage, type = 'l')

AJONES <- rbind(filter(Test,player_id == 'JoneAa00'),filter(Test2,player_id == 'JoneAa00'),filter(Test3,player_id == 'JoneAa00'),filter(Test4,player_id == 'JoneAa00'))
AJONES$Year <- c('2019','2020','2021','2022')
plot(AJONES$Year, AJONES$Usage, type = 'l')

LBELL <- rbind(filter(Test,player_id == 'BellLe00'),filter(Test2,player_id == 'BellLe00'),filter(Test3,player_id == 'BellLe00'),filter(Test4,player_id == 'BellLe00'))
LBELL$Year <- c('2019','2020','2021','2022')
plot(LBELL$Year, LBELL$Usage, type = 'l')

ZEKE <- rbind(filter(Test,player_id == 'ElliEz00'),filter(Test2,player_id == 'ElliEz00'),filter(Test3,player_id == 'ElliEz00'),filter(Test4,player_id == 'ElliEz00'))
ZEKE$Year <- c('2019','2020','2021','2022')
plot(ZEKE$Year, ZEKE$Usage, type = 'l')

temp <- rbind(CMAC,NCHUB,LFOURN,DHENRY,DCOOK,AJONES,LBELL,ZEKE)
temp


ggplot(data = temp, aes(x = Year, y = Usage, group = player_id)) +geom_line() + facet_wrap(~player) +labs(title = "RB Usage Over Time")

#RAMS 2021 SUPERBOWL WINNERS
filter(ypc2021, team == 'LAR')
DHEND <- rbind(filter(Test,player_id == 'HendDa00'),filter(Test2,player_id == 'HendDa00'),filter(Test3,player_id == 'HendDa00'),filter(Test4,player_id == 'HendDa00'))
DHEND$Year <- c('2019','2020','2021','2022')
DHEND

#BUCS 2020 SUPERBOWL WINNERS
filter(ypc2021, team == 'TAM')
LFOURN

#CHIEFS 2019 SUPERBOWL WINNERS
filter(ypc2021, team == 'KAN')
DWILL <- rbind(filter(Test,player_id == 'WillDa10'),filter(Test2,player_id == 'WillDa10'),filter(Test3,player_id == 'WillDa10'),filter(Test4,player_id == 'WillDa10'))
DWILL$Year <- c('2019','2020','2021','2022')
DWILL

#2022 BILLS OR CHIEFS MOST LIKELY WINNER 
filter(ypc2022, team == 'BUF') %>% arrange(desc(Total_Rushing_Yards))
DWILL <- rbind(filter(Test,player_id == 'SingDe00'),filter(Test2,player_id == 'SingDe00'),filter(Test3,player_id == 'SingDe00'),filter(Test4,player_id == 'SingDe00'))
DWILL$Year <- c('2019','2020','2021','2022')
DWILL



# Part 2 - Team Winning Percentage
df <- read.csv(file.choose())
str(df)
rb <- df %>% filter(pos == 'RB')
df$date <- ymd(df$game_date)


rb <- filter(rb, year(rb$game_date) == '2019'| year(rb$game_date) == '2020'| year(rb$game_date) == '2021')
ypc <- group_by(rb, player_id) %>% mutate(Total_Rushing_Yards = sum(rush_yds),
                                          Total_Rushing_Attempts = sum(rush_att),
                                          YPC =Total_Rushing_Yards/Total_Rushing_Attempts)

head(ypc)

ypc<- ypc %>% select ('player_id','player', 'team', 'Total_Rushing_Yards', 'Total_Rushing_Attempts', 'YPC','game_date')  %>% distinct(player_id, .keep_all = TRUE) %>% arrange(desc(YPC))
Team <- group_by(ypc, team) %>% summarize(Team_rushing_yards = sum(Total_Rushing_Yards))
Team %>% arrange(desc(Team_rushing_yards)) %>% print(n=20)

df2 <- read.csv(file.choose())
str(df2)
df2$date <- ymd(df2$date)
head(df2)

##SFO
SFOawaywins <- df2 %>% filter(away == '49ers',
                              score_away>score_home,
                              year(date) =='2019'| year(date) =='2020'| year(date) =='2021')
SFOhomewins <-  df2 %>% filter(home == '49ers',
                               score_home>score_away,
                               year(date) =='2019'| year(date) =='2020'| year(date) =='2021')
SFOtotalwins <- merge(SFOawaywins, SFOhomewins, all = TRUE)
SFOtotalgames <- df2 %>% filter(home == '49ers' | away == '49ers',year(date) =='2019'| year(date) =='2020'| year(date) =='2021')

ypc %>% filter(team == 'SFO') %>% arrange(desc(Total_Rushing_Yards))
SFORaheemMostert <- rb %>% filter(player_id == 'MostRa00') %>% select(game_date, player, player_id)
SFORaheemMostert$game_date
SFORaheemMostertWins <- SFOtotalwins %>% filter(date == "2019-09-08" | date == "2019-09-22" | date =="2019-09-15" | date == "2019-10-07" | date =="2019-10-13"
                                                | date == "2019-10-27" | date == "2019-10-31"| date == "2019-11-11"| date == "2019-11-17" 
                                                | date == "2019-11-24"| date =="2019-12-01"| date =="2019-12-08"| date =="2019-12-15"
                                                | date =="2019-12-21"| date =="2019-12-29"| date =="2020-01-11"| date =="2020-01-19"| date =="2020-09-13"
                                                | date =="2020-09-20"| date =="2020-10-11"| date =="2020-10-18"| date =="2020-11-29"| date =="2020-12-07"| date =="2020-12-13"| date =="2020-12-20"
                                                | date =="2021-09-12")

SFOWinPctWithRM <- 18/26
SFOWinPctWithoutRM <- 15/24

##MIN
MINawaywins <- df2 %>% filter(away == 'Vikings',
                              score_away>score_home,
                              year(date) =='2019'| year(date) =='2020'| year(date) =='2021')
MINhomewins <-  df2 %>% filter(home == 'Vikings',
                               score_home>score_away,
                               year(date) =='2019'| year(date) =='2020'| year(date) =='2021')
MINtotalwins <- merge(MINawaywins, MINhomewins, all = TRUE)
MINtotalgames <- df2 %>% filter(home == 'Vikings' | away == 'Vikings',
                                year(date) =='2019'| year(date) =='2020'| year(date) =='2021')

ypc %>% filter(team == 'MIN')%>% arrange(desc(Total_Rushing_Yards))
MINDalvinCook <- rb %>% filter(player_id == 'CookDa01') %>% select(game_date, player, player_id)
MINDalvinCook$game_date
MINDalvinCookWins <- MINtotalwins %>% filter(date == "2019-09-08" | date == "2019-09-15"| date == "2019-09-22" | date == "2019-09-29"| date ==  "2019-10-06" | date == "2019-10-13" | date == "2019-10-20"
                                             | date == "2019-10-24"| date ==  "2019-11-03" | date == "2019-11-10" | date == "2019-11-17"| date ==  "2019-12-02"| date ==  "2019-12-08"| date ==  "2019-12-15"
                                             | date == "2020-01-05" | date == "2020-01-11" | date == "2020-09-13"| date ==  "2020-09-20" | date == "2020-09-27" | date == "2020-10-04" | date == "2020-10-11"
                                             | date == "2020-11-01"| date ==  "2020-11-08" | date == "2020-11-16"| date ==  "2020-11-22"| date ==  "2020-11-29" | date == "2020-12-06"| date ==  "2020-12-13"
                                             | date == "2020-12-20" | date == "2020-12-25"| date ==  "2021-09-12"| date ==  "2021-09-19"| date ==  "2021-10-03"| date ==  "2021-10-17"| date ==  "2021-10-31"
                                             | date == "2021-11-07" | date == "2021-11-14" | date == "2021-11-21"| date ==  "2021-11-28"| date ==  "2021-12-09"| date ==  "2021-12-20")
MINWinPctWithDC <- 22/41
MINWinPctWithoutDC <- 4/8


##CLE
CLEawaywins <- df2 %>% filter(away == 'Browns',
                              score_away>score_home,
                              year(date) =='2019'| year(date) =='2020'| year(date) =='2021')
CLEhomewins <-  df2 %>% filter(home == 'Browns',
                               score_home>score_away,
                               year(date) =='2019'| year(date) =='2020'| year(date) =='2021')
CLEtotalwins <- merge(CLEawaywins, CLEhomewins, all = TRUE)
CLEtotalgames <- df2 %>% filter(home == 'Browns' | away == 'Browns',
                                year(date) =='2019'| year(date) =='2020'| year(date) =='2021')

ypc %>% filter(team == 'CLE')%>% arrange(desc(Total_Rushing_Yards))
CLENickChubb <- rb %>% filter(player_id == 'ChubNi00') %>% select(game_date, player, player_id)
CLENickChubb$game_date
CLENickChubbWins <- CLEtotalwins %>% filter(date == "2019-09-08"|date == "2019-09-16"|date == "2019-09-22" |date =="2019-09-29"|date == "2019-10-07"|date == "2019-10-13"
                                            |date =="2019-10-27"|date == "2019-11-03" |date =="2019-11-10"|date == "2019-11-14"|date == "2019-11-24"|date == "2019-12-01"
                                            |date =="2019-12-08"|date == "2019-12-15"|date == "2019-12-22"|date == "2019-12-29" |date =="2020-09-13" |date =="2020-09-17"
                                            |date =="2020-09-27"|date == "2020-10-04"|date == "2020-11-15" |date =="2020-11-22"|date == "2020-11-29"|date == "2020-12-06"
                                            |date =="2020-12-14" |date =="2020-12-20" |date =="2020-12-27"|date == "2021-01-03"|date == "2021-01-10"|date == "2021-01-17"
                                            |date =="2021-09-12"|date == "2021-09-19"|date == "2021-09-26"|date == "2021-10-03"|date == "2021-10-10"|date == "2021-10-31"
                                            |date =="2021-11-07"|date == "2021-11-21"|date == "2021-11-28"|date == "2021-12-12"|date == "2021-12-20"|date == "2021-12-25")
CLEWinPctWithNC <- 22/42
CLEWinPctWithoutNC <- 3/7

##NWE 
NWEawaywins <- df2 %>% filter(away == 'Patriots',
                              score_away>score_home,
                              year(date) =='2019'| year(date) =='2020'| year(date) =='2021')
NWEhomewins <-  df2 %>% filter(home == 'Patriots',
                               score_home>score_away,
                               year(date) =='2019'| year(date) =='2020'| year(date) =='2021')
NWEtotalwins <- merge(NWEawaywins, NWEhomewins, all = TRUE)
NWEtotalgames <- df2 %>% filter(home == 'Patriots' | away == 'Patriots',
                                year(date) =='2019'| year(date) =='2020'| year(date) =='2021')

ypc %>% filter(team == 'NWE')%>% arrange(desc(Total_Rushing_Yards))
NWEDamienHarris <- rb %>% filter(player_id == 'HarrDa06') %>% select(game_date, player, player_id)
NWEDamienHarris$game_date
NWEDamienHarrisWins <- NWEtotalwins %>% filter(date =="2019-10-21"|date == "2020-10-05"|date == "2020-10-18"|date == "2020-10-25" |date =="2020-11-01"|date == "2020-11-09"
                                               |date =="2020-11-15"|date == "2020-11-22"|date == "2020-11-29"|date == "2020-12-06" |date =="2020-12-10" |date =="2021-09-12"
                                               |date =="2021-09-19"|date == "2021-09-26" |date =="2021-10-03"|date == "2021-10-10"|date == "2021-10-17" |date =="2021-10-24"
                                               |date =="2021-10-31"|date == "2021-11-07"|date == "2021-11-18" |date =="2021-11-28"|date == "2021-12-06"|date == "2021-12-26"
)

NWEWinPctWithDH <- 13/32
NWEWinPctWithoutDH <- 18/19

##GNB
GNBawaywins <- df2 %>% filter(away == 'Packers',
                              score_away>score_home,
                              year(date) =='2019'| year(date) =='2020'| year(date) =='2021')
GNBhomewins <-  df2 %>% filter(home == 'Packers',
                               score_home>score_away,
                               year(date) =='2019'| year(date) =='2020'| year(date) =='2021')
GNBtotalwins <- merge(GNBawaywins, GNBhomewins, all = TRUE)
GNBtotalgames <- df2 %>% filter(home == 'Packers' | away == 'Packers',
                                year(date) =='2019'| year(date) =='2020'| year(date) =='2021')

ypc %>% filter(team == 'GNB')%>% arrange(desc(Total_Rushing_Yards))
GNBAaronJones <- rb %>% filter(player_id == 'JoneAa00') %>% select(game_date, player, player_id)
GNBAaronJones$game_date
GNBAaronJonesWins <- GNBtotalwins %>% filter(date =="2019-09-05" |date =="2019-09-15"|date == "2019-09-22" |date =="2019-09-26"|date == "2019-10-06"|date == "2019-10-14"
                                             |date =="2019-10-20"|date == "2019-10-27"|date == "2019-11-03" |date =="2019-11-10"|date == "2019-11-24" |date =="2019-12-01"
                                             |date =="2019-12-08"|date == "2019-12-15" |date =="2019-12-23"|date == "2019-12-29"|date == "2020-01-12"|date == "2020-01-19"
                                             |date =="2020-09-13"|date == "2020-09-20"|date == "2020-09-27"|date == "2020-10-05"|date == "2020-10-18"|date == "2020-11-05"
                                             |date =="2020-11-15"|date == "2020-11-22"|date == "2020-11-29"|date == "2020-12-06"|date == "2020-12-13"|date == "2020-12-19"
                                             |date =="2020-12-27"|date == "2021-01-03"|date == "2021-01-16"|date == "2021-01-24"|date == "2021-09-12"|date == "2021-09-20"
                                             |date =="2021-09-26"|date == "2021-10-03" |date =="2021-10-10"|date == "2021-10-17"|date == "2021-10-24"|date == "2021-10-28"
                                             |date =="2021-11-07"|date == "2021-11-14"|date == "2021-11-28"|date == "2021-12-12"|date == "2021-12-19" |date =="2021-12-25")

GNBWinPctWithAJ <- 39/48
GNBWinPctWithoutAJ <- 1/3

##IND
INDawaywins <- df2 %>% filter(away == 'Colts',
                              score_away>score_home,
                              year(date) =='2019'| year(date) =='2020'| year(date) =='2021')
INDhomewins <-  df2 %>% filter(home == 'Colts',
                               score_home>score_away,
                               year(date) =='2019'| year(date) =='2020'| year(date) =='2021')
INDtotalwins <- merge(INDawaywins, INDhomewins, all = TRUE)
INDtotalgames <- df2 %>% filter(home == 'Colts' | away == 'Colts',
                                year(date) =='2019'| year(date) =='2020'| year(date) =='2021')

ypc %>% filter(team == 'IND')%>% arrange(desc(Total_Rushing_Yards))
INDMarlonMack <- rb %>% filter(player_id == 'MackMa00') %>% select(game_date, player, player_id)
INDMarlonMack$game_date
INDMarlonMackWins <- INDtotalwins %>% filter(date=="2019-09-08"|date== "2019-09-15"|date== "2019-09-22"|date== "2019-09-29"|date== "2019-10-06"|date== "2019-10-20"
                                             |date=="2019-10-27"|date== "2019-11-03" |date=="2019-11-10" |date=="2019-11-17"|date== "2019-12-08"|date== "2019-12-16"
                                             |date=="2019-12-22"|date== "2019-12-29"|date== "2020-09-13"|date== "2021-09-19"|date== "2021-10-03"|date== "2021-10-11"
                                             |date=="2021-10-17"|date== "2021-10-24"|date== "2021-10-31")

INDWinPctWithMM <- 10/21
INDWinPctWithoutMM <- 18/29

##TEN
TENawaywins <- df2 %>% filter(away == 'Titans',
                              score_away>score_home,
                              year(date) =='2019'| year(date) =='2020'| year(date) =='2021')
TENhomewins <-  df2 %>% filter(home == 'Titans',
                               score_home>score_away,
                               year(date) =='2019'| year(date) =='2020'| year(date) =='2021')
TENtotalwins <- merge(TENawaywins, TENhomewins, all = TRUE)
TENtotalgames <- df2 %>% filter(home == 'Titans' | away == 'Titans',
                                year(date) =='2019'| year(date) =='2020'| year(date) =='2021')

ypc %>% filter(team == 'TEN')%>% arrange(desc(Total_Rushing_Yards))
TENDerrickHenry <- rb %>% filter(player_id == 'HenrDe00') %>% select(game_date, player, player_id)
TENDerrickHenry$game_date
TENDerrickHenryWins <- TENtotalwins %>% filter(date=="2019-09-08" |date=="2019-09-15"|date== "2019-09-19"|date== "2019-09-29"|date== "2019-10-06"|date== "2019-10-13"
                                               |date=="2019-10-20" |date=="2019-10-27" |date=="2019-11-03"|date== "2019-11-10" |date=="2019-11-24"|date== "2019-12-01"
                                               |date=="2019-12-08"|date== "2019-12-15"|date== "2019-12-29"|date== "2020-01-04"|date== "2020-01-11"|date== "2020-01-19"
                                               |date=="2020-09-14" |date=="2020-09-20"|date== "2020-09-27"|date== "2020-10-13"|date== "2020-10-18" |date=="2020-10-25"
                                               |date=="2020-11-01"|date== "2020-11-08"|date== "2020-11-12"|date== "2020-11-22"|date== "2020-11-29"|date== "2020-12-06"
                                               |date=="2020-12-13"|date== "2020-12-20"|date== "2020-12-27"|date== "2021-01-03"|date== "2021-01-10"|date== "2021-09-12"
                                               |date=="2021-09-19"|date== "2021-09-26"|date== "2021-10-03"|date== "2021-10-10"|date== "2021-10-18"|date== "2021-10-24"
                                               |date=="2021-10-31")

TENWinPctWithDH <- 28/43
TENWinPctWithoutDH <- 4/8

##LAC
LACawaywins <- df2 %>% filter(away == 'Chargers',
                              score_away>score_home,
                              year(date) =='2019'| year(date) =='2020'| year(date) =='2021')
LAChomewins <-  df2 %>% filter(home == 'Chargers',
                               score_home>score_away,
                               year(date) =='2019'| year(date) =='2020'| year(date) =='2021')
LACtotalwins <- merge(LACawaywins, LAChomewins, all = TRUE)
LACtotalgames <- df2 %>% filter(home == 'Chargers' | away == 'Chargers',
                                year(date) =='2019'| year(date) =='2020'| year(date) =='2021')

ypc %>% filter(team == 'LAC')%>% arrange(desc(Total_Rushing_Yards))
LACAustinEkeler <- rb %>% filter(player_id == 'EkelAu00') %>% select(game_date, player, player_id)
LACAustinEkeler$game_date
LACAustinEkelerWins <- LACtotalwins %>% filter(date=="2019-09-08"|date== "2019-09-15"|date== "2019-09-22"|date== "2019-09-29"|date== "2019-10-06"|date== "2019-10-13"
                                               |date=="2019-10-20" |date=="2019-10-27"|date== "2019-11-03"|date== "2019-11-07"|date== "2019-11-18"|date== "2019-12-01"
                                               |date=="2019-12-08"|date== "2019-12-15"|date== "2019-12-22"|date== "2019-12-29"|date== "2020-09-13" |date=="2020-09-20"
                                               |date=="2020-09-27"|date== "2020-10-04" |date=="2020-11-29"|date== "2020-12-06"|date== "2020-12-13"|date== "2020-12-17"
                                               |date=="2020-12-27"|date== "2021-01-03"|date== "2021-09-12" |date=="2021-09-19"|date== "2021-09-26"|date== "2021-10-04"
                                               |date=="2021-10-10" |date=="2021-10-17"|date== "2021-10-31"|date== "2021-11-07"|date== "2021-11-14"|date== "2021-11-21"
                                               |date=="2021-11-28"|date== "2021-12-05"|date== "2021-12-12" |date=="2021-12-16")

LACWinPctWithAE <- 18/40
LACWinPctWithoutAE <- 3/9

##PHI
PHIawaywins <- df2 %>% filter(away == 'Eagles',
                              score_away>score_home,
                              year(date) =='2019'| year(date) =='2020'| year(date) =='2021')
PHIhomewins <-  df2 %>% filter(home == 'Eagles',
                               score_home>score_away,
                               year(date) =='2019'| year(date) =='2020'| year(date) =='2021')
PHItotalwins <- merge(PHIawaywins, PHIhomewins, all = TRUE)
PHItotalgames <- df2 %>% filter(home == 'Eagles' | away == 'Eagles',
                                year(date) =='2019'| year(date) =='2020'| year(date) =='2021')

ypc %>% filter(team == 'PHI')%>% arrange(desc(Total_Rushing_Yards))
PHIMilesSanders <- rb %>% filter(player_id == 'SandMi01') %>% select(game_date, player, player_id)
PHIMilesSanders$game_date
PHIMilesSandersWins <- PHItotalwins %>% filter(date=="2019-09-08"|date== "2019-09-15"|date==  "2019-09-22" |date== "2019-09-26"|date==  "2019-10-06"|date==  "2019-10-13"
                                               |date== "2019-10-20"|date==  "2019-10-27"|date==  "2019-11-03"|date==  "2019-11-17"|date==  "2019-11-24"|date==  "2019-12-01"
                                               |date== "2019-12-09"|date==  "2019-12-15"|date==  "2019-12-22"|date==  "2019-12-29" |date== "2020-01-05" |date== "2020-09-20"
                                               |date== "2020-09-27" |date== "2020-10-04"|date==  "2020-10-11"|date==  "2020-10-18"|date==  "2020-11-15"|date==  "2020-11-22"
                                               |date== "2020-11-30" |date== "2020-12-06"|date==  "2020-12-13" |date== "2020-12-20"|date==  "2020-12-27"|date==  "2021-09-12"
                                               |date== "2021-09-19"|date==  "2021-09-27"|date==  "2021-10-03"|date==  "2021-10-10" |date== "2021-10-14"|date==  "2021-10-24"
                                               |date== "2021-11-21" |date== "2021-11-28" |date== "2021-12-05" |date== "2021-12-21"|date==  "2021-12-26")

PHIWinPctWithMS <- 17/41
PHIWinPctWithoutMS <- 5/9

##DAL
DALawaywins <- df2 %>% filter(away == 'Cowboys',
                              score_away>score_home,
                              year(date) =='2019'| year(date) =='2020'| year(date) =='2021')
DALhomewins <-  df2 %>% filter(home == 'Cowboys',
                               score_home>score_away,
                               year(date) =='2019'| year(date) =='2020'| year(date) =='2021')
DALtotalwins <- merge(DALawaywins, DALhomewins, all = TRUE)
DALtotalgames <- df2 %>% filter(home == 'Cowboys' | away == 'Cowboys',
                                year(date) =='2019'| year(date) =='2020'| year(date) =='2021')

ypc %>% filter(team == 'DAL')%>% arrange(desc(Total_Rushing_Yards))
DALEzekielElliot <- rb %>% filter(player_id == 'ElliEz00') %>% select(game_date, player, player_id)
DALEzekielElliot$game_date
DALEzekielElliotWins <- DALtotalwins %>% filter(date=="2019-09-08" |date=="2019-09-15"|date== "2019-09-22"|date== "2019-09-29"|date== "2019-10-06"|date== "2019-10-13"
                                                |date=="2019-10-20"|date== "2019-11-04"|date== "2019-11-10"|date== "2019-11-17"|date== "2019-11-24" |date=="2019-11-28"
                                                |date=="2019-12-05"|date== "2019-12-15" |date=="2019-12-22" |date=="2019-12-29"|date== "2020-09-13"|date== "2020-09-20"
                                                |date=="2020-09-27"|date== "2020-10-04"|date== "2020-10-11" |date=="2020-10-19"|date== "2020-10-25"|date== "2020-11-01"
                                                |date=="2020-11-08"|date== "2020-11-22"|date== "2020-11-26"|date== "2020-12-08"|date== "2020-12-13" |date=="2020-12-27"
                                                |date=="2021-01-03" |date=="2021-09-09" |date=="2021-09-19" |date=="2021-09-27" |date=="2021-10-03"|date== "2021-10-10"
                                                |date=="2021-10-17"|date== "2021-10-31"|date== "2021-11-07"|date== "2021-11-14"|date== "2021-11-21"|date== "2021-11-25"
                                                |date=="2021-12-02"|date== "2021-12-12"|date== "2021-12-19" |date=="2021-12-26")

DALWinPctWithEE <- 24/46
DALWinPctWithoutEE <- 2/3


#Comprehensive Stats
GamesWithRB <- 26+41+42+32+48+21+43+40+41+46
WinsWithRB <- 18+22+22+13+39+10+28+18+17+24

GamesWithoutRB <- 24+8+7+19+3+29+8+9+9+3
WinsWithoutRB <- 15+4+3+18+1+18+4+3+5+2

WinPctWithRB <- WinsWithRB/GamesWithRB
WinPctWithRB
WinPctWithoutRB <- WinsWithoutRB/GamesWithoutRB
WinPctWithoutRB

#Graphs 
install.packages("ggplot2")
library(ggplot2)

WinPercentageWithRB <- c(SFOWinPctWithRM,MINWinPctWithDC,CLEWinPctWithNC,NWEWinPctWithDH,GNBWinPctWithAJ,INDWinPctWithMM,TENWinPctWithDH,LACWinPctWithAE,PHIWinPctWithMS,DALWinPctWithEE)
WinPercentageWithoutRB <- c(SFOWinPctWithoutRM,MINWinPctWithoutDC,CLEWinPctWithoutNC,NWEWinPctWithoutDH,GNBWinPctWithoutAJ,INDWinPctWithoutMM,TENWinPctWithoutDH,LACWinPctWithoutAE,PHIWinPctWithoutMS,DALWinPctWithoutEE)
col <- c("red","purple","brown","orange","green","blue","light blue","yellow","dark green","dark blue")
lab <- c("49ers","Vikings","Browns","Patriots","Packers","Colts","Titans","Chargers","Eagles","Cowboys")

plot1 <- ggplot(data = NULL, aes(x = WinPercentageWithRB, y = WinPercentageWithoutRB)) +
  geom_point(color = col) + geom_text(aes(label = lab))





