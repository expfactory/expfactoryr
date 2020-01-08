context('The Experiment Factory')

# experiments
test_that("process_expfactory_experiment() returns a data frame", {
  expect_is(process_expfactory_experiment(path = '../fixtures/attention-network-task-no-feedback-results.json'), 'data.frame')
})

test_that("process_expfactory_experiment() returns a data frame for locally saved JSON", {
  expect_is(process_expfactory_experiment(
      path = '../fixtures/outcome-response-priming-task-results-local.json',
      local = TRUE),
    'data.frame')
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

df <- df %>% mutate(value = as.integer(value))
rows <- c(5,8,9,10)
reversed <- reverse_code_survey(df, rows, 5)
test_that('reverse_code_survey() returns a data frame', {
  expect_is(reversed, 'data.frame')
})
test_that('reverse_code_survey() reverse codes items', {
  expect_equal(reversed[5,2], 3)  # 3 -> 3
  expect_equal(reversed[8,2], 2)  # 4 -> 2
  expect_equal(reversed[9,2], 1)  # 5 -> 1
  expect_equal(reversed[10,2], 3) # 3 -> 3
})
