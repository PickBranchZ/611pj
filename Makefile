all: figures/fig1_profit_vs_cost.png figures/fig2_top_10_trend_plot.png

figures/fig1_profit_vs_cost.png: source/profit_plot.R derived_data/profit.csv
	Rscript $<

figures/fig2_top_10_trend_plot.png: source/profit_plot.R derived_data/profit.csv
	Rscript $<

# Define the dependencies
derived_data/profit.csv: source/preprocessing.R
	Rscript $<


# Clean rule to remove generated files
clean:
	rm -f figures/fig1_profit_vs_cost.png figures/fig2_top_10_trend_plot.png

.PHONY: all clean