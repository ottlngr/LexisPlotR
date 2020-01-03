#' Emphasize a certain age in Lexis grid
#' 
#' Add a coloured rectangle to an existing Lexis grid to highlight a certain age in that Lexis grid.
#' 
#' @param lg, an existing object originally created with \code{lexis_grid()}.
#' @param age numeric, set the age to highlight.
#' @param delta numeric, set the size of the age groups. Default is 1.
#' @param fill character, set colour to fill the rectangle.
#' @param alpha numeric, set alpha, the level of transparency for \code{fill}. Default is \code{0.5}.
#' @details Takes an existing Lexis grid and adds a coloured rectangle that highlights all triangles belonging to a certain age.
#' @return A ggplot2 object.
#' @author Philipp Ottolinger
#' @import ggplot2
#' @importFrom utils tail
#' @export lexis_age
#' @examples 
#' library(LexisPlotR)
#' lexis <- lexis_grid(year_start = 1900, year_end = 1905, age_start = 0, age_end = 5)
#' lexis <- lexis_age(lg = lexis, age = 3)

lexis_age <- function(lg, age, delta = 1, fill = lexisplotr_colours()[1], alpha = 0.7) { 
  
  age <- as.numeric(age)
  
  gg <- ggplot_build(lg)
  
  year_start <- as.Date(gg$layout$coord$limits$x[1], origin = "1970-01-01")
  year_end <- as.Date(gg$layout$coord$limits$x[2], origin = "1970-01-01")
  age_start <- gg$layout$coord$limits$y[1]
  age_end <- gg$layout$coord$limits$y[2]
  
  if (age > age_end) { stop("Out of bounds.") }
  if (age < age_start) { stop("Out of bounds.") }
  
  polygon <- data.frame(x = c(year_start, year_end, year_end, year_start), y = c(age, age, age + delta, age + delta))
  
  lg <- lg + geom_polygon(data = polygon, aes(x = .data$x, y = .data$y), fill = fill, alpha = alpha, colour = NA)
  
  return(lg)
}