#' Emphasize a certain year in Lexis grid.
#' 
#' Takes an existing Lexis grid and adds a coloured rectangle to highlight a certain age.
#' 
#' @param lg, an existing object originally created with \code{lexis_grid()}.
#' @param year numeric, set the year to highlight.
#' @param delta numeric, set the size of the age groups. Default is 1.
#' @param fill character, set the colour of the rectangle.
#' @param alpha numeric, set the transparency of the rectangle. Default is \code{0.5}.
#' @details Takes an existing Lexis grid and adds a coloured rectangle to the plot. The rectangle will highlight a certain year in the grid.
#' @return A ggplot2 object.
#' @author Philipp Ottoliner
#' @import ggplot2
#' @importFrom utils tail
#' @export lexis_year
#' @examples 
#' lg <- lexis_grid(year_start = 1900, year_end = 1905, age_start = 0, age_end = 5)
#' lexis_year(lg = lg, year = 1902)

lexis_year <- function(lg, year, delta = 1, fill = lexisplotr_colours()[2], alpha = 0.7) {
  
  if (!is.ggplot(lg)) { stop("No valid ggplot object.") }
  
  gg <- ggplot_build(lg)
  
  year_start <- as.Date(gg$layout$coord$limits$x[1], origin = "1970-01-01")
  year_start <- as.numeric(substr(year_start,1,4))
  year_end <- as.Date(gg$layout$coord$limits$x[2], origin = "1970-01-01")
  year_end <- as.numeric(substr(year_end,1,4))
  age_start <- gg$layout$coord$limits$y[1]
  age_end <- gg$layout$coord$limits$y[2]
  
  if (year > year_end - 1) { stop("Out of bounds.") }
  if (year < year_start) { stop("Out of bounds.") }
  
  year1 <- year + delta
  year <- as.Date(paste(year, "-01-01", sep = ""), origin = "1970-01-01")
  year1 <- as.Date(paste(year1, "-01-01", sep = ""), origin = "1970-01-01")

  polygon <- data.frame(x = c(year, year1, year1, year),
                        y = c(age_start, age_start, age_end, age_end))
  
  lg <- lg + geom_polygon(data = polygon, aes(x = .data$x, y = .data$y), fill = fill, alpha = alpha, colour = NA)
  
  return(lg)
}