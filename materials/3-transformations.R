library(fpp3)

global_economy %>%
  filter(Country == "Australia") %>%
  autoplot(GDP)

global_economy %>%
  filter(Country == "Australia") %>%
  autoplot(GDP / Population)

print_retail <- aus_retail %>%
  filter(Industry == "Newspaper and book retailing") %>%
  group_by(Industry) %>%
  index_by(Year = year(Month)) %>%
  summarise(Turnover = sum(Turnover))

aus_economy <- filter(global_economy, Code == "AUS")

print_retail %>%
  left_join(aus_economy, by = "Year") %>%
  mutate(Adj_turnover = Turnover / CPI) %>%
  pivot_longer(c(Turnover, Adj_turnover),
    names_to = "Type", values_to = "Turnover"
  ) %>%
  ggplot(aes(x = Year, y = Turnover)) +
  geom_line() +
  facet_grid(vars(Type), scales = "free_y") +
  xlab("Years") + ylab(NULL) +
  ggtitle("Turnover: Australian print media industry")

food <- aus_retail %>%
  filter(Industry == "Food retailing") %>%
  summarise(Turnover = sum(Turnover))
food %>% autoplot(Turnover) +
  labs(y = "Turnover ($AUD)")
food %>% autoplot(sqrt(Turnover)) +
  labs(y = "Square root turnover")
food %>% autoplot(Turnover^(1 / 3)) +
  labs(y = "Cube root turnover")
food %>% autoplot(log(Turnover)) +
  labs(y = "Log turnover")
food %>% autoplot(-1 / Turnover) +
  labs(y = "Inverse turnover")

food %>%
  features(Turnover, features = guerrero)
food %>% autoplot(box_cox(Turnover, 0.0524)) +
  labs(y = "Box-Cox transformed turnover")
