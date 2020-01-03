#' Emphasize a certain cohort in a Lexis grid
#' 
#' Takes an existing Lexis grid and adds a coloured rectangle to highlight a certain cohort.
#' 
#' @param lg, an existing object originally created with \code{lexis_grid()}.
#' @param cohort numeric, set the cohort to highlight.
#' @param delta numeric, set the size of the age groups. Default is 1.
#' @param fill character, set the colour of the rectangle.
#' @param alpha numeric, set the level of transparency of the rectangle. Default is \code{0.5}.
#' @details Takes an existing Lexis grid and adds a coloured rectangle to the plot. The rectangle will highlight a certain cohort in the Lexis grid.
#' @author Philipp Ottolinger
#' @import ggplot2
#' @importFrom utils tail
#' @export lexis_cohort
#' @examples
#' library(LexisPlotR)
#' lg <- lexis_grid(year_start = 1900, year_end = 1905, age_start = 0, age_end = 5)
#' lexis_cohort(lg = lg, cohort = 1901)

lexis_cohort <- function(lg, cohort, delta = 1, fill = lexisplotr_colours()[3], alpha = 0.7) {

  if (!is.ggplot(lg)) { stop("No valid ggplot object.") }
  
  gg <- ggplot_build(lg)
  
  year_start <- as.Date(gg$layout$coord$limits$x[1], origin = "1970-01-01")
  year_end <- as.Date(gg$layout$coord$limits$x[2], origin = "1970-01-01")
  age_start <- gg$layout$coord$limits$y[1]
  age_end <- gg$layout$coord$limits$y[2]
  
  polygon <- data.frame(x = c(cohort, cohort + delta, cohort + delta + age_end, cohort + age_end), 
                        y = c(age_start, age_start, age_end + age_start, age_end + age_start))
  
  polygon$x <- as.Date(paste(polygon$x, "-01-01", sep = ""), origin = "1970-01-01")
  
  lg <- lg + geom_polygon(data = polygon, aes(x = .data$x, y = .data$y), fill = fill, alpha = alpha)
  
  return(lg)
}

