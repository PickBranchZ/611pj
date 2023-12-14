library(tidyverse)

## Load data from local or online
file_path <- 'rawdata/Iowa_Data.csv'

# if (file.exists(file_path))
mydata <- read_csv(file_path, show_col_types = FALSE)

mydata$mydate <- unclass(as.Date(mydata$Date, format = '%m/%d/%Y'))
mydata$mydate <- mydata$mydate-min(mydata$mydate)+1


## derive item summary data
mydata <- mydata%>%
  group_by(Item.Number) %>%
  mutate(State.Bottle.Retail=mean(State.Bottle.Retail)) %>%
  mutate(State.Bottle.Cost=mean(State.Bottle.Cost)) %>%
  mutate(botl_profit=State.Bottle.Retail-State.Bottle.Cost) %>%
  filter(botl_profit>0) %>%
  filter(botl_profit<60) %>%
  mutate(Profit=botl_profit*Bottles.Sold) %>%
  mutate(tol_profit=sum(Profit)/1e6) %>%
  mutate(week=rep(1:209, each=7)[mydate]) %>%
  mutate(week_profit=sum(Profit))
  

#derive profit data
profit <- mydata %>%
  distinct(Item.Number, tol_profit, week_profit, State.Bottle.Cost, week)

## save profit as csv file
write_csv(profit, "derived_data/profit.csv")




  










