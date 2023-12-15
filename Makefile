all: figures/fig1_profit_vs_cost.png figures/fig2_top_10_trend_plot.png figures/fig3_correlation.png figures/fig4_glmprediction.png figures/fig5_tree1.png figures/fig6_tree2.png

figures/fig1_profit_vs_cost.png: source/profit_plot.R derived_data/profit.csv
	Rscript $<

figures/fig2_top_10_trend_plot.png: source/profit_plot.R derived_data/profit.csv
	Rscript $<

figures/fig3_correlation: source/fit_plot.R derived_data/liquor_items.csv
	Rscript $<

figures/fig4_glmprediction: source/fit_plot.R derived_data/liquor_items.csv
	Rscript $<
	
figures/fig5_tree1: source/fit_plot.R derived_data/liquor_items.csv
	Rscript $<

figures/fig6_tree2: source/fit_plot.R derived_data/liquor_items.csv
	Rscript $<


# Define the dependencies
derived_data/profit.csv: source/preprocessing.R
	Rscript $<
	
derived_data/fit.csv: source/preprocessing.R
	Rscript $<


# Clean rule to remove generated files
clean:
	rm -f figures/fig1_profit_vs_cost.png figures/fig2_top_10_trend_plot.png figures/fig3_correlation.png figures/fig4_glmprediction.png figures/fig5_tree1.png figures/fig6_tree2.png

.PHONY: all clean