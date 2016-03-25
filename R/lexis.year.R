lexis.year <- function(lg, year, fill = "blue", alpha = 0.5) {
  year.start <- as.Date(ggplot_build(lg)$data[[1]][1,1], origin="1970-01-01")
  year_start <- as.numeric(substr(year.start,1,4))
  year.end <- as.Date(tail(ggplot_build(lg)$data[[1]]$xend,1), origin = "1970-01-01")
  year_end <- as.numeric(substr(year.end,1,4))
  age.start <- ggplot_build(lg)$data[[1]][1,3]
  age.end <- tail(ggplot_build(lg)$data[[1]]$yend,1)
  if (year > year_end - 1) { stop("Out of bounds.") }
  if (year < year_start) { stop("Out of bounds.") }
  year1 <- year + 1
  year <- as.Date(paste(year, "-01-01", sep = ""), origin = "1970-01-01")
  year1 <- as.Date(paste(year1, "-01-01", sep = ""), origin = "1970-01-01")
  df <- data.frame(x = c(year, year1, year1, year),
                   y = c(age.start, age.start, age.end, age.end))
  lg <- lg + geom_polygon(data = df, aes(x,y), fill = fill, alpha = alpha, colour = NA)
  return(lg)
}