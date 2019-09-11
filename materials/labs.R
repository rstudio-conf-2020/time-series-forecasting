library(tidyverse)
library(tsibble)
library(tsibbledata)
library(feasts)
library(fable)


# Lab Session 1

mytourism <- readxl::read_excel("~/Downloads/tourism.xlsx") %>%
  mutate(Quarter = yearquarter(Quarter)) %>%
  as_tsibble(
    index = Quarter,
    key = c(Region, State, Purpose)
  )

mytourism %>%
  as_tibble() %>%
  group_by(Region, Purpose) %>%
  summarise(Trips = mean(Trips)) %>%
  ungroup() %>%
  filter(Trips == max(Trips))

newtourism <- mytourism %>%
  group_by(State) %>%
  summarise(Trips = sum(Trips)) %>%
  ungroup()


# Lab Session 2

aus_production %>% autoplot(Beer)

pelt %>% autoplot(Lynx)

gafa_stock %>%
  autoplot(Close) +
  xlab("Day") + ylab("Closing price")


# Lab Session 3

snowy <- tourism %>%
  filter(Region == "Snowy Mountains") %>%
  select(-State, -Region)
snowy %>% autoplot(Trips)
snowy %>% gg_season(Trips)
snowy %>% gg_subseries(Trips)


# Lab Session 4

holidays <- tourism %>%
  filter(Purpose == "Holiday") %>%
  group_by(State) %>%
  summarise(Trips = sum(Trips))

holidays %>%
  STL(Trips ~ season(window = 13) + trend(window = 21)) %>%
  autoplot()


# Lab Session 5

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


# Lab Session 6

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
