# This mini-project is based on the K-Means exercise from 'R in Action'
# Go here for the original blog post and solutions
# http://www.r-bloggers.com/k-means-clustering-from-r-in-action/

# Exercise 0: Install these packages if you don't have them already

# install.packages(c("cluster", "rattle","NbClust"))

# Now load the data and look at the first few rows
data(wine, package="rattle")
head(wine)

# Exercise 1: Remove the first column from the data and scale
# it using the scale() function

wineScale <- scale(wine[-1])

# Now we'd like to cluster the data using K-Means. 
# How do we decide how many clusters to use if you don't know that already?
# We'll try two methods.

# Method 1: A plot of the total within-groups sums of squares against the 
# number of clusters in a K-means solution can be helpful. A bend in the 
# graph can suggest the appropriate number of clusters. 

wssplot <- function(data, nc=15, seed=1234){
	              wss <- (nrow(data)-1)*sum(apply(data,2,var))
               	      for (i in 2:nc){
		        set.seed(seed)
	                wss[i] <- sum(kmeans(data, centers=i)$withinss)}
	                
		      plot(1:nc, wss, type="b", xlab="Number of Clusters",
	                        ylab="Within groups sum of squares")
	   }

wssplot(wineScale)

# Exercise 2:
#   * How many clusters does this method suggest?
####    It's hard to tell for sure, but the plot would seem to suggest about 3 or 4 clusters.

#   * Why does this method work? What's the intuition behind it?
####    We start with the initial outlook on each column, and what the variance is
####    between each category, where this will serve as a baseline if we have only 1 cluster.
####    After that, we began calculating the distance between each centroid of the clusters we
####    create, and therefore are able to see how each cluster improves our variance within
####    the model.

#   * Look at the code for wssplot() and figure out how it works

# Method 2: Use the NbClust library, which runs many experiments
# and gives a distribution of potential number of clusters.

library(NbClust)
set.seed(1234)
nc <- NbClust(wineScale, min.nc=2, max.nc=15, method="kmeans")
barplot(table(nc$Best.n[1,]),
	          xlab="Number of Clusters", ylab="Number of Criteria",
		            main="Number of Clusters Chosen by 26 Criteria")


# Exercise 3: How many clusters does this method suggest?
### Wells it tells us pretty plainly - 3.


# Exercise 4: Once you've picked the number of clusters, run k-means 
# using this number of clusters. Output the result of calling kmeans()
# into a variable fit.km

fit.km <- kmeans(wineScale, 3)
str(fit.km)

# Now we want to evaluate how well this clustering does.

# Exercise 5: using the table() function, show how the clusters in fit.km$clusters
# compares to the actual wine types in wine$Type. Would you consider this a good
# clustering?
table(fit.km$cluster, wine$Type)

## I'm not entirely sure I'm reading the `table` function properly, but it would
##  that we only misplaced 6 wines total, of the 178. We do have the numbering off,
##  but in terms of getting like-wines in a category, we did quite well, I think.


# Exercise 6:
# * Visualize these clusters using  function clusplot() from the cluster library
# * Would you consider this a good clustering?
par(mfrow = c(1,1))
clusplot(wineScale, fit.km$cluster)

## Without getting too detailed in the explanation, or not having drunk all the wines on the list), the visual representation of the fit
##  seems to be quite good and separates the groups with minor overlap. There are 3 points that are right on the border of the left-most
##  clusters that are most likely one set of poor clusterings. The other 3 may be right on the border of the right-most cluster.