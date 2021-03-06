#' Reverse code expfactory survey values
#'
#' Reverse code expfactory survey values.
#' @param df data frame containing (long) data for one survey
#' @param rows integer vector containing row numbers of scores to be reverse coded
#' @param max integer value of highest possible score
#' @importFrom magrittr %<>%
#' @export
#' @return data frame
reverse_code_survey <- function(df, rows, max) {
  df[rows,] %<>% mutate(value = max + 1 - .data$value)
  df
}

#' Process expfactory experiment JSON data.
#'
#' Most tasks in \href{https://expfactory.github.io/experiments/}{The Experiment Factory library} save their data as JSON.
#' This function parses JSON data generated by a task. Note that The Experiment Factory Docker container
#' also JSON encodes task data, so if the task encodes its data as JSON, use \code{local=FALSE} (the default)
#' to double-decode your data. Use \code{local=TRUE} for single-encoded JSON e.g. when saving task data locally.
#' @param path Path to data file
#' @param local TRUE means locally saved JSON (default=FALSE)
#' @keywords expfactory
#' @export
#' @return Data frame (long format)
process_expfactory_experiment <- function(path, local=FALSE) {
  if ( file.exists(path) ) {
    if (! local) {
      # POSTed data gets JSON encoded at the remote, so if it's JSON to start,
      # with it's DOUBLE JSON when written and needs decoding twice
      l <- read_json(path, simplifyVector = TRUE)
      fromJSON(unlist(l[1]))
    } else {
      fromJSON(path)
    }
  } else {
    message(path, ': file not found')
    return(data.frame)
  }
}

#' Process expfactory survey data
#'
#' Process expfactory survey data.
#' @param token token number
#' @param survey path to JSON survey file
#' @param flat TRUE means unflatten "flat" JSON (default=FALSE)
#' @keywords expfactory
#' @importFrom dplyr filter mutate rename select
#' @importFrom jsonlite fromJSON read_json
#' @importFrom magrittr %>%
#' @importFrom rlang .data
#' @importFrom tidyr spread
#' @importFrom utils stack
#' @export
#' @return Data frame (long format)
process_expfactory_survey <- function(token, survey, flat = FALSE) {
  if ( file.exists(survey) ) {
    json <- read_json(survey, simplifyVector = TRUE)
    if (! flat) {
      df <- json
    } else {
      # "flattened" JSON to data frame
      # https://github.com/expfactory/expfactory/issues/76
      df <- stack(unlist(json)) %>%
        rename(value = .data$values) %>%
        mutate(q = gsub("data\\[(\\d+)\\]\\[.*?\\]$", '\\1', .data$ind),
               key = gsub("data\\[\\d+\\]\\[(.*?)\\]$", '\\1', .data$ind)) %>%
        select(-.data$ind) %>%
        filter(.data$key %in% c('name','text','value')) %>%
        spread(key = .data$key, value = .data$value) %>%
        select(-.data$q)
    }

    df %>%
      mutate(
        Token = token,
        qnum = as.numeric(gsub(".*(\\d+).*$", '\\1', .data$name)) - 1,
        question = .data$text,
        survey = survey) %>%
      select(.data$survey, .data$value, .data$Token, .data$question)
  } else {   # FIXME: handle missing data files
    message(survey, ': file not found')
  }
}
