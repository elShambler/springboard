## File used to create simplify the original titanic dataframe

library(dplyr)

setwd('C:/Users/castillo/OneDrive/School/Springboard/FoundationsDS/dataWrangling/dw_2/')
titanic_original <- tbl_df(read.csv('titanic_original.csv', stringsAsFactors = F))

# Upon importing, the last row does not contain any information, so we'll remove it

titanic_original <- titanic_original[-nrow(titanic_original),]

# First, let's fix some known missing information.

## We are told the blank values in EMBARKED column should be 'S' since those passengers are known to have departed from Southampton

titanic_original$embarked[
  which(nchar(titanic_original$embarked) == 0)] = "S"

age_mean_m <- round(
  as.double(
    titanic_original %>% 
      filter(!is.na(age), sex == 'male') %>% 
      summarise(mean(age))
    )
  )

age_mean_f <- round(
  as.double(
    titanic_original %>% 
      filter(!is.na(age), sex == 'female') %>% 
      summarise(mean(age))
    )
  )

fare_mean <- round(
  as.double(
    titanic_original %>% 
      filter(!is.na(fare)) %>% 
      summarise(mean(fare))
    )
  )

# We'll adjust the ages that are NA to be replaced by the average age of an individual's respective sex
# Additionally, we'll adjuste any missing fares to be replaced by the total mean of all fares
## We can use a simple nested IFELSE statement to accomplish this task with MUTATE

titanic_df <- titanic_original %>% 
  mutate(age = 
           ifelse((is.na(age) & sex == 'male'),
                  age_mean_m,
                  ifelse((is.na(age) & sex == 'female'),
                         age_mean_f,
                         age)
                  ),
         fare = 
           ifelse(is.na(fare), fare_mean, fare)
         )

## For sanity sake, we'll make sure this did what we had hoped.
## Because the unmodified titanic DF will still have the missing values, we can use WHICH to find those and then
##  make sure they are replaced with the correct values
mean(titanic_df$age[
  is.na(titanic_original$age) & 
        titanic_original$sex == 'male'])

mean(titanic_df$age[
  is.na(titanic_original$age) & 
        titanic_original$sex == 'female'])

## The assignment asked for a different method of approximating age, although I decided to go one of the different methods for filling in the blanks.

## We'll do a little clean-up now that we've verified the columns we mutated from the original
rm(titanic_original)

# And we'll replace all blank ("") values in the BOAT column with NA (oneliner)
titanic_df <- titanic_df %>% 
  mutate(boat = ifelse(boat == "", NA, boat))

## The cabin value may be blank if a passenger was not able to secure their own room, or perhaps their ticket
## could not verify which room they were assigned to because the person did not survive.
## This may be useful in the end, so we'll add a binary column to indicate whether or not they had a cabin

titanic_df <- titanic_df %>%
  mutate(has_cabin_number = ifelse(cabin == "", 0, 1))

write.csv(x = titanic_df, "titanic_clean.csv", row.names = FALSE)
