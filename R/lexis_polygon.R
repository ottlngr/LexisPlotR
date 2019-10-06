#' Plot a polygon inside a Lexis grid

#' Takes an existing Lexis grid and adds a polygon.
#' 
#' @param lg, an existing object originally created with \code{lexis_grid()}.
#' @param x, vector describing the x coordinates of the polygon. Format: YYYY-MM-DD.
#' @param y, vector describing the y coordinates of the polygon
#' @param group, vector describing the groups of coordinates.
#' @param fill character, fill colour of the polygon.
#' @param alpha numeric, transparency of the fill colour. Default: 0.7.
#' @details The function can be used to plot a polygon inside a Lexis grid. 
#' @author Philipp Ottolinger
#' @import ggplot2
#' @export lexis_polygon
#' @examples
#' \dontrun{
#' library(LexisPlotR)
#' lg <- lexis_grid(year_start = 1900, year_end = 1905, age_start = 0, age_end = 5)
#' lexis_polygon(lg, x = c("1901-06-30", "1904-06-30", "1904-06-30", "1901-06-30"), y = c(2,2,4,4))
#' }

lexis_polygon <- function(lg, x, y, group = 1, fill = lexisplotr_colours()[4], alpha = 0.7) {
  
  x <- as.Date(x, origin = "1970-01-01")
  data <- data.frame(group, x, y)
  
  lg <- lg + geom_polygon(data = data, aes(x = .data$x, y = .data$y, group = .data$group), fill = fill, alpha = alpha)
  return(lg)
}
