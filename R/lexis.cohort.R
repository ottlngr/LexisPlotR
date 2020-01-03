#' Deprecated. Emphasize a certain cohort in a Lexis grid
#' 
#' Takes an existing Lexis grid and adds a coloured rectangle to highlight a certain cohort.
#' 
#' @param lg, an existing object originally created with \code{lexis.grid()}.
#' @param cohort numeric, set the cohort to highlight.
#' @param fill character, set the colour of the rectangle. Default is \code{"green"}.
#' @param alpha numeric, set the level of transparency of the rectangle. Default is \code{0.5}.
#' @param d numeric, set the size of the age groups. Default is 1.
#' @details Takes an existing Lexis grid and adds a coloured rectangle to the plot. The rectangle will highlight a certain cohort in the Lexis grid.
#' @author Philipp Ottolinger
#' @import ggplot2
#' @importFrom utils tail
#' @export lexis.cohort
#' @examples
#' \dontrun{
#' library(LexisPlotR)
#' lg <- lexis.grid(year.start = 1900, year.end = 1905, age.start = 0, age.end = 5)
#' lexis.cohort(lg = lg, cohort = 1901)
#' }

lexis.cohort <- function(lg, cohort, fill = lpr_colours()[4], alpha = 0.7, d = 1) {
  .Deprecated("lexis_cohort")
  if (!is.ggplot(lg)) { stop("No valid ggplot object.") }
  # year.start <- as.Date(ggplot_build(lg)$data[[1]][1,1], origin="1970-01-01")
  # year.end <- as.Date(tail(ggplot_build(lg)$data[[1]]$xend,1), origin = "1970-01-01")
  # age.start <- ggplot_build(lg)$data[[1]][1,3]
  # age.end <- tail(ggplot_build(lg)$data[[1]]$yend,1)
year.start <- as.Date(min(ggplot_build(lg)$layout$panel_ranges[[1]]$x.major_source), origin = "1970-01-01")
year.end <- as.Date(max(ggplot_build(lg)$layout$panel_ranges[[1]]$x.major_source), origin = "1970-01-01")
age.start <- min(ggplot_build(lg)$layout$panel_ranges[[1]]$y.major_source)
age.end <- max(ggplot_build(lg)$layout$panel_ranges[[1]]$y.major_source)
  x <- NULL
  y <- NULL
  df <- data.frame(x = c(cohort, cohort+d, cohort+d+age.end, cohort + age.end),
                   y = c(age.start,age.start,age.end+age.start, age.end+age.start))
  df$x <- as.Date(paste(df$x, "-01-01", sep = ""), origin = "1970-01-01")
  lg <- lg + geom_polygon(data = df, aes(x,y), fill = fill, alpha = alpha)
  return(lg)
}

