library(tidyverse)

## load profit vs cost data
profit <- read_csv("derived_data/profit.csv")

## total profit against bottle cost plot
total_profit <- profit %>%
  distinct(Item.Number, tol_profit, State.Bottle.Cost) %>%
  arrange(desc(tol_profit), desc(State.Bottle.Cost))

profit_plot <- ggplot(total_profit, aes(State.Bottle.Cost, tol_profit)) + 
  geom_point(size = 1) + 
  labs(title = 'Total Profit Plot', 
       x = 'Bottle Cost (USD)', 
       y = 'Total Profit (MUSD)')

## save plot
ggsave(profit_plot, filename = "figures/fig1_profit_vs_cost.png", height = 6, width = 10)



## extract top 10 total profit
top10 <- unique(total_profit$Item.Number)[1:10]
week_profit <- profit %>%
  filter(Item.Number %in% top10) %>%
  distinct(Item.Number, week, week_profit)

## calculate weekly profit for each liquor in top 10
trend <- matrix(0, nrow = 209, ncol = 11)
trend[, 1] <- 1:209
colnames(trend) <- c('week', top10)
for(i in 1:10){
  tmp <- week_profit %>%
    ungroup() %>%
    filter(Item.Number==top10[i]) %>%
    select(week, week_profit) %>%
    arrange(week)
  trend[tmp$week, i+1] <- as.vector(tmp$week_profit)
}
trend <- as.data.frame(trend)


## map trend for each top 10 liquor
trend_long <- trend %>% pivot_longer(-week)
trend_plot <- ggplot(trend_long) + 
  geom_smooth(aes(week,value,colour=name), 
              method = 'loess', se = FALSE, formula = y~x) +
  labs(title = 'Top 10 Weekly Profit Trend', 
       x = 'Week', 
       y = 'Week Profit (kUSD)')

## save plot
ggsave(trend_plot, filename = "figures/fig2_top_10_trend_plot.png", height = 6, width = 10)