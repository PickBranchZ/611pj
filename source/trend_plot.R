library(tidyverse)

## load trend data
trend <- read_csv("derived_data/trend.csv")

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