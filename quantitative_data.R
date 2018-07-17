# uses the built in faithful dataset which is the observations of the old faithful
# geyser in yellowstone national park!
head(faithful)
duration = faithful$eruptions
duration
range(duration)

# set break point for the scatter plot
breaks = seq(1.5,5.5,by=0.5)
breaks
# so nextclassify the eruption urations according to the half unit sub intervals with cut
duration.cut = cut(duration, breaks, right=FALSE)
duration.freq = table(duration.cut)
duration.freq

# so waiting period is same
waiting = faithful$waiting
range(waiting)
breaks2 = seq(42, 96,by=4)
waiting.cut = cut(waiting, breaks2, right=FALSE)
waiting.freq = table(waiting.cut)
waiting.freq
waiting.most = max(waiting.freq)
str(waiting.freq)

# can also plot a histogram which is pretty cool!

hist(duration, right=FALSE, main='Old faithful eruptions', xlab='Duration minutes')
hist(waiting)
# so relative frequency is just normalized by the sample size
duration.relfreq = duration.freq / nrow(faithful)
waiting.relfreq = waiting.freq / nrow(faithful)

# you can find the cumulative frequeny by th cumsum function
duration.cumfreq = cumsum(duration.freq)

# next you can plot the graph of the cumulative frequency
# add a zero element then plot the graph
cumfreq0 = c(0, cumsum(duration.freq))
plot(breaks, cumfreq0,
     main = "Old faithful eruptions",
     xlab="Duration minutes",
     ylab="Cumulative eruptions")

# then join the points with lines
lines(breaks, cumfreq0)
# it is really really cool how easy and useful most of the graphs in R are.
# the producitivty of R is seriously great in this domain compared to python
# I do think I might be able to be convinced to switch to some extent
# which is amazing!
# can build an interpolation function with a cumulative distibution function ecdf

fn = ecdf(duration)
plot(fn)
# which is cool, and really easy that!

# there are also stem and leaf plots...
# these are trivially created with the stem fucntion
stem(duration)

# a scatter plot is also trivial to impleent here
# just a plot with two input arguments
plot(duration, waiting, xlab='Eruption Duration', ylab='Time waited')
# and you can plot  a linear regression with the lm functoin and a line 
# between them with the abline
# - R is truly amazing for this but OTOH, Julia can call all r_libraries
# perfectly so really there is no disadvantage there particularly, except 
# presumably around interoperability?
abline(lm(waiting ~ duration))

