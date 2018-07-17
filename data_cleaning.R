# okay, so this is the tutorial on data cleaning from codingclub
# which appear to have excellent tutorials on all manner of things 
# in R - https://ourcodingclub.github.io/2017/01/16/piping.html

#tidyr library helps you tidy your data
# boxplots are actually surprisingly useful... you should use them/look
# at them more often!

# dplyr library has a bunch of useful functions that allow you to select
# only certain rows in your dataframe
library(dplyr)

germination = read.csv('Germination.csv', sep=';')
head(germination)

# then to get observations for the species
germination.SR = filter(germination, Species=='SR')
# i.e. it's like the filter higher order function from haskell/javascript
# can do it in R too though quite simply
germination.SR = germination[germination$Species == 'SR']
# these sorts of syntactic sugar things aren't strictly necessary!
# using filter yo ucan also subset for different criteria
germination.SR10 = filter(germination, Species=='SR', Nb_seeds_germin>=10)

# filter for columns is select()
germin_clean = select(germination, Species, Treatment, Nb_seeds_germin)
# where the others are columns
# if multiple conflicting function names you can specify the package name
# with the double colon i.e. dplyr::select

# mutate is really cool since you can create a new column 
# which is probaly a function of the other variables
# i.e. germination percentage
germin_percent = mutate(germination, Percent = Nb_seeds_germin/ Nb_seeds_tot * 100)
# which gives you an easy way to add extra columns in the analysis which is cool

# summarise also generates various summary statistics for the data
# so look into the dplyr package?

germin_average = summarise(germin_percent, Germin_average= mean(Percent))

# group by applies a functoin to different subsets
germin_grouped = group_by(germin_percent, Species, Treatment)

# so, to get a chain of functions applied to an object
# i.e. a proper R data analysis workflow, you can use pipes in R
# (I wonder if there is a Julia equivalent of this, because Rs ease is very ergonomic)
# anyhow, pipe operator is %>% and piping a  function passes dataframe
# and then sequentially through all the functions in the pipe chain until the end
# i.e. to recreate the previous summary:

germin_summary = germination %>% # this is the dataframe
                mutate(Percent = Nb_seeds_germin/Nb_seeds_tot * 100) %>%
                group_by(Species, Treatment) %>%
                summarise(Average= mean(Percent), SD = sd(Percent))

# i.e. this calculates percent germinating in all conditions, picks the species and treatment conditoins
# and calculates the mean and std percent germinating in species and treatment
# this is really straightforward and nice!
