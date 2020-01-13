Tidy Time Series and Forecasting in R
================

### rstudio::conf 2020

by [Rob J Hyndman](https://robjhyndman.com)

:spiral_calendar: 27-28 January 2020
:alarm_clock:     09:00 - 17:00
:hotel:           \[ADD ROOM\]
:writing_hand:    [rstd.io/conf](http://rstd.io/conf)

-----

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
