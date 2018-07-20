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
monthly_milk$year <- format(monthly_milk$month_date, format="%Y")
monthly_milk$month_num <- format(monthly_milk$month_date, format = "%m")

# create a colour palette using colour tools package
year_pal <- sequential(color="darkturquoise", percentage=5, what="value")

# make the lpot
ggplot(monthly_milk, aes(x=month_num, y=milk_prod_per_cow_kg, group=year)) +
  geom_line(aes(colour=year)) + 
  theme_classic() + 
  scale_color_manual(values=year_pal)

# so yeah, alternatively you can try to convert the time series
# into a specially desigated time series 'ts' object and then decompose it
#using stl() 
#transform to ts
monthly_milk_ts <- ts(monthly_milk$milk_prod_per_cow_kg, start=1962, end=1975, freq=12)

# decompose
monthly_milk_stl <-stl(monthly_milk_ts, s.window ='period')

# generate plots
plot(monthly_milk_stl)
# ooh! that generates a whole lod of easy plots which is awesome!
monthplot(monthly_milk_ts, choice="seasonal")
# oh wow! R is realy great at that... that's so cool
seasonplot(monthly_milk_ts)
# and that... that's so cool!

# so obviously just plotting trends over time is not enough... ultimately you want to forecast!
# one method is ETS methods - ets = error, trend, seasonality
# these are also called exponential smoothing state space models
# so it essneitally weights influenec of previous points based no how mnuch time is between them
# so its essentially a kind of weighted moving average
# other methods are ARIMA - autoregressive models which describe
# autocorrelations inthe data instead of trends and seasonliy
# so this: https://www.otexts.org/fpp - looks like a very simple - but decent
# introduction to how forecasting actually works and does stuff properly
# which makes perfect sense, and I should work through at some point... perhaps after the
# general linear model book to udnerstand the basics underlying LMER
# so ultiately should create obviously training ,validation, and test sets
# forvarious things... to test the reasonableness of the models... s let's do that!

monthly_milk_model <- window(x=monthly_milk_ts, start=c(1962), end=c(1970))
monthly_milk_test <- window(x=monthly_milk_ts, start=c(1970))

# so let's test various tpes of model
milk_ets_auto <- ets(monthly_milk_model)
milk_ets_mmm <- ets(monthyl_milk_model, model='MMM')
milk_ets_zzz <- ets(monthly_milk_model, model='ZZZ')
milk_ets_mmm_dampled <- ets(monthly_milk_model, model='MMM', damped = TRUE)

# create forecast objecs from the model objects
milk_ets_fc <- forecast(milk_ets_auto, h=60)
milk_ets_mmm_fc <- forecast(milk_ets_mmm, h=60)
milk_ets_zzz_fc <- forecast(milk_ets_zzz, h = 60)
milk_ets_mmm_damped_fc <- forecast(milk_ets_mmm_damped, h = 60)

# Convert forecasts to data frames
milk_ets_fc_df <- cbind("Month" = rownames(as.data.frame(milk_ets_fc)), as.data.frame(milk_ets_fc))  # Creating a data frame
names(milk_ets_fc_df) <- gsub(" ", "_", names(milk_ets_fc_df))  # Removing whitespace from column names
milk_ets_fc_df$Date <- as.Date(paste("01-", milk_ets_fc_df$Month, sep = ""), format = "%d-%b %Y")  # prepending day of month to date
milk_ets_fc_df$Model <- rep("ets")  # Adding column of model type

milk_ets_mmm_fc_df <- cbind("Month" = rownames(as.data.frame(milk_ets_mmm_fc)), as.data.frame(milk_ets_mmm_fc))
names(milk_ets_mmm_fc_df) <- gsub(" ", "_", names(milk_ets_mmm_fc_df))
milk_ets_mmm_fc_df$Date <- as.Date(paste("01-", milk_ets_mmm_fc_df$Month, sep = ""), format = "%d-%b %Y")
milk_ets_mmm_fc_df$Model <- rep("ets_mmm")

milk_ets_zzz_fc_df <- cbind("Month" = rownames(as.data.frame(milk_ets_zzz_fc)), as.data.frame(milk_ets_zzz_fc))
names(milk_ets_zzz_fc_df) <- gsub(" ", "_", names(milk_ets_zzz_fc_df))
milk_ets_zzz_fc_df$Date <- as.Date(paste("01-", milk_ets_zzz_fc_df$Month, sep = ""), format = "%d-%b %Y")
milk_ets_zzz_fc_df$Model <- rep("ets_zzz")

milk_ets_mmm_damped_fc_df <- cbind("Month" = rownames(as.data.frame(milk_ets_mmm_damped_fc)), as.data.frame(milk_ets_mmm_damped_fc))
names(milk_ets_mmm_damped_fc_df) <- gsub(" ", "_", names(milk_ets_mmm_damped_fc_df))
milk_ets_mmm_damped_fc_df$Date <- as.Date(paste("01-", milk_ets_mmm_damped_fc_df$Month, sep = ""), format = "%d-%b %Y")
milk_ets_mmm_damped_fc_df$Model <- rep("ets_mmm_damped")

# Combining into one data frame
forecast_all <- rbind(milk_ets_fc_df, milk_ets_mmm_fc_df, milk_ets_zzz_fc_df, milk_ets_mmm_damped_fc_df)

# Plotting with ggplot
ggplot() +
  geom_line(data = monthly_milk, aes(x = month_date, y = milk_prod_per_cow_kg)) +  # Plotting original data
  geom_line(data = forecast_all, aes(x = Date, y = Point_Forecast, colour = Model)) +  # Plotting model forecasts
  theme_classic()

accuracy(milk_ets_fc, monthly_milk_test)
accuracy(milk_ets_mmm_fc, monthly_milk_test)
accuracy(milk_ets_zzz_fc, monthly_milk_test)
accuracy(milk_ets_mmm_damped_fc, monthly_milk_test)
# so that's cool yo ucan test a bunch of statistics to determine
# the outcome of the forecasting models and see how that all worked
# which is really cool... but who knows?