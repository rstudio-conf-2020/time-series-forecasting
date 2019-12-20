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

state_tourism <- mytourism %>%
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

holidays <- tourism %>%
  filter(Purpose == "Holiday") %>%
  group_by(State) %>%
  summarise(Trips = sum(Trips))

# Lab Session 6

global_economy %>% 
  autoplot(GDP/Population, alpha = 0.3)

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

library(ggrepel)
global_economy %>% 
  ggplot(aes(x = Year, y = GDP / Population, group = Country)) + 
  geom_line(alpha = 0.3) + 
  geom_line(colour = "red", data = max_gdp_pc) + 
  geom_label_repel(
    aes(label = Country, x = 2020, y = last), 
    data = top_n(avg_gdp_pc, 5, last),
  )

holidays %>%
  STL(Trips ~ season(window = 13) + trend(window = 21)) %>%
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
  
aus_production %>% 
  autoplot(box_cox(Gas, 0.1))

aus_production %>% 
  autoplot(Tobacco)

ansett %>% 
  filter(
    Class == "Economy",
    Airports == "MEL-SYD"
  ) %>% 
  autoplot(Passengers)

vic_elec %>% 
  autoplot(Demand)

# Lab Session 8
as_tsibble(expsmooth::cangas) %>%
  STL(value ~ season(window=7) + trend(window=11)) %>%
  autoplot()

## Changing the size of the windows changes the trend and seasonal components
## A smaller window gives a more flexible (fast changing) component
## A longer window gives a smoother (slow changing) component

as_tsibble(expsmooth::cangas) %>%
  STL(value ~ season(window=7) + trend(window=11)) %>% 
  gg_season(season_year)

as_tsibble(expsmooth::cangas) %>%
  STL(value ~ season(window=7) + trend(window=11)) %>% 
  select(index, season_adjust) %>% 
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
PBSnozeros <- PBS %>%
  filter(!(Concession == "General" & Type == "Co-payments" & (ATC2 %in% c("R", "S"))))

library(broom)
pbsfeat <- PBSnozeros %>%
  features(Cost, feature_set(pkgs = "feasts"))
pbspc <- pbsfeat %>%
  select(-Concession, -Type, -ATC1, -ATC2) %>%
  prcomp(scale = TRUE) %>%
  augment(pbsfeat)
pbspc %>%
  ggplot(aes(x = .fittedPC1, y = .fittedPC2)) +
  geom_point()

outliers <- filter(pbspc, .fittedPC1 == max(.fittedPC1))
outliers
outliers %>%
  left_join(PBS) %>%
  as_tsibble(index = Month) %>%
  autoplot(Cost) +
  facet_grid(vars(Concession, Type, ATC1, ATC2)) +
  ggtitle("Outlying time series in PC space")


# Lab Session 7

aus_production %>% autoplot(Gas)
fit <- aus_production %>%
  filter(Quarter > yearquarter("1990 Q4")) %>%
  model(fit = ETS(Gas))
report(fit)
fit %>%
  forecast(h = "3 years") %>%
  autoplot(aus_production)


# Lab Session 8

usgdp <- global_economy %>%
  filter(Code == "USA")
autoplot(usgdp, log(GDP))
fit <- usgdp %>%
  model(
    arima = ARIMA(log(GDP)),
    ets = ETS(GDP),
  )
fit
forecast(fit)
fit %>%
  forecast(h = "10 years") %>%
  autoplot(usgdp)


# Lab Session 9

fit <- tourism %>%
  model(arima = ARIMA(Trips))
fit
fc <- forecast(fit)
fc
fc %>%
  filter(Region == "Snowy Mountains") %>%
  autoplot(tourism)
fc %>%
  filter(Region == "Melbourne") %>%
  autoplot(tourism)


# Lab Session 10

mypbs <- PBS %>%
  aggregate_key(Concession * Type * ATC1,
    Cost = sum(Cost) / 1e6
  )
fit <- mypbs %>%
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
accuracy(fc, mypbs) %>%
  group_by(.model) %>%
  summarise(mase = mean(MASE)) %>%
  arrange(mase)
