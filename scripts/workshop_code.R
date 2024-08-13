library(ggplot2)
library(ratdat)
#scatter
scatter_plot <- ggplot(data = complete_old, mapping = aes( x = weight, y = hindfoot_length, colour = plot_type)) + geom_point( alpha = 0.2 ) + scale_x_log10()

#box 
box_plot <- ggplot(data = complete_old, mapping = aes(x = plot_type, y = hindfoot_length)) + 
  geom_jitter(alpha = 0.2,aes(colour = plot_type)) +
  geom_boxplot(outlier.shape = NA, fill = NA) + scale_x_discrete(labels = label_wrap_gen(width = 10)) 

#violin
violin_plot <- ggplot(data = complete_old, mapping = aes(x = plot_type, y = hindfoot_length, colour = plot_type)) + 
  geom_jitter(alpha = 0.2) +
  geom_violin(fill = "white") +
  scale_x_discrete(labels = label_wrap_gen(width = 10))

#scatter_plot
box_plot
#violin_plot

final_plot <- box_plot + theme_bw() + 
  theme(axis.title = element_text(size = 14), panel.grid.major.x = element_blank(), legend.position = "none", 
        plot.title = element_text(face = "bold", size = 20)) +
  labs(title = "Rodent size by plot type",
       subtitle = "A subtitle text",
       x = "Plot type",
       y = "Hindfoot length (mm)") +
  facet_wrap(vars(sex), ncol = 1) # Note: faceting on this data produces 3 facets M, F and empty. Empty is where data is missing.

#saving the plot
ggsave(filename = "images/rodent_size_plots.jpg", plot = final_plot, height = 6, width = 8)
