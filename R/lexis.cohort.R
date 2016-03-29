lexis.cohort <- function(lg, cohort, fill = "green", alpha = 0.5) {
  if (!is.ggplot(lg)) { stop("No valid ggplot object.") }
  year.start <- as.Date(ggplot_build(lg)$data[[1]][1,1], origin="1970-01-01")
  year.end <- as.Date(tail(ggplot_build(lg)$data[[1]]$xend,1), origin = "1970-01-01")
  age.start <- ggplot_build(lg)$data[[1]][1,3]
  age.end <- tail(ggplot_build(lg)$data[[1]]$yend,1)
  
  df <- data.frame(x = c(cohort, cohort+1, cohort+1+age.end, cohort + age.end),
                   y = c(0,0,age.end, age.end))
  df$x <- as.Date(paste(df$x, "-01-01", sep = ""), origin = "1970-01-01")
  print(df)
  lg <- lg + geom_polygon(data = df, aes(x,y), fill = fill, alpha = alpha)
  return(lg)
}

