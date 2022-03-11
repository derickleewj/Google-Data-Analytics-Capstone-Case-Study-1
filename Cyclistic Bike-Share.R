## Step 1: Installing required packages

install.packages("tidyverse")
install.packages("lubridate")
install.packages("ggplot2")

library(tidyverse)
library(lubridate)
library(ggplot2)

## Step 2: Importing .csv data files into R with read_csv()
## Files will be renamed with format: mth_YYYY

jan_2021 <- read.csv("202101-divvy-tripdata.csv")
feb_2021 <- read.csv("202102-divvy-tripdata.csv")
mar_2021 <- read.csv("202103-divvy-tripdata.csv")
apr_2021 <- read.csv("202104-divvy-tripdata.csv")

## Step 3: Inspecting columns across all 4 data files
colnames(jan_2021)
colnames(feb_2021)
colnames(mar_2021)
colnames(apr_2021)

## Step 4: Once columns tally, replace all blank, spaced or NA values with NA in data set by re-importing the data file with the following syntax and use na.omit() to remove the rows
  ### January 2021 - 96,834 obs. down to 83,509 obs.
jan_2021 <- read.csv("202101-divvy-tripdata.csv", header=T, na.strings = c(""," ", "NA"))
jan_2021_filtered <- na.omit(jan_2021)

  ## February 2021 - 49,622 obs. down to 42,996 obs.
feb_2021 <- read.csv("202102-divvy-tripdata.csv", header=T, na.strings = c(""," ", "NA"))
feb_2021_filtered <- na.omit(feb_2021)

  ## March 2021 - 228,496 obs. down to 205,691 obs.
mar_2021 <- read.csv("202103-divvy-tripdata.csv", header=T, na.strings = c(""," ", "NA"))
mar_2021_filtered <- na.omit(mar_2021)
  
  ## April 2021 - 337,230 obs. down to 298,207 obs.
apr_2021 <- read.csv("202104-divvy-tripdata.csv", header=T, na.strings = c(""," ", "NA"))
apr_2021_filtered <- na.omit(apr_2021)

## Step 5: Combine all 4 data files into one as all_trips - total 630,403 obs.
all_trips <- bind_rows(jan_2021_filtered, feb_2021_filtered, mar_2021_filtered, apr_2021_filtered)

## Step 6a: Add a new column to calculate total duration taken for each trip, named trip_duration in minutes
all_trips$trip_duration <- difftime(all_trips$ended_at, all_trips$started_at, units = "mins")

## Step 6b: Add columns to split started_at into respective formats (day, date, month, year)
all_trips$date <- as.Date(all_trips$started_at)
all_trips$month <- format(as.Date(all_trips$date), "%m")
all_trips$day <- format(as.Date(all_trips$date), "%d")
all_trips$year <- format(as.Date(all_trips$date), "%Y")
all_trips$day_of_week <- format(as.Date(all_trips$date), "%A")

## Step 7: Pull data on key descriptive analysis of data (i.e Mean, Median, Max, Min)
mean(all_trips$trip_duration)
median(all_trips$trip_duration)
max(all_trips$trip_duration)
min(all_trips$trip_duration)

  ## Remove rows with negative trip_duration values from all_trips
    ### 630,403 obs. down to 630,388 obs.
  all_trips_v2 <- all_trips %>% 
    filter(trip_duration > 0)
  
  ## Check all descriptive values of trip_duration again to ensure no negative values
  mean(all_trips_v2$trip_duration)
  median(all_trips_v2$trip_duration)
  max(all_trips_v2$trip_duration)
  min(all_trips_v2$trip_duration)
  
## Step 8: Determine the difference between members and casual riders.
aggregate(all_trips_v2$trip_duration ~ all_trips_v2$member_casual, FUN = mean)
aggregate(all_trips_v2$trip_duration ~ all_trips_v2$member_casual, FUN = median)
aggregate(all_trips_v2$trip_duration ~ all_trips_v2$member_casual, FUN = max)
aggregate(all_trips_v2$trip_duration ~ all_trips_v2$member_casual, FUN = min)

## Step 9: Determine average ride time by day between members and casual riders, but first sort the days of week in order
all_trips_v2$day_of_week <- ordered(all_trips_v2$day_of_week, levels=c("Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday", "Sunday"))
aggregate(all_trips_v2$trip_duration ~ all_trips_v2$member_casual + all_trips_v2$day_of_week, FUN = mean)

## Step 10: Determine the number of rides across both members and casual riders across weekdays and weekends.
rides_by_day <- all_trips_v2 %>% 
  group_by(member_casual, day_of_week) %>% 
  summarise(number_of_rides = n()
            ,average_duration = mean(trip_duration)) %>% 
  arrange(member_casual, day_of_week)

## Step 11a: Generate data viz - Number of rides across the week for all users
ggplot(rides_by_day, aes(x=day_of_week, y=number_of_rides, fill=member_casual)) +
  geom_bar(position="dodge", stat="identity") +
  labs(x = "Day of Week", y = "Number of Rides", fill = "Member/Casual",
       title = "Average Number of Rides by Day: Members vs. Casual Riders")

## Step 11b: Generate data viz - Average duration across the week for all users
ggplot(rides_by_day, aes(x=day_of_week, y=average_duration, fill=member_casual)) +
  geom_bar(position="dodge", stat="identity") +
  labs(x = "Day of Week", y = "Average Trip Duration (Mins)", fill = "Member/Casual",
       title = "Average Ride Duration by Day: Members vs. Casual Riders")