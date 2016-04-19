library(ggplot2)
library(dplyr)

df <- tbl_df(diamonds)

ggplot(df, aes(price, x)) + geom_point()
