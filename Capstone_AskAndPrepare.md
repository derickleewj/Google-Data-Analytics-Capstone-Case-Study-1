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
• Extracted data: Jan 2021 to Apr 2021 (4 months) made available by Motivate International Inc. under this license. Data extracted was shortened to only 4 months as files for the rest of 2021 were too large and caused R Studio Cloud to crash constantly.

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



