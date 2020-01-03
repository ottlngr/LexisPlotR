#' Deprecated. Emphasize a survey range in a Lexis grid

#' Takes an existing Lexis grid and adds a coloured parallelogram to highlight a survey range.
#' 
#' @param lg, an existing object originally created with \code{lexis.grid()}.
#' @param from_date character, set the beginning of the survey in format \code{"YYYY-MM-DD"}.
#' @param to_date character, set the end of the survey in format \code{"YYYY-MM-DD"}.
#' @param from_age numeric, set the starting age of the survey.
#' @param to_age numeric, set the ending age of the survey. 
#' @param fill character, set the colour to fill the parallelogram. Default is \code{"orange"}.
#' @param alpha numeric, set the transparency of the fill colour. Default is \code{0.5}.
#' @details The function can be used to plot the time and age range of a survey. Use \code{from_date} and \code{to_date} to specify the time range the survey took place and \code{from_age} and \code{to_age} to define the considered ages of participants/observations.
#' @author Philipp Ottolinger
#' @import ggplot2
#' @export lexis.survey
#' @examples
#' \dontrun{
#' library(LexisPlotR)
#' lg <- lexis.grid(year.start = 1980, year.end = 1990, age.start = 30, age.end = 40)
#' lexis.survey(lg, from_date = "1982-09-01", to_date = "1986-03-01", from_age = 32, to_age = 36)
#' }
  

lexis.survey <- function(lg, from_date, to_date, from_age, to_age, fill = lpr_colours()[6], alpha = 0.7) {
  .Deprecated("lexis_polygon")
  from_date <- as.Date(from_date, origin = "1970-01-01")
  to_date <- as.Date(to_date, origin = "1970-01-01")
  
  x <- NULL
  y <- NULL
  
  x1 <- from_date
  x2 <- to_date
  x3 <- to_date
  x4 <- from_date
  
  y1 <- from_age
  y2 <- as.numeric(from_age + as.numeric(((to_date - from_date)/365)), origin = "1970-01-01")
  y3 <- to_age + as.numeric(((to_date - from_date)/365))
  y4 <- to_age
  
  df <- data.frame(x = c(x1,x2,x3,x4),
                   y = c(y1,y2,y3,y4))
  df$x <- as.Date(df$x, origin = "1970-01-01")
  
  #print(df)
  lg <- lg + 
    geom_polygon(data = df, aes(x, y), fill = fill, alpha = alpha)
  return(lg)
}