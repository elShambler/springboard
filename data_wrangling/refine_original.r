# Let's setup our environment and load everything

library(dplyr)
library(tidyr)

setwd("C:/Users/castillo/OneDrive/School/SlideRule/FoundationsDS/dataWrangling/")
df_original <- tbl_df(read.csv("refine_original.csv", stringsAsFactors = F))

## Next we'll add a few more columns to DF along with making everything lowercase

comp_char <- list(c("f", "a","v","u"), c("philips","akzo", "van houten", "unilever"))

for (i in 1:4) {
  if (i == 1) {
    df_original <- df_original %>% mutate(company = tolower(company), len = nchar(company), first_char = substr(company, 1, 1))
    df <- df_original %>% filter(first_char == "p" | first_char == "f") %>% mutate(company = comp_char[[2]][i])
  } else {
    df_temp <- df_original %>% filter(first_char == comp_char[[1]][i]) %>% mutate(company = comp_char[[2]][i])
    df <- rbind(df, df_temp)
  }
}

rm(df_temp, i)
## Now we'll separate the Product Code/Number into separate categories along with a detail of it's category code
## And while we've got a MUTATE call, we'll add the full address

prod_cat <- list(p = 'smartphone', v = 'tv', x = 'laptop', q = 'tablet')

df <- df %>% separate(Product.code...number, c('product_code', 'product_number'), sep='-')
df <- df %>% mutate(product_category = paste0(prod_cat[product_code]), full_address = paste(address, city, country, sep = ","))
df <- df %>% select(-(address:name),everything())

## Cleaning up the DF a little before adding four new columns
df$len <- NULL
df$first_char <- NULL

## Now we add a binary column for the company and product category

### Since we already have a list defined for the companies, we'll use a for loop to go through each one and
###  evaluate each company, while adding a header that corresponds to the company we're evaluating

for (i in 1:4) {
  i_company <- comp_char[[2]][i]
  i_header <- paste("company", i_company, sep = "_")
  df[[paste0(i_header)]] <- as.numeric(df$company == paste0(i_company))
}

### Similarly, we'll do the same thing with the product category
### We'll just use the product's code (p, v, x, q) along with it's list we created earlier

for (i in 1:4) {
  i_product <- names(prod_cat)[i]
  i_header <- paste("product", prod_cat[i], sep = "_")
  df[[paste0(i_header)]] <- as.numeric(df$product_code == paste0(i_product))
}

rm(i, i_company, i_header, i_product)

write.csv(df, file = "refine_clean.csv")
