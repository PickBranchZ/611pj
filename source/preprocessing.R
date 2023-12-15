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
  group_by(Item.Number, week) %>%
  mutate(week_profit=sum(Profit))
  

#derive profit data
profit <- mydata %>%
  distinct(Item.Number, tol_profit, week_profit, State.Bottle.Cost, week)

## save profit as csv file
write_csv(profit, "derived_data/profit.csv")




#my regression function to calculate covid index
myweek <- 1:104
meanX <- mean(myweek)
SSX <- sum((myweek-meanX)^2)

mylm <- function(sale, date){
  sale1 <- sale[date<105]
  date1 <- date[date<105]
  b1 <- sum(sale1*(date1-meanX))/SSX
  
  sale2 <- sale[date>104]
  date2 <- date[date>104]
  b2 <- sum(sale2*(date2-104-meanX))/SSX
  
  return(b2-b1)
}


#r calculate my covid index
covid_index <- mydata %>%
  group_by(Item.Number) %>%
  mutate(tot_sale = sum(Bottles.Sold)) %>%
  filter(tot_sale>=730) %>%
  mutate(week = rep(1:209, each=7)[mydate]) %>%
  filter(week < 209) %>%
  ungroup %>%
  group_by(Item.Number, week) %>% 
  mutate(week_s = sum(Bottles.Sold)) %>%
  ungroup %>%
  distinct(Item.Number, week, week_s) %>%
  group_by(Item.Number) %>%
  mutate(Covid_index = mylm(week_s, week)) %>%
  distinct(Item.Number, Covid_index)




#item summary
liquor_items <- mydata %>%
  group_by(Item.Number) %>%
  mutate(Vendor=length(unique(Vendor.Name))) %>%
  mutate(State.Bottle.Retail=mean(State.Bottle.Retail)) %>%
  mutate(County=length(unique(County))) %>% 
  mutate(Store=length(unique(Store.Number))) %>%
  mutate(City=length(unique(City))) %>%
  mutate(Bottles.Sold=sum(Bottles.Sold)) %>%
  slice(1)%>%
  #filter(Bottles.Sold>=730)%>%
  distinct(Item.Number, 
           Category, Vendor, 
           Pack, Bottle.Volume..ml., 
           State.Bottle.Retail, 
           County, 
           Store,
           City,
           Bottles.Sold) %>%
  ungroup() %>%
  mutate(Popularity = rank(Bottles.Sold)) %>%
  mutate(Popularity = Popularity>0.9*max(Popularity)) %>%
  merge(y = covid_index, by = "Item.Number", all = TRUE) %>%
  mutate(PopularityC = Covid_index>0) %>%
  mutate(PopularityC = ifelse(is.na(PopularityC), 0, PopularityC)) %>%
  arrange(Item.Number, desc(Bottles.Sold))

## save Liquor_Items.csv as csv file
write_csv(liquor_items, "derived_data/liquor_items.csv")





