what.date <- function(date, age) {
  .Deprecated("reference_date_plus_age")
  if (!is.numeric(age)) { stop("No numeric age.") }
  date <- as.Date(date)
  date <- date + age*365.25
  return(date)
}

reference_date_plus_age <- function(date, age) {
  date <- as.Date(date)
  date <- date + age*365.25
  return(date)
}

how.old <- function(from, to) {
  .Deprecated("age_from_start_and_end_date")
  from <- as.Date(from)
  to <- as.Date(to)
  age <- round(as.numeric(to-from)/365.25, digits = 5)
  return(age)
}

age_from_start_and_end_date <- function(from, to) {
  from <- as.Date(from)
  to <- as.Date(to)
  age <- round(as.numeric(to-from)/365.25, digits = 5)
  return(age)
}

lpr_colours <- function() {
  .Deprecated("lexisplotr_colours")
  lpr_colours <- c("#999999", "#E69F00", "#56B4E9", "#009E73", "#F0E442", "#0072B2", "#D55E00", "#CC79A7")
  return(lpr_colours)
}

lexisplotr_colours <- function() {
  lexisplotr_colours <- c("#FFFD98", "#BDE4A7", "#B3D2B2", "#9FBBCC", "#7A9CC6")
  return(lexisplotr_colours)
}