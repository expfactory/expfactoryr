#' Process expfactory experiment JSON data.
#'
#' Process expfactory experiment JSON data.
#' @param path Path to data file
#' @keywords expfactory
#' @export
#' @return Data frame (long format)
process_expfactory_experiment <- function(path) {
  if ( file.exists(path) ) {
    # POSTed data gets JSON encoded at the remote, so if it's JSON to start,
    # with it's DOUBLE JSON when written and needs decoding twice
    l <- jsonlite::read_json(path, simplifyVector = TRUE)
    jsonlite::fromJSON(unlist(l[1]))
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
#' @param unflatten=FALSE Unflatten "flat" JSON
#' @keywords expfactory
#' @export
#' @return Data frame (long format)
process_expfactory_survey <- function(token, survey, flat = FALSE) {
  if ( file.exists(survey) ) {
    json <- jsonlite::read_json(survey, simplifyVector = TRUE)
    if (! flat) {
      df <- json
    } else {
      # "flattened" JSON to data frame
      # https://github.com/expfactory/expfactory/issues/76
      df <- stack(unlist(json)) %>%
        rename(value = values) %>%
        mutate(q = gsub("data\\[(\\d+)\\]\\[.*?\\]$", '\\1', ind),
               key = gsub("data\\[\\d+\\]\\[(.*?)\\]$", '\\1', ind)) %>%
        select(-ind) %>%
        filter(key %in% c('name','text','value')) %>%
        spread(key = key, value = value) %>%
        select(-q)
    }

    df %>%
      mutate(
        Token = token,
        qnum = as.numeric(gsub(".*(\\d+).*$", '\\1', name)) - 1,
        question = text,
        survey = survey) %>%
      select(survey, value, Token, question)
  } else {   # FIXME: handle missing data files
    message(survey, ': file not found')
  }
}
