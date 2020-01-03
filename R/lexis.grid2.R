#' Deprecated. Plot a Lexis grid
#' 
#' lexis.grid() plots the basic Lexis grid.
#' 
#' @param year.start integer, set the year the Lexis Diagram starts with.
#' @param year.end integer, set the year the Lexis Diagram ends with.
#' @param age.start integer, set the age the Lexis Diagram starts with.
#' @param age.end integer, set the age the Lexis Diagram ends with.
#' @param lwd numeric, set the linewidth of the grid.
#' @param force.equal logical, by default \code{lexis.grid} uses \code{ggplot2::coord_fixed()} to ensure isosceles trianlges. Set \code{FALSE} to allow for a non-isosceles appearance.
#' @param d numeric, set the size of the age groups. Default is 1.
#' @details  
#' The function determines the aspect ratio of the x- and y-axis to enforce
#' isosceles triangles. The aspect ratio will not be effected by defining
#' \code{width} and \code{height} in \code{pdf()} or other graphic devices.
#' 
#' Because the returned object is a ggplot2 graph, the overall appearence of
#' the graph can be edited by adding \code{themes()} to the plot.
#' @return The functions returns a ggplot2-plot.
#' @author Philipp Ottolinger
#' @import ggplot2
#' @export lexis.grid2
#' @examples 
#' \dontrun{
#' library(LexisPlotR)
#' lexis.grid(year.start = 1900, year.end = 1905, age.start = 0, age.end = 5)
#' }
lexis.grid2 <- function(year.start, year.end, age.start, age.end, lwd = 0.3, force.equal = T, d = 1) {
  .Deprecated("lexis_grid")
  # check arguments for is.numeric()
  if (!is.numeric(year.start)) { stop("No numeric value for year.start") }
  if (!is.numeric(year.end)) { stop("No numeric value for year.end") }
  if (!is.numeric(age.start)) { stop("No numeric value for age.start") }
  if (!is.numeric(age.end)) { stop("No numeric value for age.end") }
  # check sequence
  if (year.start >= year.end) { stop("year.start >= year.end") }
  if (age.start >= age.end) { stop("age.start >= age.end") }
  # transform to as.Date()
  year.start <- as.Date(paste(year.start, "-01-01", sep = ""))
  year.end <- as.Date(paste(year.end, "-01-01", sep = ""))
  # create sequences
  year.seq <- seq(year.start, year.end, by = "year")
  age.seq <- age.start:age.end
  
  x <- NULL
  y <- NULL 
  ####
  year.zero <- as.Date("1970-01-01")
  diff.zero <- as.numeric(round((year.start - year.zero)/365.25))
  diff.year <- as.numeric(round((year.end - year.start)/365.25))
  diff.dia <- diff.year - 1
  
  m <- merge(year.seq, age.seq)
  
  gg <- ggplot() +
    geom_blank(data = m, aes(x = x, y = y)) +
    geom_abline(intercept = seq(-diff.dia-100, diff.dia+100, d)-1, slope = 1/365.25, lwd = lwd)
  gg
  ####
  # create data.frame for diagonal geom_segment()
  # dia <- data.frame()
  # for (i in 1:length(year.seq[-length(year.seq)])) {
  #   for (j in 1:length(age.seq[-length(age.seq)])) {
  #     a <- year.seq[i]
  #     b <- year.seq[i+1]
  #     c <- age.seq[j]
  #     d <- age.seq[j+1]
  #     dia <- rbind(dia, c(a, b, c, d))
  #   }
  # }
  # colnames(dia) <- c("a","b","c","d")
  # dia$a <- as.Date(dia$a, origin = "1970-01-01")
  # dia$b <- as.Date(dia$b, origin = "1970-01-01")
  # 
  # # Basic plot
  # gg <- ggplot() + 
  #   geom_segment(aes(x = year.seq, xend = year.seq, y = age.start, yend = age.end), lwd = lwd) +
  #   geom_segment(aes(x = year.start, xend = year.end, y = age.seq, yend = age.seq), lwd = lwd) +
  #   geom_segment(aes(x = dia$a, xend = dia$b, y = dia$c, yend = dia$d), lwd = lwd)
  # 
  # Plot appearance
  
  gg <- gg + 
    scale_x_date(breaks=year.seq[seq(1,length(year.seq), d)], expand=c(0,0), date_labels="%Y", name="Year") +
    scale_y_continuous(expand=c(0,0), breaks=age.seq[seq(1, length(age.seq), d)], name="Age") +
    #coord_fixed(ratio = 365.25, xlim=c(year.start,year.end), ylim = c(age.start, age.end)) +
    theme_bw() +
    theme(panel.grid.major = element_line(colour = "black", size = lwd),
          panel.grid.minor = element_blank())
  gg
  
  if (force.equal == T) {
    gg <- gg + coord_fixed(ratio = 365.25, xlim=c(year.start,year.end), ylim = c(age.start, age.end))
  }
  return(gg)
}