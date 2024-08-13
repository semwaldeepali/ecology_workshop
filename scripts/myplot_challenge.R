library(ggplot2)
library(ratdat)

#1. histogram of year

#convert year from int to char

histogram_plot <- 
  ggplot(data = complete_old, mapping = aes(x = as.character(year), fill = as.character(year))) + 
  geom_bar(color = "black",size = 0.5) +
  geom_text(aes(label = ..count..), stat = "count", vjust=1.5) +
  labs( title = "Number of rodents studied per year", x = "Year", y = "Number of rodents" ) + 
  theme_bw() + 
  theme(legend.position = "none") +
  scale_color_viridis_d()

ggsave("./images/rodent_per_year_plot.jpg", plot = histogram_plot, height = 6, width = 8)
