Tidy Time Series and Forecasting in R
================

### rstudio::conf 2020

by Rob J Hyndman

-----

INSTRUCTIONS FOR INSTRUCTORS: Please insert information about your
workshop below. Then, add workshop content in the materials folder and
link to each session’s materials from the schedule below. You are
welcomed to add more rows to the schedule. We just ask that you take
breaks at the specified times. Once you are done adding information, you
can remove these instructions from the README.

-----

:spiral_calendar: 27-28 January 2020
:alarm_clock:     09:00 - 17:00
:hotel:           \[ADD ROOM\]
:writing_hand:    [rstd.io/conf](http://rstd.io/conf)

-----

## Overview

It is becoming increasingly common for organizations to collect huge amounts of data over time, and existing time series analysis tools are not always suitable to handle the scale, frequency and structure of the data collected. In this workshop, we will look at some new packages and methods that have been developed to handle the analysis of large collections of time series.

On day 1, we will look at the tsibble data structure for flexibly managing collections of related time series. We will look at how to do data wrangling, data visualizations and exploratory data analysis. We will explore feature-based methods to explore time series data in high dimensions. A similar feature-based approach can be used to identify anomalous time series within a collection of time series, or to cluster or classify time series. Primary packages for day 1 will be [tsibble](https://cran.r-project.org/package=tsibble), [lubridate](https://cran.r-project.org/package=lubridate) and [feasts](https://cran.r-project.org/package=feasts) (along with the [tidyverse](http://tidyverse.org) of course).

Day 2 will be about forecasting. We will look at some classical time series models and how they are automated in the [fable](https://cran.r-project.org/package=fable) package. We will look at creating ensemble forecasts and hybrid forecasts, as well as some new forecasting methods that have performed well in large-scale forecasting competitions. Finally, we will look at forecast reconciliation, allowing millions of time series to be forecast in a relatively short time while accounting for constraints on how the series are related.

## Learning objectives

Attendees will learn:

1. How to wrangle time series data with familiar tidy tools.
2. How to compute time series features and visualize large collections of time series.
3. How to select a good forecasting algorithm for your time series.
4. How to ensure forecasts of a large collection of time series are coherent.

## Is this course for me?

This course will be appropriate for you if you answer yes to these questions:

1. Do you already use the tidyverse packages in R such as dplyr, tidyr, tibble and ggplot2?
2. Do you need to analyse large collections of related time series?
3. Would you like to learn how to use some new tidy tools for time series analysis including visualization, decomposition and forecasting?

## Prework

Attendees are expected to have R and RStudio installed on their own computers, along with the [`tidyverse`](http://tidyverse.org) and [`fpp3`](http://pkg.robjhyndman.com/fpp3-package) packages and their dependencies.

```r
install.packages(c("tidyverse","fpp3","readxl","GGally","sugrrants"))
```

## Schedule

| Time          | Activity         |
| :------------ | :--------------- |
| 09:00 - 10:30 | Session 1        |
| 10:30 - 11:00 | *Coffee break*   |
| 11:00 - 12:30 | Session 2        |
| 12:30 - 13:30 | *Lunch break*    |
| 13:30 - 15:00 | Session 3        |
| 15:00 - 15:30 | *Coffee break*   |
| 15:30 - 17:00 | Session 4        |

## Instructor

**Rob J Hyndman** is Professor of Statistics and Head of the [Department of Econometrics and Business Statistics](http://business.monash.edu/econometrics-and-business-statistics) at [Monash University](https://www.monash.edu). From 2005 to 2018 he was Editor-in-Chief of the *[International Journal of Forecasting](http://ijf.forecasters.org/)* and a Director of the [International Institute of Forecasters](http://forecasters.org/). Rob is the author of over 150 research papers and 5 books in statistical science. In 2007, he received the Moran medal from the Australian Academy of Science for his contributions to statistical research, especially in the area of statistical forecasting. For over 30 years, Rob has maintained an active consulting practice, assisting hundreds of companies and organizations around the world. He has won awards for his research, teaching, consulting and graduate supervision.

He has coauthored about 40 R packages, many of which are on CRAN. He is best known for the [**forecast**](https://cran.r-project.org/package=forecast) package. This workshop will be based around a suite of new packages he has been developing to do time series analysis and forecasting using tidy principles.

## Slides

### Day 1

  0. [Background](https://github.com/rstudio-conf-2020/time-series-forecasting/raw/master/materials/0-intro.pdf)
  1. [Introduction to tsibbles](https://github.com/rstudio-conf-2020/time-series-forecasting/raw/master/materials/1-tsibbles.pdf)
  2. [Time series graphics](https://github.com/rstudio-conf-2020/time-series-forecasting/raw/master/materials/2-graphics.pdf)
  3. [Transformations](https://github.com/rstudio-conf-2020/time-series-forecasting/raw/master/materials/3-transformations.pdf)
  4. [Seasonality and trends](https://github.com/rstudio-conf-2020/time-series-forecasting/raw/master/materials/4-decompositions.pdf)
  5. [Time series features](https://github.com/rstudio-conf-2020/time-series-forecasting/raw/master/materials/5-feasts.pdf)

### Day 2

  6. [Introduction to forecasting](https://github.com/rstudio-conf-2020/time-series-forecasting/raw/master/materials/6-fable.pdf)
  7. [Exponential smoothing](https://github.com/rstudio-conf-2020/time-series-forecasting/raw/master/materials/7-ets.pdf)
  8. [ARIMA models](https://github.com/rstudio-conf-2020/time-series-forecasting/raw/master/materials/8-arima.pdf)
  9. [Dynamic regression](https://github.com/rstudio-conf-2020/time-series-forecasting/raw/master/materials/9-dynamic-regression.pdf)
  10. [Hierarchical forecasting](https://github.com/rstudio-conf-2020/time-series-forecasting/raw/master/materials/10-reconciliation.pdf)

## Lab Sessions

### Lab Session 1

 1. Download [`tourism.xlsx`](http://robjhyndman.com/data/tourism.xlsx) from [`http://robjhyndman.com/data/tourism.xlsx`](http://robjhyndman.com/data/tourism.xlsx), and read it into R using `read_excel()` from the `readxl` package.
 2. Create a tsibble which is identical to the `tourism` tsibble from the `tsibble` package.
 3. Find what combination of `Region` and `Purpose` had the maximum number of overnight trips on average.
 4. Create a new tsibble which combines the Purposes and Regions, and just has total trips by State.

### Lab Session 2

- Create time plots of the following four time series: `Bricks` from `aus_production`, `Lynx` from `pelt`, `Close` from `gafa_stock`, `Demand` from `vic_elec`.
- Use `help()` to find out about the data in each series.
- For the last plot, modify the axis labels and title.

### Lab Session 3

1. Look at the quarterly tourism data for the Snowy Mountains

    ```r
    snowy <- tourism %>% filter(Region == "Snowy Mountains")
    ```

    - Use `autoplot()`, `gg_season()` and `gg_subseries()` to explore the data.
    - What do you learn?

2. Produce a calendar plot for the `pedestrian` data from one location and one year.

### Lab Session 4

We have introduced the following functions: `gg_lag` and `ACF`. Use these functions to explore the four time series: `Bricks` from `aus_production`, `Lynx` from `pelt`, `Close` price of Amazon from `gafa_stock`, `Demand` from `vic_elec`. Can you spot any seasonality, cyclicity and trend? What do you learn about the series?

### Lab Session 5

You can compute the daily changes in the Google stock price in 2018 using

```{r, eval = FALSE}
dgoog <- gafa_stock %>%
  filter(Symbol == "GOOG", year(Date) >= 2018) %>%
  mutate(trading_day = row_number()) %>%
  update_tsibble(index=trading_day, regular=TRUE) %>%
  mutate(diff = difference(Close))
```

Does `diff` look like white noise?

### Lab Session 6

Consider the GDP information in `global_economy`. Plot the GDP per capita for each country over time. Which country has the highest GDP per capita? How has this changed over time?

### Lab Session 7

1. For the following series, find an appropriate Box-Cox transformation in order to stabilise the variance.

    * United States GDP from `global_economy`
    * Slaughter of Victorian “Bulls, bullocks and steers” in `aus_livestock`
    * Victorian Electricity Demand from `vic_elec`.
    * Gas production from `aus_production`

2. Why is a Box-Cox transformation unhelpful for the `canadian_gas` data?

### Lab Session 8

1. Produce the following decomposition

    ```r
    canadian_gas %>%
      STL(Volume ~ season(window=7) + trend(window=11)) %>%
      autoplot()
    ```

2. What happens as you change the values of the two `window` arguments?

3. How does the seasonal shape change over time? [Hint: Try plotting the seasonal component using `gg_season`.]

4. Can you produce a plausible seasonally adjusted series? [Hint: `season_adjust` is one of the variables returned by `STL`.]

### Lab Session 9

 * Use ``GGally::ggpairs()`` to look at the relationships between the STL-based features. You might wish to change `seasonal_peak_year` and `seasonal_trough_year` to factors.
 * Which is the peak quarter for holidays in each state?

### Lab Session 10

* Use a feature-based approach to look for outlying series in `PBS`.
* What is unusual about the series you identify as "outliers".

### Lab Session 11

 * Produce forecasts using an appropriate benchmark method for household wealth (`hh_budget`). Plot the results using `autoplot()`.
 * Produce forecasts using an appropriate benchmark method for Australian takeaway food turnover (`aus_retail`). Plot the results using `autoplot()`.

### Lab Session 12

  * Compute seasonal naïve forecasts for quarterly Australian beer production from 1992.
  * Test if the residuals are white noise. What do you conclude?

### Lab Session 13

 * Create a training set for household wealth (`hh_budget`) by witholding the last four years as a test set.
 * Fit all the appropriate benchmark methods to the training set and forecast the periods covered by the test set.
 * Compute the accuracy of your forecasts. Which method does best?
 * Repeat the exercise using the Australian takeaway food turnover data (`aus_retail`) with a test set of four years.

### Lab Session 14

Try forecasting the Chinese GDP from the `global_economy` data set using an ETS model.

Experiment with the various options in the `ETS()` function to see how much the forecasts change with damped trend, or with a Box-Cox transformation. Try to develop an intuition of what each is doing to the forecasts.

[Hint: use `h=20` when forecasting, so you can clearly see the differences between the various options when plotting the forecasts.]

### Lab Session 15

Find an ETS model for the Gas data from `aus_production` and forecast the next few years.

  * Why is multiplicative seasonality necessary here?
  * Experiment with making the trend damped. Does it improve the forecasts?

### Lab Session 16

For the United States GDP data (from `global_economy`):

 * Fit a suitable ARIMA model for the logged data.
 * Produce forecasts of your fitted model. Do the forecasts look reasonable?

### Lab Session 17

For the Australian tourism data (from `tourism`):

 * Fit a suitable ARIMA model for all data.
 * Produce forecasts of your fitted models.
 * Check the forecasts for the "Snowy Mountains" and "Melbourne" regions. Do they look reasonable?

### Lab Session 18


Repeat the daily electricity example, but instead of using a quadratic function of temperature, use a piecewise linear function with the "knot" around 20 degrees Celsius (use predictors `Temperature` & `Temp2`). How can you optimize the choice of knot?

The data can be created as follows.

```{r echo=TRUE, eval=FALSE}
vic_elec_daily <- vic_elec %>%
  filter(year(Time) == 2014) %>%
  index_by(Date = date(Time)) %>%
  summarise(
    Demand = sum(Demand)/1e3,
    Temperature = max(Temperature),
    Holiday = any(Holiday)) %>%
  mutate(
    Temp2 = I(pmax(Temperature-20,0)),
    Day_Type = case_when(
      Holiday ~ "Holiday",
      wday(Date) %in% 2:6 ~ "Weekday",
      TRUE ~ "Weekend"))
```

### Lab Session 19

Repeat Lab Session 16 but using all available data, and handling the annual seasonality using Fourier terms.

### Lab Session 20

* Prepare aggregations of the PBS data by Concession, Type, and ATC1.
* Use forecast reconciliation with the PBS data, using ETS, ARIMA and SNAIVE models, applied to all but the last 3 years of data.
* Which type of model works best?
* Does the reconciliation improve the forecast accuracy?
* Why doesn't the reconcililation make any difference to the SNAIVE forecasts?


-----

![](https://i.creativecommons.org/l/by/4.0/88x31.png) This work is
licensed under a [Creative Commons Attribution 4.0 International
License](https://creativecommons.org/licenses/by/4.0/).
