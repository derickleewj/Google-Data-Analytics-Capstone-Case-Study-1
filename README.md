## Google Data Analytics Capstone – Case Study 1

<i>* Note: Capstone originally uploaded onto Kaggle on February 2022. To view, visit <a href = "https://www.kaggle.com/drcqel/google-data-analytics-capstone-case-study-1">here.</a> </i>

### Introduction

This notebook contains a series of analysis for the first case study as part of the Google Data Analytics Certificate capstone project on Coursera. To help answer the key business questions presented in the case study, the data analysis process will be guided with following steps – Ask, Prepare, Process, Analyze, Share and Act.

#### Scenario

You are a junior data analyst working in the marketing analyst team at Cyclistic, a bike-share company in Chicago. The director of marketing believes the company’s future success depends on maximizing the number of annual memberships. Therefore, your team wants to understand how casual riders and annual members use Cyclistic bikes differently. From these insights, your team will design a new marketing strategy to convert casual riders into annual members. But first, Cyclistic executives must approve your recommendations, so they must be backed up with compelling data insights and professional data visualizations.

### ASK

#### Business Task

1. To identify consumer differences between subscribed, annual members vs. casual riders to improve conversion rates for casual riders to members.
2. Providing recommendations post-analysis to help drive a more successful campaign in converting casual riders to annual members.
linkcode

### PREPARE

• Data source: <a href = "https://divvy-tripdata.s3.amazonaws.com/index.html">Link </a> <br>
• Extracted data: Jan 2021 to Apr 2021 (4 months) made available by Motivate International Inc. under this <a href="https://ride.divvybikes.com/data-license-agreement">license</a>. Data extracted was shortened to only 4 months as files for the rest of 2021 were too large and caused R Studio Cloud to crash constantly.

#### Limitations

Due to data-privacy issues, the data provided prohibit users from using riders’ personally identifiable information. The data won’t be able to identify pass purchases to credit card numbers to determine if casual riders live in the Cyclistic service area or if they have purchased multiple single passes.
It is also good to keep in mind that the trend analyzed is only for the first 4 months of 2021 and not the general year to provide a gauge of usage trends among users.

For this case study, <b><i>R</i></b> will be used for analysis and to generate data viz accordingly. (The R file has also been uploaded into this folder for referencing purposes.)

---

```
## Step 1: Installing required packages
install.packages("tidyverse")
install.packages("lubridate")
install.packages("ggplot2")

library(tidyverse)
library(lubridate)
library(ggplot2)
```

```
## Step 2: Importing .csv data files into R with read_csv()
## Files will be renamed with format: mth_YYYY

jan_2021 <- read.csv("202101-divvy-tripdata.csv")
feb_2021 <- read.csv("202102-divvy-tripdata.csv")
mar_2021 <- read.csv("202103-divvy-tripdata.csv")
apr_2021 <- read.csv("202104-divvy-tripdata.csv")
```
### PROCESS

Column inspection will be conducted to ensure all 5 data files tally in information.

```
## Step 3: Inspecting columns across all 5 data files
colnames(jan_2021)
colnames(feb_2021)
colnames(mar_2021)
colnames(apr_2021)
```

![Column inspection](https://user-images.githubusercontent.com/101308673/157872616-e117fdde-5e2b-4621-bb47-2fae0baa6f56.png)

Next, rows across all 4 data files with missing values across any columns will be dropped using na.omit(). Before that, the glimpse() function was used to check on the type of data within the data frame.

![Unknown-2](https://user-images.githubusercontent.com/101308673/157872773-ad90e77e-dc91-4edd-871d-cecfa10f7dbb.png)

As seen in the sample month (January 2021) above, the data is characterized under 2 categories – character (chr) and double (dbl), where each contain strings and numbers respectively. There were also several missing/unidentified values as depicted with "" in the first few rows of the data and they will be replaced with "NA" in order to use na.omit() effectively.

```
## Step 4: Once columns tally, replace all blank, spaced or NA values with NA in data set by re-importing the data file with the following syntax and use na.omit() to remove the rows
    ## January 2021 - 96,834 obs. down to 83,509 obs.
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
```

Next, all 4 data files were combined into a singular file and named as all_trips.

```
## Step 5: Combine all 4 data files into one as all_trips - total 630,403 obs.
all_trips <- bind_rows(jan_2021_filtered, feb_2021_filtered, mar_2021_filtered, apr_2021_filtered)
```

Within the newly created, combined data frame, a new column is added to calculate the total duration (in mins) for every trip. New columns are also added to split the started_at column into their respective formats (day, date, month, year).

```
## Step 6a: Add a new column to calculate total duration taken for each trip, named trip_duration in minutes
all_trips$trip_duration <- difftime(all_trips$ended_at, all_trips$started_at, units = "mins")

## Step 6b: Add columns to split started_at into respective formats (day, date, month, year)
all_trips$date <- as.Date(all_trips$started_at)
all_trips$month <- format(as.Date(all_trips$date), "%m")
all_trips$day <- format(as.Date(all_trips$date), "%d")
all_trips$year <- format(as.Date(all_trips$date), "%Y")
all_trips$day_of_week <- format(as.Date(all_trips$date), "%A")
```
A glimpse of the data frame will now show the following:

![Unknown-3](https://user-images.githubusercontent.com/101308673/157875631-23c3e283-164e-4b19-90b8-2836b2d5deba.png)

### ANALYZE

Next, key descriptive analysis of the data will be pulled out to gain further understanding of user habits. These include:

1. Mean of trip_duration
2. Median of trip_duration
3. Max of trip_duration
4. Min of trip_duration

```
## Step 7: Pull data on key descriptive analysis of data (i.e Mean, Median, Max, Min)
mean(all_trips$trip_duration)
median(all_trips$trip_duration)
max(all_trips$trip_duration)
min(all_trips$trip_duration)
```

Upon figures pulled, the min duration indicated a negative value as seen below:

![Unknown-4](https://user-images.githubusercontent.com/101308673/157876498-fdb855ea-ffd1-445c-924e-c654d808f6ba.png)

The following code will remove rows from all_trips containing any negative values in the trip_duration column.

```
## Remove rows with negative trip_duration values from all_trips
    ### 630,403 obs. down to 630,388 obs.
all_trips_v2 <- all_trips %>% 
    filter(trip_duration > 0)

## Check all descriptive values of trip_duration again to ensure no negative values
mean(all_trips_v2$trip_duration)
median(all_trips_v2$trip_duration)
max(all_trips_v2$trip_duration)
min(all_trips_v2$trip_duration)
```

The new descriptive values from the filtered all_trips_v2 data frame now shows no negative values. Note that the mean and min values have changed.

![Unknown-5](https://user-images.githubusercontent.com/101308673/157877398-7e02b510-3232-4bc6-940a-1646cef879a1.png)

Next, the difference of the same set of descriptive values between members and casual riders are then compared.

```
## Step 8: Determine the difference between members and casual riders.
aggregate(all_trips_v2$trip_duration ~ all_trips_v2$member_casual, FUN = mean)
aggregate(all_trips_v2$trip_duration ~ all_trips_v2$member_casual, FUN = median)
aggregate(all_trips_v2$trip_duration ~ all_trips_v2$member_casual, FUN = max)
aggregate(all_trips_v2$trip_duration ~ all_trips_v2$member_casual, FUN = min)
```

![Unknown-6](https://user-images.githubusercontent.com/101308673/157877481-ef1ee1fe-2962-45e9-aff3-bcc5587fc1bb.png)

Note that casual riders surpass members in most aspects (except in min) for duration of the bike service used.

Next, the difference in average timings used by members and casual riders across the days of the week are determined. The days are first sorted to give sequential order from Monday to Sunday.

```
## Step 9: Determine average ride time by day between members and casual riders, but first sort the days of week in order
all_trips_v2$day_of_week <- ordered(all_trips_v2$day_of_week, levels=c("Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday", "Sunday"))
aggregate(all_trips_v2$trip_duration ~ all_trips_v2$member_casual + all_trips_v2$day_of_week, FUN = mean)
```

Respective details are as shown.

![Unknown-7](https://user-images.githubusercontent.com/101308673/157877664-2341ee52-d47b-4d2e-824a-fd6bbf5cd42f.png)

From the above analysis, we can see that:

1. Casual riders spent, on overall, longer durations than members across all days of the week
2. Trip duration over the weekends are higher than weekdays for both members and casual riders

Next, the number of rides between members and casual riders are determined across both weekdays and weekends.

```
## Step 10: Determine the number of rides across both members and casual riders across weekdays and weekends.
rides_by_day <- all_trips_v2 %>% 
  group_by(member_casual, day_of_week) %>% 
  summarise(number_of_rides = n()
            ,average_duration = mean(trip_duration)) %>% 
  arrange(member_casual, day_of_week)
```
The following is shown:

From the above, we can see that:

1. Members utilise the service far more than casual riders during weekdays
2. Number of rides peaked the most during weekends across both members and casual riders

### SHARE

Next, visualizations are generated for digestable information at a glance. The visualizations to generate are:

1. Number of rides across all users per week, across a 4 month period
2. Average duration across all users per week, across a 4 month period

```
## Step 11a: Generate data viz - Number of rides across the week for all users
ggplot(rides_by_day, aes(x=day_of_week, y=number_of_rides, fill=member_casual)) +
  geom_bar(position="dodge", stat="identity") +
  labs(x = "Day of Week", y = "Number of Rides", fill = "Member/Casual",
       title = "Average Number of Rides by Day: Members vs. Casual Riders")
```

```
## Step 11b: Generate data viz - Average duration across the week for all users
ggplot(rides_by_day, aes(x=day_of_week, y=average_duration, fill=member_casual)) +
  geom_bar(position="dodge", stat="identity") +
  labs(x = "Day of Week", y = "Average Trip Duration", fill = "Member/Casual",
       title = "Average Ride Duration by Day: Members vs. Casual Riders")
```

Key findings include:

1. <b>Casual riders surpass in average trip duration far more than members.</b> This could be attributed to planned usage for long distance, leisure activities (e.g exercising, holiday activities) that are not routine-based which normally are short distance rides (e.g cycling from train stations to offices during weekdays).
2. <b>Casual riders utilise the service most on weekends.</b> In relation to point 1 above, weekend usage are significantly higher among casual riders which could be due to leisure activities.
3. <b>Members, on average, take shorter but more consistent rides.</b> The utilisation of the service by members were more consistent, albeit being shorter in duration - which supports the hypothesis of usage being routine-based activities that contributes to these figures.

### ACT
With the above key findings, proposed recommendations to help convert casual riders to members are as follows:

1. Promote membership and highlight benefits in targeted digital campaigns to raise awareness.
2. Introduce tiered membership levels to cater to the varied needs of users (e.g weekday focused VS weekday focus tiers) at attractive and competitive rates.
3. Consider activity-based subscription services (e.g renting for multi-day use for a biking activity) seeing casual riders utilise the service for longer duration.
       
---
