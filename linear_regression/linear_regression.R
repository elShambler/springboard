#  Introduction
## ══════════════

#   • Learning objectives:
##     • Learn the R formula interface
##     • Specify factor contrasts to test specific hypotheses
##     • Perform model comparisons
##     • Run and interpret variety of regression models in R

## Set working directory
## _______________________________________________________
library(extrafont)
library(extrafontdb)
##   It is often helpful to start your R session by setting your working
##   directory so you don't have to type the full path names to your data
##   and other files

# set the working directory
# setwd("~/Desktop/Rstatistics")
# setwd("C:/Users/dataclass/Desktop/Rstatistics")
setwd("C:/Users/Tomas/OneDrive/School/Springboard/FoundationsDS/in-depth/linear_regression")

##   You might also start by listing the files in your working directory

getwd() # where am I?
list.files("dataSets") # files in the dataSets folder

## Load the states data
## ________________________________________________________

# read the states data
states.data <- readRDS("dataSets/states.rds") 
#get labels
states.info <- data.frame(attributes(states.data)[c("names", "var.labels")])
#look at last few labels
tail(states.info, 8)

#look at the structure of the data too
str(states.info)
str(states.data)

## Linear regression
##  ________________________________________________________

## Examine the data before fitting models
##  ________________________________________________________________________________________________________________

##   Start by examining the data to check for problems.

# summary of expense and csat columns, all rows
sts.ex.sat <- subset(states.data, select = c("expense", "csat"))
summary(sts.ex.sat)
# correlation between expense and csat
cor(sts.ex.sat)

## Plot the data before fitting models
##  ________________________________________________________

##   Plot the data to look for multivariate outliers, non-linear
##   relationships etc.

# scatter plot of expense vs csat
plot(sts.ex.sat)

## Linear regression example
##  ________________________________________________________

##   • Linear regression models can be fit with the `lm()' function
##   • For example, we can use `lm' to predict SAT scores based on
##     per-pupal expenditures:

# Fit our regression model
sat.mod <- lm(csat ~ expense, # regression formula
              data=states.data) # data set
# Summarize and print the results
summary(sat.mod) # show regression coefficients table

## Why is the association between expense and SAT scores /negative/?
##  ________________________________________________________

##   Many people find it surprising that the per-capita expenditure on
##   students is negatively related to SAT scores. The beauty of multiple
##   regression is that we can try to pull these apart. What would the
##   association between expense and SAT scores be if there were no
##   difference among the states in the percentage of students taking the
##   SAT?

summary(lm(csat ~ expense + percent, data = states.data))

## The lm class and methods
##  ________________________________________________________

##   OK, we fit our model. Now what?
##   • Examine the model object:

class(sat.mod)
names(sat.mod)
methods(class = class(sat.mod))[1:9]

##   • Use function methods to get more information about the fit

confint(sat.mod)
hist(residuals(sat.mod))

## Linear Regression Assumptions
##  ________________________________________________________

##   • Ordinary least squares regression relies on several assumptions,
##     including that the residuals are normally distributed and
##     homoscedastic, the errors are independent and the relationships are
##     linear.

##   • Investigate these assumptions visually by plotting your model:

par(mar = c(4, 4, 2, 2), mfrow = c(1, 2)) #optional
plot(sat.mod, which = c(1, 2)) # "which" argument optional

## Comparing models
##  ________________________________________________________

##   Do congressional voting patterns predict SAT scores over and above
##   expense? Fit two models and compare them:

# fit another model, adding house and senate as predictors
sat.voting.mod <-  lm(csat ~ expense + house + senate,
                      data = na.omit(states.data))
sat.mod <- update(sat.mod, data=na.omit(states.data))
# compare using the anova() function
anova(sat.mod, sat.voting.mod)
coef(summary(sat.voting.mod))

## Exercise: least squares regression
## ________________________________________________________

##   Use the /states.rds/ data set. Fit a model predicting energy consumed
##   per capita (energy) from the percentage of residents living in
##   metropolitan areas (metro). Be sure to
##   1. Examine/plot the data before fitting the model
##   2. Print and interpret the model `summary'
##   3. `plot' the model to look for deviations from modeling assumptions


par(mfrow = c(1,1))
en.metro.plot <- subset(states.data, select = c("metro", "energy"))
plot(en.metro.plot)

cor(en.metro.plot)

## It already seems like there is not going to be much of a correlation between these
## two variables. Let's see what the model tell us.

states.en <- lm(energy ~ metro, data = na.omit(states.data))

summary(states.en)

## In looking at the summary statistics of the model, the intercept has
## a greater significance than the variable `metro`.

## The associated t value, along with the plot, lead me to determine the metro
## variable is not the best predictor for energy consumption, and a revision to
## the model will be necessary.

## A closer look at some of the plots attributed with the model
## will give us a better understanding of the fit.

par(mfrow = c(1, 2))
plot(states.en, which = c(1, 2),
	main = "Statistical Model Plots",
	bg = "#fdfdfd", col.axis = "#434343", col.main = "#343434",
	pch = 16, cex.lab = 0.8, cex.axis = 0.8, cex.main = 1.1,
	font.main = 2, family = "Fira Sans", col = "#123e4e")

par(mfrow = c(1,1))
hist(residuals(states.en))
## Here we see these tools put to good use.

## First, we'll address the easy one. The first plot on the 
## Statistical Models plot showing the "RESIDUALS VS FITTED"
## shows there are quite a few outliers to the fit, along with
## what appears to be most of the residuals being less than zero,
## meaning the fit may not leave us with a homoscedastic fit.

## The Normal Q-Q plot helps us to understand the distribution
## and whether or not the errors are normally distributed or not.
## In theory, if the fit were normally distributed, the errors
## would fall along a 1:1 line on this plot - but they don't.
## In fact, the plot doesn't seem to have a correct 1:1 dashed
## line to begin with.

## A second plot of the histogram of the residuals reveals this
## is in fact the case.

## Nothing new - we'll need to enhance our model.



##   Select one or more additional predictors to add to your model and
##   repeat steps 1-3. Is this model significantly better than the model
##   with /metro/ as the only predictor?

## Let's add something that wouldn't intuitively make sense as a factor - Mean Composite SAT score (`csat`)
summary(lm(energy ~ metro + csat, data = na.omit(states.data)))

## It was worth looking into - I was just curious. Let's look at something that most likely has an effect:
### `waste` - per capita solid waste

summary(lm(energy ~ metro + waste, data = na.omit(states.data)))

## Nothing there. What about density?

summary(lm(energy ~ metro*density, data = na.omit(states.data)))

## I mean, it's better, but not really... What about two variables - greenhouse gas AND toxic released?
summary(lm(energy ~ metro + green + toxic, data = na.omit(states.data)))

## Nice - we seem to have found some better factors!
### Save this into its only model:
states.en.use <- lm(energy ~ metro + green + toxic, data = na.omit(states.data))

par(mfrow = c(1,2))
plot(states.en.use, which = c(1,2),
     main = "Statistical Model Plots",
     bg = "#fdfdfd", col.axis = "#434343", col.main = "#343434",
     pch = 16, cex.lab = 0.8, cex.axis = 0.8, cex.main = 1.1,
     font.main = 2, family = "Fira Sans", col = "#123e4e")

### That looks a lot better


## What does the ANOVA look like for these two models?
anova(states.en, states.en.use)


## Interactions and factors
##  ________________________________________________________

## Modeling interactions
##  ________________________________________________________

##   Interactions allow us assess the extent to which the association
##   between one predictor and the outcome depends on a second predictor.
##   For example: Does the association between expense and SAT scores
##   depend on the median income in the state?

  #Add the interaction to the model
sat.expense.by.percent <- lm(csat ~ expense*income,
                             data=states.data) 
#Show the results
  coef(summary(sat.expense.by.percent)) # show regression coefficients table

## Regression with categorical predictors
##  ________________________________________________________

##   Let's try to predict SAT scores from region, a categorical variable.
##   Note that you must make sure R does not think your categorical
##   variable is numeric.

# make sure R knows region is categorical
str(states.data$region)
states.data$region <- factor(states.data$region)
#Add region to the model
sat.region <- lm(csat ~ region,
                 data=states.data) 
#Show the results
coef(summary(sat.region)) # show regression coefficients table
anova(sat.region) # show ANOVA table

##   Again, *make sure to tell R which variables are categorical by
##   converting them to factors!*

## Setting factor reference groups and contrasts
##  ________________________________________________________

##   In the previous example we use the default contrasts for region. The
##   default in R is treatment contrasts, with the first level as the
##   reference. We can change the reference group or use another coding
##   scheme using the `C' function.

# print default contrasts
contrasts(states.data$region)
# change the reference group
coef(summary(lm(csat ~ C(region, base=4),
                data=states.data)))
# change the coding scheme
coef(summary(lm(csat ~ C(region, contr.helmert),
                data=states.data)))

##   See also `?contrasts', `?contr.treatment', and `?relevel'.

## Exercise: interactions and factors
##  ________________________________________________________

##   Use the states data set.

##   1. Add on to the regression equation that you created in exercise 1 by
##      generating an interaction term and testing the interaction.

##   2. Try adding region to the model. Are there significant differences
##      across the four regions?

## In order to add interaction, we'll add it to the Energy Usage by Metro Area + Greenhouse emission + Toxic Waste

## Recall: Our previous model
summary(states.en.use)

## We'll try adding a continuous variable as interaction - density
states.en.density <- update(states.en.use, . ~ . * density)
summary(states.en.inter)

# That doesn't look all that bad

## What about adding Region - first to the original model, then to the interaction from above?

states.en.region <- update(states.en.use, . ~ . * region)

states.en.complex <- update(states.en.use, . ~ . * density * region)

# We'll compare the summary of the two

summary(states.en.region)
summary(states.en.complex)

## The final model is quite complex (thus the name) but gives us the best fit model. I'm not sure I understand it
## completely though.