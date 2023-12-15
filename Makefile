all: figures/fig1_profit_vs_cost.png figures/fig2_top_10_trend_plot.png figures/fig3_correlation.png figures/fig4_glmprediction.png figures/fig5_tree1.png figures/fig6_tree2.png report

figures/fig1_profit_vs_cost.png: source/profit_plot.R
	Rscript $<

figures/fig2_top_10_trend_plot.png: source/profit_plot.R
	Rscript $<

figures/fig3_correlation.png: source/fit_plot.R
	Rscript $<

figures/fig4_glmprediction.png: source/fit_plot.R
	Rscript $<
	
figures/fig5_tree.png1: source/fit_plot.R
	Rscript $<

figures/fig6_tree2.png: source/fit_plot.R
	Rscript $<
	
report: 
	Rscript -e "rmarkdown::render('report.Rmd', 'pdf_document')"

.created_directories: 
	mkdir -p figures
	touch .created_directories

# Clean rule to remove generated files
clean:
	rm -rf figures
	rm -f report.pdf

.PHONY: clean
.PHONY: .created_directories