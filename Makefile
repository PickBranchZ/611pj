all: figures/fig1_profit_vs_cost.png figures/fig2_top_10_trend_plot.png

figures/fig1_profit_vs_cost.png: source/profit_plot.R derived_data/total_profit.csv
	Rscript $<

figures/fig2_top_10_trend_plot.png: source/trend_plot.R derived_data/trend.csv
	Rscript $<

# Define the dependencies
derived_data/total_profit.csv: source/preprocessing.R
	Rscript $<

derived_data/trend.csv: source/preprocessing.R
	Rscript $<

# Clean rule to remove generated files
clean:
	rm -f figures/fig1_profit_vs_cost.png figures/fig2_top_10_trend_plot.png

.PHONY: all clean