library(tidyverse)

## Load data from local or online
file_path <- 'rawdata/Iowa_Data.csv'

# if (file.exists(file_path))
mydata <- read_csv(file_path, show_col_types = FALSE)

mydata$mydate <- unclass(as.Date(mydata$Date, format = '%m/%d/%Y'))
mydata$mydate <- mydata$mydate-min(mydata$mydate)+1


## calculate profit
mydata <- mydata%>%
  group_by(Item.Number) %>%
  mutate(State.Bottle.Retail=mean(State.Bottle.Retail)) %>%
  mutate(State.Bottle.Cost=mean(State.Bottle.Cost)) %>%
  mutate(Profit=(State.Bottle.Retail-State.Bottle.Cost)*Bottles.Sold)


## calculate total profit for each item
total_profit <- mydata %>% group_by(Item.Number) %>%
  mutate(tol_profit=sum(Profit)/1e6) %>%
  mutate(botl_profit=State.Bottle.Retail-State.Bottle.Cost) %>%
  distinct(Item.Number, tol_profit, botl_profit, State.Bottle.Cost) %>%
  filter(botl_profit>0) %>%
  filter(botl_profit<60) %>%
  arrange(desc(tol_profit), desc(botl_profit))

## save total_profit as csv file
write_csv(total_profit, "derived_data/total_profit.csv")


## extract top 10 total profit
top10 <- total_profit[1:10, ]


## calculate profit by day
profit_date <- mydata %>% group_by(Item.Number, mydate) %>%
  mutate(p=sum(Profit)) %>%
  distinct(Item.Number, mydate, p)


## calculate weekly profit for each liquor in top 10
trend <- matrix(0, nrow = 209, ncol = 11)
trend[, 1] <- 1:209
colnames(trend) <- c('week', top10$Item.Number)
for(i in 1:10){
  tmp <- profit_date %>%
    filter(Item.Number==top10$Item.Number[i]) %>%
    ungroup %>%
    mutate(week=rep(1:209, each=7)[mydate]) %>%
    add_row(week = 1:209, p = 0) %>%
    group_by(week) %>% 
    mutate(week_p = sum(p)/1e3) %>%
    distinct(week, week_p) %>%
    arrange(week)
  trend[, i+1] <- as.vector(tmp$week_p)
}
trend <- as.data.frame(trend)

## save trend as csv file
write_csv(trend, "derived_data/trend.csv")















