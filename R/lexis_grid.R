#' Plot a Lexis grid
#' 
#' lexis_grid() plots the basic Lexis grid.
#' 
#' @param year_start integer, set the year the Lexis Diagram starts with.
#' @param year_end integer, set the year the Lexis Diagram ends with.
#' @param age_start integer, set the age the Lexis Diagram starts with.
#' @param age_end integer, set the age the Lexis Diagram ends with.
#' @param lwd numeric, set the linewidth of the grid.
#' @param force_equal logical, by default \code{lexis.grid} uses \code{ggplot2::coord_fixed()} to ensure isosceles trianlges. Set \code{FALSE} to allow for a non-isosceles appearance.
#' @param delta numeric, set the size of the age groups. Default is 1.
#' @details  
#' The function determines the aspect ratio of the x- and y-axis to enforce
#' isosceles triangles. The aspect ratio will not be effected by defining
#' \code{width} and \code{height} in \code{pdf()} or other graphic devices.
#' 
#' Because the returned object is a ggplot2 graph, the overall appearence of
#' the graph can be edited by adding \code{themes()} to the plot.
#' @return A ggplot object.
#' @author Philipp Ottolinger
#' @import ggplot2
#' @export lexis_grid
#' @examples 
#' library(LexisPlotR)
#' lexis_grid(year_start = 1900, year_end = 1905, age_start = 0, age_end = 5)

lexis_grid <- function(year_start, year_end, age_start, age_end, delta = 1, lwd = 0.3, force_equal = TRUE) {
  
  # check arguments
  if (!is.numeric(year_start)) { stop("The value of year_start must be numeric.") }
  if (!is.numeric(year_end)) { stop("The value of year_end must be numeric.") }
  if (!is.numeric(age_start)) { stop("The value of age_start must be numeric.") }
  if (!is.numeric(age_end)) { stop("The value of age_end must be numeric.") }
  if (year_start >= year_end) { stop("The provided year_start is not earlier than the provided year_end.") }
  if (age_start >= age_end) { stop("The provided age_start is not smaller than the provided age_end.") }
  
  # transform numeric years to dates
  year_start <- as.Date(paste(year_start, "-01-01", sep = ""))
  year_end <- as.Date(paste(year_end, "-01-01", sep = ""))
  
  # create sequences
  year_seq <- seq(year_start, year_end, by = "year")
  age_seq <- age_start:age_end
  
  # ?
  #x <- NULL
  #y <- NULL 
  
  # create helper values
  year_zero <- as.Date("1970-01-01")
  diff_zero <- as.numeric(round((year_start - year_zero)/365.25))
  diff_year <- as.numeric(round((year_end - year_start)/365.25))
  diff_dia <- diff_year - 1
  
  # merge the year and the age sequences
  m <- merge(year_seq, age_seq)
  
  # Initialize the plot with theme_bw() as default theme
  lexis <- ggplot() + theme_bw()
  
  # Create a blank plotting area with the respective size
  lexis <- lexis + geom_blank(data = m, aes(x = .data$x, y = .data$y))
  
  # Plot the diagonals
  lexis <- lexis + geom_abline(intercept = seq(-diff_dia - 100, diff_dia + 100, delta) - 1, slope = 1/365.25, lwd = lwd)
  
  # Set x-axis labels according to the delta
  lexis <- lexis + scale_x_date(breaks=year_seq[seq(1,length(year_seq), delta)], expand=c(0,0), date_labels="%Y")
  
  # Set y-axis lables according to the delta
  lexis <- lexis + scale_y_continuous(expand=c(0,0), breaks=age_seq[seq(1, length(age_seq), delta)])
  
  # Use panel.grid to complete the grid
  lexis <- lexis + theme(panel.grid.major = element_line(colour = "black", size = lwd))
  lexis <- lexis + theme(panel.grid.minor = element_blank())

  # Remove axis labels by default
  lexis <- lexis + labs(x = "", y = "")
  
  # Make sure everything is square (if desired)
  if (force_equal == TRUE) {
    lexis <- lexis + coord_fixed(ratio = 365.25, xlim=c(year_start,year_end), ylim = c(age_start, age_end))
  }
  
  return(lexis)
  
}