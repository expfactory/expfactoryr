library(tidyverse)
library(testthat)
context('The Experiment Factory')

# experiments
test_that("process_expfactory_experiment() returns a data frame", {
  expect_is(process_expfactory_experiment(path = '../fixtures/attention-network-task-no-feedback-results.json'), 'data.frame')
})

# surveys
df <- process_expfactory_survey(token='1', survey='../fixtures/sms.json') %>%
  mutate(p = 1)
test_that("process_expfactory_survey() returns a data frame", {
   expect_is(df, 'data.frame')
})
test_that('SMS structured JSON correctly parsed', {
  expect_equal(df[1,4], 'I was aware of different emotions that arose in me')
})

df <- process_expfactory_survey(token='1', survey='../fixtures/sms-flat.json', flat=TRUE)
test_that("process_expfactory_survey() can process flat JSON", {
  expect_is(df, 'data.frame')
})
test_that('SMS flat JSON correctly parsed', {
  expect_equal(df[1,4], 'I was aware of different emotions that arose in me')
})


