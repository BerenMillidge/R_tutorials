# okay, I'm going to now do the time series tutorial
# because that will be useful at some point, and might probie a cool distraction
# tutorial from here: https://ourcodingclub.github.io/2017/04/26/time.html
# time series tutorial here... who knwos?

# downloaded the zip github archive - set working directory to new place
getwd()
setwd("/home/beren/work/phd/eyetracking/R_tutorials/CC-time-series-master")

#download packages
library(ggplot2)
library(forecast)
library(dplyr)
library(colortools)

# load the csv files
monthly_milk <- read.csv('monthly_milk.csv')
daily_milk <- read.csv('daily_milk.csv')


# so commonly, and this is a serious usability issue with R, is getting the data into time series format
# that R can easily udnerstand, as well as any other packages
# so an easy way is to put it in yyyy-mm-dd hh-mm-ss format, to try to get that figuerd out

# leats check the form of the data set
head(monthly_milk)
# so its in year format and then just a lst
# then form
class(monthly_milk)
class(monthly_milk$month)
# so here the month is currently being interpreted as a factor, which have distinct categories
# but no sequential order or hierarchy, sothat's not great.
# so you need to coerce to Rs date calss
monthly_milk$month_date <- as.Date(monthly_milk$month, format = "%Y-%m-d")
#and check it worked
class(monthly_milk$month_date)
# alternatively you want both date and times-- you append it after the date in some column format like
#2017-02-25 18:30:45 with colon format
# use the POSIXct POSIXt class to figure this out
head(daily_milk)
class(daily_milk$date_time)
# so again its a factor... need to convert
daily_milk$date_time_posix <- as.POSIXct(daily_milk$date_time, format="%Y-%m-%d %H:%M:%S")
class(daily_milk$date_time_posix)
# so yay its a posix tuple... that's good!
# I just thought... it could be fun, if there are huge datasets in the eye tracking
# to try converting it over and running some analyses in Julia... that could be really fun
# and a very useful and educational experience as I will have an actual task to try to accomplish
# in Julia then, which would be good!
# next step is visualising with ggplot
# scale x date is used easily
ggplot(monthly_milk, aes(x = month_date, y = milk_prod_per_cow_kg)) +
  geom_line() +
  scale_x_date(date_labels = "%Y", date_breaks = "1 year") +
  theme_classic()


# also plot the daily milk data
ggplot(daily_milk, aes(x=date_time_posix, y=milk_prod_per_cow_kg)) +
  geom_line() + 
  scale_x_datetime(date_labels="%p-%d", date_breaks = "36 hour") +
  theme_classic()

# so that' scool. a reasonable simple looking trend!
# so, time series data is generally composed of multiple trends...
# there is often trends at different timescales - i.e. long term trends
# masked by shorter term periodic fluctuations, masked by random noise
# to see the long term yo ucan plot a loess regression of the data
# i.e. one which fits a smooth curve

ggplot(daily_milk, aes(x=date_time_posix, y=milk_prod_per_cow_kg)) +
  geom_line() + 
  geom_smooth(method='loess', se=FALSE, span=0.6) +
  theme_classic()

# so there are clearly also seasonal looking patterns
# investige more by plotting each year as its own line and comparing

# extract month and year and store in separate columns - this i sthe kind of 
# data analysis I need to actually start doing on eyetracking with R
