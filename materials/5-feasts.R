library(fpp3)
library(glue)

tourism %>% features(Trips, feat_stl)

tourism %>%
  features(Trips, feat_stl) %>%
  ggplot(aes(x = trend_strength, y = seasonal_strength_year, col = Purpose)) +
  geom_point() + facet_wrap(vars(State))

most_seasonal <- tourism %>%
  features(Trips, feat_stl) %>%
  filter(seasonal_strength_year == max(seasonal_strength_year))

tourism %>%
  right_join(most_seasonal, by = c("State", "Region", "Purpose")) %>%
  ggplot(aes(x = Quarter, y = Trips)) + geom_line() +
  facet_grid(vars(State, Region, Purpose))

most_trended <- tourism %>%
  features(Trips, feat_stl) %>%
  filter(trend_strength == max(trend_strength))

tourism %>%
  right_join(most_trended, by = c("State", "Region", "Purpose")) %>%
  ggplot(aes(x = Quarter, y = Trips)) + geom_line() +
  facet_grid(vars(State, Region, Purpose))

tourism %>% features(Trips, feat_acf)

tourism_features <- tourism %>%
  features(Trips, feature_set(pkgs = "feasts"))

pcs <- tourism_features %>%
  select(-State, -Region, -Purpose) %>%
  prcomp(scale = TRUE) %>%
  broom::augment(tourism_features)

pcs %>% ggplot(aes(x = .fittedPC1, y = .fittedPC2)) +
  geom_point() + theme(aspect.ratio = 1)

pcs %>% ggplot(aes(x = .fittedPC1, y = .fittedPC2, col = State)) +
  geom_point() + theme(aspect.ratio = 1)

pcs %>% ggplot(aes(x = .fittedPC1, y = .fittedPC2, col = Purpose)) +
  geom_point() + theme(aspect.ratio = 1)

outliers <- pcs %>%
  filter(.fittedPC1 > 12 | (.fittedPC1 > 10 & .fittedPC2 > 0))

pcs %>% ggplot(aes(x = .fittedPC1, y = .fittedPC2, col = Purpose)) +
  geom_point() + theme(aspect.ratio = 1) +
  geom_point(data = outliers, aes(x = .fittedPC1, y = .fittedPC2), col = "black", shape = 1, size = 3)

tourism_features

library(glue)
outliers %>%
  left_join(tourism, by = c("State", "Region", "Purpose")) %>%
  mutate(Series = glue("{State}", "{Region}", "{Purpose}", .sep = "\n\n")) %>%
  ggplot(aes(x = Quarter, y = Trips)) + geom_line() +
  facet_grid(Series ~ .) + ggtitle("Outlying time series in PC space")

