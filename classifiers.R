votes <- read_rds(str_c(getwd(), "/UNVotes.rds"))
votes

# Number of resolution votes per year
votes %>%
  group_by(year, unres) %>%
  slice(1) %>%
  ungroup() %>%
  count(year) %>%
  ggplot(aes(year, n)) +
  geom_line() +
  labs(x = "Year", y = "Number of resolutions up for voting per year")

votes <- votes %>%
  mutate(country = str_replace(country, "Federal Republic of Germany", "Germany")) %>%
  mutate(country = str_replace(country, "United States of America", "USA")) %>%
  mutate(country = str_replace(country, "United Kingdom of Great Britain and Northern Ireland","UK"))

y <- votes %>%
  filter(country %in% c("Germany", "USA")) %>%
  select(rcid, country, year, vote) %>%
  spread(country, vote) %>%
  group_by(year) %>%
  summarize(agreement = mean(Germany == USA, na.rm = T),
            num_resolutions = n())
y %>%
  ggplot(aes(year, agreement)) +
  geom_path() +
  geom_point(aes(size = num_resolutions)) +
  geom_smooth(span = 1/3)

# Task 5
lm_fit <- y %>% lm(agreement ~ year, dat = .)
library(broom)
tidy(lm_fit)
summary(lm_fit)

# Number of resolution votes
length(unique(votes$rcid))

# Countries that have taken part in at least 70% of all votes
countries <- votes %>%
  group_by(country) %>%
  summarize(p = n()/num_votes) %>%
  filter(p >= 0.7) %>%
  .$country

countries

# Create voting country matrix
# (rows correspond to votes, columns countries, values vote of the
# respective country at the respective vote)
tmp <- votes %>%
  filter(country %in% countries) %>%
  select(rcid, country, vote) %>%
  spread(country, vote)

X <- as.matrix(tmp[,-1])
rownames(X) <- tmp$rcid
d <- dist(t(X))
dist_from_de <- as.matrix(d)["Germany",]

library(ggrepel)
dist_from_de_tibble <- tibble(country = names(dist_from_de),
                              dist = dist_from_de) %>%
  filter(country != "Germany") %>%
  arrange(dist)

# 5 countries with the smallest distance to Germany
dist_from_de_tibble %>%
  slice(1:5)

# 5 countries with the greatest distance to Germany
dist_from_de_tibble %>%
  arrange(-dist) %>%
  slice(1:5)

dist_from_de_tibble %>%
  ggplot(aes(x = seq_along(dist), y = dist, label = country)) +
  geom_point() +
  geom_text_repel(size = 2)

heatmap(as.matrix(d))

# Task 6
countries <- c("Germany", "Italy", "Netherlands", "USA", "Israel", "Cuba", "India")

# Filter only polls of countries in 'countries
# Create binary target variable -> German Yes (1) vs. German No (0)
dat <- votes %>%
  filter(country %in% countries) %>%
  select(rcid, country, vote) %>%
  spread(country, vote, fill = 2) %>%
  rename(y = Germany) %>%
  filter(y != 2) %>%
  select(-rcid) %>%
  mutate(y = ifelse(y == 1, 1, 0))

library(caret)
# Create training and test sets
set.seed(123)
trainIndex <- sample(c(FALSE,TRUE), size = nrow(dat), prob = c(.25,.75), replace = TRUE)
train_set <- dat[trainIndex, ]
test_set <- dat[!trainIndex, ]
# Learn Logistic Regression Model
fit <- glm(y ~ ., data = train_set, family = "binomial")
pred <- predict(fit, newdata = test_set, type = "response")
tab <- table(actual = test_set$y, predicted = round(pred))
cm1 <- confusionMatrix(tab)
cm1

# Learn KNN classifier
fit <- knn3Train(train_set %>% select(-y), test_set %>% select(-y), cl = train_set$y,
                 k = 3, prob = F)

tab <- table(actual = as.character(test_set$y), predicted = fit)
cm2 <- confusionMatrix(tab)
cm2

# Difference with regard to accuracy between log. Regression and KNN
cm2$overall["Accuracy"] - cm1$overall["Accuracy"]
