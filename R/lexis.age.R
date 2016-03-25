lexis.age <- function(lg, age, fill = "yellow", alpha = 0.5) {
  age <- as.numeric(age)
  year.start <- as.Date(ggplot_build(lg)$data[[1]][1,1], origin="1970-01-01")
  year.end <- as.Date(tail(ggplot_build(lg)$data[[1]]$xend,1), origin = "1970-01-01")
  age.start <- ggplot_build(lg)$data[[1]][1,3]
  age.end <- tail(ggplot_build(lg)$data[[1]]$yend,1)
  if (age > age.end) { stop("Out of bounds.") }
  if (age < age.start) { stop("Out of bounds.") }
  df <- data.frame(x = c(year.start, year.end, year.end, year.start),
                   y = c(age, age, age+1, age+1))
  lg <- lg + geom_polygon(data = df, aes(x,y), fill = fill, alpha = alpha, colour = NA)
  return(lg)
}