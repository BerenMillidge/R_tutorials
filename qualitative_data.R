library(MASS)
painters
str(painters)
# perhaps also get dataframe column by name using $ sign
painters$School

# get the frequency distribution
school <- painters$School
school.freq <- table(school)
# so school is ano bject and freq is an attribute assigned with the .?
school.freq

# can turn into column format with cbind
cbind(school.freq)

# composition school
cscores <- painters$Composition
cscores.freq <- table(cscores)
cscores.freq

school.most <- max(school.freq)
school.most
# well that was intuitive!

# relative frequencies!
school.relfreq <- school.freq / nrow(painters)
cscores.relfreq <- cscores.freq / nrow(painters)

# bar graphs! yay!
colors <- c("red", "yellow", "green", "violet", "orange", "blue", "pink", "cyan")
barplot(school.freq, col=colors)

barplot(cscores.freq, col=colors)

pie(school.freq,col=colors)



