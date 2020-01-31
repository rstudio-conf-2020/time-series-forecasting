library(fpp3)


# Lab Session 1

download.file("http://robjhyndman.com/data/tourism.xlsx", tourism_file <- tempfile())
my_tourism <- readxl::read_excel(tourism_file) %>%
  mutate(Quarter = yearquarter(Quarter)) %>%
  as_tsibble(
    index = Quarter,
    key = c(Region, State, Purpose)
  )

my_tourism %>%
  as_tibble() %>%
  group_by(Region, Purpose) %>%
  summarise(Trips = mean(Trips)) %>%
  ungroup() %>%
  filter(Trips == max(Trips))

state_tourism <- my_tourism %>%
  group_by(State) %>%
  summarise(Trips = sum(Trips)) %>%
  ungroup()


# Lab Session 2

aus_production %>% autoplot(Bricks)

pelt %>% autoplot(Lynx)

gafa_stock %>%
  autoplot(Close)

vic_elec %>%
  autoplot(Demand) +
  labs(y = "Demand (MW)",
       title = "Half-hourly electricity demand",
       subtitle = "Victoria, Australia")


# Lab Session 3

snowy <- tourism %>%
  filter(Region == "Snowy Mountains") %>%
  select(-State, -Region)
snowy %>% autoplot(Trips)
snowy %>% gg_season(Trips)
snowy %>% gg_subseries(Trips)

# Produce a calendar plot for the `pedestrian` data from one location and one year.
library(sugrrants)
(tsibble::pedestrian %>%
  filter(year(Date) == 2016, Sensor == "Southern Cross Station") %>%
  frame_calendar(x = Time, y = Count, date = Date) %>%
  ggplot(aes(x = .Time, y = .Count, group = Date)) +
  geom_line()) %>%
  prettify()


# Lab Session 4

aus_production %>% gg_lag(Bricks)
aus_production %>% ACF(Bricks) %>% autoplot()

pelt %>% gg_lag(Lynx)
pelt %>% ACF(Lynx) %>% autoplot()

amzn_stock <- gafa_stock %>%
  filter(Symbol == "AMZN") %>%
  mutate(trading_day = row_number()) %>%
  update_tsibble(index=trading_day, regular=TRUE)
amzn_stock %>% gg_lag(Close)
amzn_stock %>% ACF(Close) %>% autoplot()

vic_elec %>% gg_lag(Demand, period = 1, lags = c(1, 2, 24, 48, 336, 17532))
vic_elec %>% ACF(Demand, lag_max = 336) %>% autoplot()


# Lab Session 5

dgoog <- gafa_stock %>%
  filter(Symbol == "GOOG", year(Date) >= 2018) %>%
  mutate(trading_day = row_number()) %>%
  update_tsibble(index=trading_day, regular=TRUE) %>%
  mutate(diff = difference(Close))

dgoog %>% autoplot(diff)
dgoog %>% ACF(diff) %>% autoplot()


# Lab Session 6

global_economy %>%
  autoplot(GDP/Population, alpha = 0.3) +
  guides(colour = FALSE)

avg_gdp_pc <- global_economy %>%
  as_tibble() %>%
  group_by(Country) %>%
  summarise(
    # Average GDP per capita for each country
    gdp_pc = mean(GDP/Population, na.rm = TRUE),
    # Most recent GDP per capita for each country
    last = last((GDP/Population)[!is.na(GDP/Population)])
  )
top_n(avg_gdp_pc, 5, gdp_pc)

max_gdp_pc <- global_economy %>%
  semi_join(
    avg_gdp_pc %>%
      filter(gdp_pc == max(gdp_pc, na.rm = TRUE)),
    by = "Country"
  )

# install.packages("ggrepel")
# Using goem_label_repel() gives nicer label positions than geom_label()
# If the ggrepel package is not available, you can use geom_label() instead
library(ggrepel)
global_economy %>%
  ggplot(aes(x = Year, y = GDP / Population, group = Country)) +
  geom_line(alpha = 0.3) +
  geom_line(colour = "red", data = max_gdp_pc) +
  geom_label_repel(
    aes(label = Country, x = 2020, y = last),
    data = top_n(avg_gdp_pc, 5, last),
  )

holidays <- tourism %>%
  filter(Purpose == "Holiday") %>%
  group_by(State) %>%
  summarise(Trips = sum(Trips))

holidays %>%
  model(stl = STL(Trips ~ season(window = 13) + trend(window = 21))) %>%
  components() %>%
  autoplot()


# Lab Session 7

global_economy %>%
  filter(Code == "USA") %>%
  autoplot(box_cox(GDP, 0.3))

aus_livestock %>%
  filter(
    State == "Victoria",
    Animal == "Bulls, bullocks and steers"
  ) %>%
  autoplot(log(Count))

vic_elec %>%
  autoplot(log(Demand))

aus_production %>%
  autoplot(box_cox(Gas, 0.1))

canadian_gas %>% autoplot()


# Lab Session 8

canadian_gas %>%
  model(STL(Volume ~ season(window=7) + trend(window=11))) %>%
  components() %>%
  autoplot()

## Changing the size of the windows changes the trend and seasonal components
## A smaller window gives a more flexible (fast changing) component
## A longer window gives a smoother (slow changing) component

canadian_gas %>%
  model(STL(Volume ~ season(window=7) + trend(window=11))) %>%
  components() %>%
  gg_season(season_year)

  canadian_gas %>%
    model(STL(Volume ~ season(window=7) + trend(window=11))) %>%
    components() %>%
    select(Month, season_adjust) %>%
    autoplot(season_adjust)


# Lab Session 9

library(GGally)
tourism %>%
  features(Trips, feat_stl) %>%
  select(-Region, -State, -Purpose) %>%
  mutate(
    seasonal_peak_year = factor(seasonal_peak_year),
    seasonal_trough_year = factor(seasonal_trough_year),
  ) %>%
  ggpairs()

tourism %>%
  group_by(State) %>%
  summarise(Trips = sum(Trips)) %>%
  features(Trips, feat_stl) %>%
  select(State, seasonal_peak_year)


# Lab Session 10

## Two series have all zeros, so we will drop these to avoid problems in the later calculations
PBS_no_zeros <- PBS %>%
  group_by_key() %>%
  filter(!all(Cost == 0)) %>%
  ungroup()

library(broom)

## Compute features
PBS_feat <- PBS_no_zeros %>%
  features(Cost, feature_set(pkgs = "feasts"))

## Compute principal components
PBS_prcomp <- PBS_feat %>%
  select(-Concession, -Type, -ATC1, -ATC2) %>%
  prcomp(scale = TRUE) %>%
  augment(PBS_feat)

## Plot the first two components
PBS_prcomp %>%
  ggplot(aes(x = .fittedPC1, y = .fittedPC2)) +
  geom_point()

## Pull out most unusual series from first principal component
outliers <- PBS_prcomp %>%
  filter(.fittedPC1 == max(.fittedPC1))
outliers

## Visualise the unusual series
PBS %>%
  semi_join(outliers, by = c("Concession", "Type", "ATC1", "ATC2")) %>%
  autoplot(Cost) +
  facet_grid(vars(Concession, Type, ATC1, ATC2)) +
  ggtitle("Outlying time series in PC space")


# Lab Session 11

hh_budget %>% autoplot(Wealth)

hh_budget %>%
  model(drift = RW(Wealth ~ drift())) %>%
  forecast(h = "5 years") %>%
  autoplot(hh_budget)

aus_takeaway <- aus_retail %>%
  filter(Industry == "Cafes, restaurants and takeaway food services") %>%
  summarise(Turnover = sum(Turnover))

aus_takeaway %>% autoplot(Turnover)

aus_takeaway %>%
  model(snaive = SNAIVE(log(Turnover) ~ drift())) %>%
  forecast(h = "3 years") %>%
  autoplot(aus_takeaway)


# Lab Session 12

beer_model <- aus_production %>%
  model(snaive = SNAIVE(Beer))

beer_model %>%
  forecast(h = "3 years") %>%
  autoplot(aus_production)

beer_model %>% gg_tsresiduals()

augment(beer_model) %>%
  features(.resid, ljung_box, lag = 8, dof = 0)


# Lab Session 13

hh_budget_train <- hh_budget %>%
  filter(Year <= max(Year) - 4)

hh_budget_forecast <- hh_budget_train %>%
  model(
    mean = MEAN(Wealth),
    naive = NAIVE(Wealth),
    drift = RW(Wealth ~ drift())
  ) %>%
  forecast(h = "4 years")

hh_budget_forecast %>%
  autoplot(hh_budget, level=NULL)

hh_budget_forecast %>%
  accuracy(hh_budget) %>%
  group_by(.model) %>%
  summarise_if(is.numeric, mean)

aus_takeaway_train <- aus_takeaway %>%
  filter(year(Month) <= max(year(Month)) - 4)

aus_takeaway_forecast <- aus_takeaway_train %>%
  model(
    mean = MEAN(Turnover),
    naive = NAIVE(Turnover),
    drift = RW(Turnover ~ drift()),
    snaive = SNAIVE(Turnover)
  ) %>%
  forecast(h = "4 years")

aus_takeaway_forecast %>%
  accuracy(aus_takeaway)


# Lab Session 14

global_economy %>%
  filter(Country == "China") %>%
  autoplot(box_cox(GDP, 0.2))

global_economy %>%
  filter(Country == "China") %>%
  features(GDP, guerrero)

fit <- global_economy %>%
  filter(Country == "China") %>%
  model(
    ets = ETS(GDP),
    ets_damped = ETS(GDP ~ trend("Ad")),
    ets_bc = ETS(box_cox(GDP, 0.2)),
    ets_log = ETS(log(GDP))
  )

fit

report(fit)
fit %>% select(ets) %>% report()

glance(fit)
tidy(fit)
coef(fit)

fit %>%
  forecast(h = "20 years") %>%
  autoplot(global_economy, level = NULL)


# Lab Session 15

gas <- aus_production %>%
  select(Gas) %>%
  filter(Quarter <= yearquarter("2006 Q4"))

autoplot(gas)

fit <- gas %>%
  model(
    auto = ETS(Gas),
    damped = ETS(Gas ~ trend("Ad")),
    log = ETS(log(Gas)),
    snaive = SNAIVE(Gas)
  )

fit

fc <- fit %>%
  forecast(h = "4 years")

fc %>%
  autoplot(aus_production, level=NULL)

fc %>%
  autoplot(
    filter(aus_production,
           Quarter > yearquarter("2000 Q4")),
           level=NULL)

fc %>%
  accuracy(aus_production)


# Lab Session 16

us_gdp <- global_economy %>%
  filter(Code == "USA")

autoplot(us_gdp, log(GDP))

us_gdp_model <- us_gdp %>%
  model(
    arima_notransform = ARIMA(GDP),
    arima = ARIMA(log(GDP)),
    arima1= ARIMA(log(GDP) ~ pdq(d=1)),
  )
us_gdp_model
glance(us_gdp_model)

us_gdp_model %>%
  forecast(h = "10 years") %>%
  autoplot(us_gdp, level=NULL)

us_gdp_model %>%
  select(Country,arima_notransform) %>%
  forecast(h = "10 years") %>%
  autoplot(us_gdp)


# Lab Session 17

tourism_models <- tourism %>%
  filter(Purpose=="Holiday") %>%
  model(arima = ARIMA(Trips))

tourism_fc <- forecast(tourism_models)
tourism_fc

tourism_fc %>%
  filter(Region == "Snowy Mountains") %>%
  autoplot(tourism)

tourism_fc %>%
  filter(Region == "Melbourne") %>%
  autoplot(tourism)


# Lab Session 18

vic_elec_daily <- vic_elec %>%
  filter(year(Time) == 2014) %>%
  index_by(Date = date(Time)) %>%
  summarise(
    Demand = sum(Demand)/1e3,
    Temperature = max(Temperature),
    Holiday = any(Holiday)) %>%
  mutate(
    Day_Type = case_when(
      Holiday ~ "Holiday",
      wday(Date) %in% 2:6 ~ "Weekday",
      TRUE ~ "Weekend")
  )

elec_model <- vic_elec_daily %>%
  model(fit = ARIMA(Demand ~ Temperature +
                      I(pmax(Temperature-22,0)) +
                      (Day_Type=="Weekday")))
report(elec_model)

elec_model %>% gg_tsresiduals()

augment(elec_model) %>%
  features(.resid, ljung_box, dof = 9, lag = 14)

vic_next_day <- new_data(vic_elec_daily, 1) %>%
  mutate(Temperature = 26, Day_Type = "Holiday")
forecast(elec_model, vic_next_day)

vic_elec_future <- new_data(vic_elec_daily, 14) %>%
  mutate(
    Temperature = 26,
    Holiday = c(TRUE, rep(FALSE, 13)),
    Day_Type = case_when(
      Holiday ~ "Holiday",
      wday(Date) %in% 2:6 ~ "Weekday",
      TRUE ~ "Weekend"
    )
  )

forecast(elec_model, vic_elec_future) %>%
  autoplot(vic_elec_daily) + ylab("Electricity demand (GW)")


# Lab Session 19

vic_elec_daily <- vic_elec %>%
  index_by(Date = date(Time)) %>%
  summarise(
    Demand = sum(Demand)/1e3,
    Temperature = max(Temperature),
    Holiday = any(Holiday)) %>%
  mutate(
    Day_Type = case_when(
      Holiday ~ "Holiday",
      wday(Date) %in% 2:6 ~ "Weekday",
      TRUE ~ "Weekend")
  )

elec_model <- vic_elec_daily %>%
  model(fit = ARIMA(Demand ~
                      fourier("year", K = 10) +
                      PDQ(0,0,0) +
                      Temperature +
                      lag(Temperature) +
                      I(pmax(Temperature-20,0)) +
                      (Day_Type=="Weekday")))
report(elec_model)

augment(elec_model) %>%
  gg_tsdisplay(.resid, plot_type = "histogram")

augment(elec_model) %>%
  features(.resid, ljung_box, dof = 9, lag = 14)

vic_next_day <- new_data(vic_elec_daily, 1) %>%
  mutate(Temperature = 26, Day_Type = "Holiday")
forecast(elec_model, vic_next_day)

vic_elec_future <- new_data(vic_elec_daily, 14) %>%
  mutate(
    Temperature = 26,
    Holiday = c(TRUE, rep(FALSE, 13)),
    Day_Type = case_when(
      Holiday ~ "Holiday",
      wday(Date) %in% 2:6 ~ "Weekday",
      TRUE ~ "Weekend"
    )
  )

forecast(elec_model, vic_elec_future) %>%
  autoplot(filter(vic_elec_daily, year(Date) > 2013)) +
  ylab("Electricity demand (GW)")


# Lab Session 20

PBS_aggregated <- PBS %>%
  aggregate_key(
    Concession * Type * ATC1,
    Cost = sum(Cost) / 1e6
  )
fit <- PBS_aggregated %>%
  filter(Month <= yearmonth("2005 Jun")) %>%
  model(
    ets = ETS(Cost),
    arima = ARIMA(Cost),
    snaive = SNAIVE(Cost)
  )
fc <- fit %>%
  reconcile(
    ets_adj = min_trace(ets),
    arima_adj = min_trace(arima),
    snaive_adj = min_trace(snaive)
  ) %>%
  forecast(h = "3 years")
accuracy(fc, PBS_aggregated) %>%
  group_by(.model) %>%
  summarise(MASE = mean(MASE)) %>%
  arrange(MASE)
