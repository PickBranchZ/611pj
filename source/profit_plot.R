library(tidyverse)

## load profit vs cost data
total_profit <- read_csv("derived_data/total_profit.csv")

## total profit against bottle cost plot
profit_plot <- ggplot(total_profit, aes(State.Bottle.Cost, tol_profit)) + 
  geom_point(size = 1) + 
  labs(title = 'Total Profit Plot', 
       x = 'Bottle Cost (USD)', 
       y = 'Total Profit (MUSD)')

## save plot
ggsave(profit_plot, filename = "figures/fig1_profit_vs_cost.png", height = 6, width = 10)