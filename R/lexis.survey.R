lexis.survey <- function(lg, from_date, to_date, from_age, to_age, fill = "grey", alpha = 0.5) {
  from_date <- as.Date(from_date, origin = "1970-01-01")
  to_date <- as.Date(to_date, origin = "1970-01-01")
  #print(to_date)
  #print(to_date + years(to_age - from_age))
  
  x1 <- from_date
  x2 <- to_date
  x3 <- to_date
  x4 <- from_date
  #print(c(x1,x2,x3,x4))
  
  y1 <- from_age
  y2 <- as.numeric(from_age + as.numeric(((to_date - from_date)/365)), origin = "1970-01-01")
  y3 <- to_age + as.numeric(((to_date - from_date)/365))
  y4 <- to_age
  
  df <- data.frame(x = c(x1,x2,x3,x4),
                   y = c(y1,y2,y3,y4))
  df$x <- as.Date(df$x, origin = "1970-01-01")
  
  print(df)
  lg <- lg + 
    geom_polygon(data = df, aes(x, y), fill = fill, alpha = alpha)
  return(lg)
}