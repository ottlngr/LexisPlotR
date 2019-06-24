#' Emphasize a survey range in a Lexis grid

#' Takes an existing Lexis grid and adds a coloured parallelogram to highlight a survey range.
#' 
#' @param lg, an existing object originally created with \code{lexis.grid()}.
#' @param fill character, set the colour to fill the parallelogram. Default is \code{"orange"}.
#' @param alpha numeric, set the transparency of the fill colour. Default is \code{0.5}.
#' @details The function can be used to plot the time and age range of a survey. Use \code{from_date} and \code{to_date} to specify the time range the survey took place and \code{from_age} and \code{to_age} to define the considered ages of participants/observations.
#' @author Philipp Ottolinger
#' @import ggplot2
#' @export lexis_polygon
#' @examples
#' \dontrun{
#' library(LexisPlotR)
#' lg <- lexis.grid(year.start = 1980, year.end = 1990, age.start = 30, age.end = 40)
#' lexis.survey(lg, from_date = "1982-09-01", to_date = "1986-03-01", from_age = 32, to_age = 36)
#' }


lexis_polygon <- function(lg, x, y, group = 1, fill = lexisplotr_colours()[6], alpha = 0.7) {
  
  x <- as.Date(x, origin = "1970-01-01")
  data <- data.frame(group, x, y)
  
  lg <- lg + geom_polygon(data = data, aes(x = x, y = y, group = group), fill = fill, alpha = alpha)
  return(lg)
}

a <- c("1901-01-01", "1902-01-01", "1902-01-01")
c <- c("1903-01-01", "1904-01-01", "1904-01-01")
b <- c(1,1,2)

ddd <- data.frame(x = c(a,c), y = c(b,b), group = c(1,1,1,2,2,2))
