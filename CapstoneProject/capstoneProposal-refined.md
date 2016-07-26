## Capstone Proposal
### Springboard Data Science Curriculum

After many different iterations of ideas and exploring datasets,
I think I have finally settled on a final project for a capstone project.
I have yet to work out all the fine details, but have at least some
of the foundations put together that my mentor helped me get to,
to where I have most of the pieces I'll need.

## Overview of the Question and Problem

> How will an individual perform in any ultra marathon event given
the elevation, distance, and number of entrants?

The basis for this question comes from the fact that ultra marathon
can vary drastically in terms of difficulty, 
even if they cover the same distance.

When competitors sign up for a race, they will certainly know the
distance they will be attempting (roughly), but the amount of
time it will take is relatively unknown. The goal here is to
try and take the different variables that make a race challenging
and factor those in, and come up with a model that will
help predict how a racer will do in a particular race.

## Potential Client

I do not have an actual client for this project, but the types
of companies that would benefit most from this would be those
that already attract clientelle that track their numbers and
are interested in a more detailed plan of attack to a race.

Companies that do this would be GPS watch manufacturers - the
most popular of the two in the ultra marathon community are
**Suunto** and **Garmin**. The data produced here would give
them additional software to add to their physical product.

Two additional companies that could benefit would be software
companies already geared towards pulling all GPS data together
from any watch company - **Training Peaks** and **Strava**.

One other ideas would be for this software to be part of a _running_
branch of a popular cycling estimator - [best bike split](https://www.bestbikesplit.com/).

## Data Source

Currently, I am working on compiling race data from 15 different races of varying distances.
The results from each race consists of all years the race took place. This is a manual
process, so requires a fair amount of data wrangling.

## Proposed Method

1. Gather race data and determine the most important factors for each race across the years
2. Variables will include, but not limited to:
		* Distance, number of racers, max and min elevation, elevation ascent and descent,
		overall time of each finisher, split times throughout race course (where applicable),
		bib number, gender, age, and year of race.
3. Split data into training and test data, and refine model.
4. Output from the model will be able to give a distribution of all finishers and their respective times.
By having the user input some previous race results or a targeted training run, 
the tool could then estimate their finish on a new course and distance.

## Final Product

At the outcome to this project, I hope to not only have a set of slides to detail the whole
process, but hopefully have a repository for my code that can be adapted to any sort of race
and any athlete can use to help better estimate their performance on race day.