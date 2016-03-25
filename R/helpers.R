how.old <- function(from, to) {
  from <- as.Date(from)
  to <- as.Date(to)
  age <- round(as.numeric(to-from)/365.5, digits = 5)
  #age <- ifelse(age >= 0, age, NA)
  return(age)
}

what.date <- function(born, age) {
  if (!is.numeric(age)) { stop("No numeric age.") }
  born <- as.Date(born)
  date <- born + age*365.25
  return(date)
}