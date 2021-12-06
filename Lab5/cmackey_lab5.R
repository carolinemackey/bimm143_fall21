#' --- 
#' title: "Class 05 Data Visualization" 
#' author: "Caroline Mackey (PID: A15522472)"
#' ---

# SCATTERPLOTS

# Install, then load ggplot. 
library (ggplot2)

# Every ggplot has data + aes + geom. 
# **First geom_point() plot of cars data: 
ggplot(data=cars)  + 
  aes(x=speed, y=dist) + 
  geom_point() 

# Change to a linear model. 
# **Plot with 2 or more geoms:  
p <- ggplot(data=cars)  + 
  aes(x=speed, y=dist)+ 
  geom_point() +
  geom_smooth(method="lm")
p

# Adjusting labels & theme. 
p + labs(title="Stopping Distance (feet) vs. Speed (MPH) of Cars", 
         x=("speed (MPH)"), 
         y=("distance (feet)"), 
         subtitle=("R Built-in Data Set"), 
         caption=("dataset: 'cars'")) + 
  theme_bw()


# New data set...
# **Read an input file

url <- "https://bioboot.github.io/bimm143_S20/class-material/up_down_expression.txt"
genes <- read.delim(url)
head(genes)

# Q. How many genes are there in the data set?
nrow(genes)

# Q. What are the column names? 
colnames(genes)

# Q. How many columns are there? 
ncol(genes)

# Q. How many 'up' regulated genes are there?  
table(genes$State)

#Q. What fraction of total genes is up-regulated in this dataset? (2 sig figs)
prec <- table(genes$State) / nrow(genes) * 100
round (prec, 2)

# Q. Make plot 
q <- ggplot(data=genes)  + 
  aes(x=Condition1, y=Condition2, col=State) + 
  geom_point() 
q

# **Plot with custom settings. 
q + scale_color_manual(values=c("gold", "gray", "lightblue"))
 
# **Plot with labs settings. 
q + scale_color_manual(values=c("gold", "gray", "lightblue")) + 
  labs (title="Gene Expression Changes Upon Drug Treatment",
        x=("Control (no drug)"),
        y=("Drug Treatment")) 


# New data set...

# **Install, then load gapminder. 
library (gapminder)

# Install, then load dplyr. 
library(dplyr)

# Filter to year 2007.
gapminder_2007 <- gapminder %>% filter(year==2007)

# Q. Scatter plot of gapminder_2007. 
ggplot(gapminder_2007) +
  aes(x=gdpPercap, y=lifeExp, color=continent, size=pop) +
  geom_point(alpha=0.5) 

# Another version: points colored by popultion size. 
ggplot(gapminder_2007) +
  aes(x=gdpPercap, y=lifeExp, color=pop) +
  geom_point(alpha=0.5)

# Another version: adjusting point size based on population size. 
ggplot(gapminder_2007) +
  geom_point(aes(x = gdpPercap, y = lifeExp,
                 size = pop), alpha=0.5) + 
  scale_size_area(max_size = 10)

# Q. For the year 1957:

gapminder_1957 <- gapminder %>% filter(year==1957)

ggplot(gapminder_1957) +
  aes(x=gdpPercap, y=lifeExp, 
      color=continent, 
      size=pop)+ 
  geom_point(alpha=0.7)+
  scale_size_area(max_size=10)

# Q. For the years 1957 AND 2007" 

gapminder_1957.2007 <- gapminder %>% filter(year==1957 | year==2007)

ggplot(gapminder_1957.2007) +
  aes(x=gdpPercap, y=lifeExp, 
      color=continent, 
      size=pop)+ 
  geom_point(alpha=0.7)+
  scale_size_area(max_size=10) + 
  facet_wrap(~year)

# BAR CHARTS 

# Data for 5 biggest countries: 
gapminder_top5 <- gapminder %>% 
  filter(year==2007) %>% 
  arrange(desc(pop)) %>% 
  top_n(5, pop)

gapminder_top5

# A simple bar chart:
ggplot(gapminder_top5) + 
  geom_col(aes(x=country,y=pop))

# Fill by continent: 
ggplot(gapminder_top5) + 
  geom_col(aes(x=country,y=pop, 
           fill=continent) )

# Fill by life expectancy: 
ggplot(gapminder_top5) + 
  geom_col(aes(x=country,y=pop, 
               fill=lifeExp) )

# Fill by GDP per capita, change the order of bars: 
ggplot(gapminder_top5) + 
  aes(x=reorder(country,-pop),y=pop, fill=gdpPercap)+
  geom_col()

# Just fill by country 
ggplot(gapminder_top5) +
  aes(x=reorder(country, -pop), y=pop, fill=country) +
  geom_col(col="gray30") +
  guides(fill=FALSE)


# New data set... 

head(USArrests)

# Flipped bar chart: 
USArrests$State <- rownames(USArrests)
ggplot(USArrests) + 
  aes(x=reorder(State,Murder),y=Murder) + 
  geom_col() + 
  coord_flip()

# New format:
USArrests$State <- rownames(USArrests)
ggplot(USArrests) +
  aes(x=reorder(State,Murder), y=Murder) +
  geom_point() +
  geom_segment(aes(x=State, 
                   xend=State, 
                   y=0, 
                   yend=Murder), color="blue") +
  coord_flip()

# PLOT ANIMATION

# Install, then load gifski & gganimate. 
library (gganimate)
library (gifski)

# Normal ggplot of gapminder data: 
ggplot (gapminder, aes(gdpPercap, lifeExp, size=pop, color=country))+
  geom_point(alpha=0.7, show.legend=FALSE) + 
  scale_color_manual(values=country_colors) + 
  scale_size(range= c(2,12)) + 
  scale_x_log10()+
  # Facet by continent 
  facet_wrap (~continent) + 
  # Animations :-)
  labs(title = 'Year: {frame_time}', x = 'GDP per capita', y = 'life expectancy') +
  transition_time(year) +
  shadow_wake(wake_length = 0.1, alpha = FALSE)

# Combining plots

# Install, then load patchwork: 
library(patchwork)

# Setup some example plots 
p1 <- ggplot(mtcars) + geom_point(aes(mpg, disp))
p2 <- ggplot(mtcars) + geom_boxplot(aes(gear, disp, group = gear))
p3 <- ggplot(mtcars) + geom_smooth(aes(disp, qsec))
p4 <- ggplot(mtcars) + geom_bar(aes(carb))

# Use patchwork to combine them here:
(p1 | p2 | p3) /
  p4
