## Not really much for us to do here other than copy and paste our data into the R file.

## Without much flair or cool outputs - here is the code.

####-------- PASTE -------------####

# titanic is avaliable in your workspace

# Check out the structure of titanic
str(titanic)

# Use ggplot() for the first instruction
ggplot(titanic, aes(x = factor(Pclass), fill = factor(Sex))) +
  geom_bar(position = "dodge")


# Use ggplot() for the second instruction
ggplot(titanic, aes(x = factor(Pclass), fill = factor(Sex))) +
  geom_bar(position = "dodge") +
  facet_grid(.~Survived)

# Position jitter (use below)
posn.j <- position_jitter(0.5, 0)

# Use ggplot() for the last instruction
ggplot(titanic, aes(x = factor(Pclass),
                    y = Age,
                    col = factor(Sex))) +
  geom_jitter(position = posn.j, alpha = 0.5, size = 3) +
  facet_grid(.~Survived)