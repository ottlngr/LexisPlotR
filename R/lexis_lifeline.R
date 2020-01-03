#' Plot lifelines into a Lexis grid
#' 
#' Add lifelines to an existing Lexis grid.
#' 
#' @param lg, an existing object originally created with \code{lexis_grid()}.
#' @param birth character, set the birth date of an individual in format \code{"YYYY-MM-DD"}.
#' @param entry character, set the entry of an individual in format \code{"YYYY-MM-DD"}. Optional.
#' @param exit character, set the exit or death date of an individual in format \code{"YYYY-MM-DD"}. Optional.
#' @param lineends logical, if \code{TRUE} lineends will be marked. Default is \code{FALSE}.
#' @param colour character, set the colour of the lifelines.
#' @param alpha numeric, set the transparency of the lifelines. Default is \code{1} (no transparency).
#' @param lwd numeric, set the linewidth of the lifelines. Default is \code{0.5}.
#' @details Takes an existing Lexis grid and adds lifelines to the grid. Input can be a single dates or dates from a vector.
#' @return A ggplot2 object.
#' @author Philipp Ottolinger
#' @import ggplot2
#' @importFrom dplyr mutate %>% n
#' @importFrom utils tail
#' @export lexis_lifeline
#' @examples 
#' lg <- lexis_grid(year_start = 1900, year_end = 1905, age_start = 0, age_end = 5)
#' lexis_lifeline(lg = lg, birth = "1901-09-23")
#' lexis_lifeline(lg = lg, birth = "1901-09-23", entry = "1902-04-01")
#' lexis_lifeline(lg = lg, birth = "1901-09-23", exit = "1904-10-31")

lexis_lifeline <- function(lg, birth, entry = NA, exit = NA, lineends = FALSE, colour = lexisplotr_colours()[5], alpha = 1, lwd = 0.5) {
  
  if (!is.ggplot(lg)) { stop("No valid ggplot object.") }
  
  gg <- ggplot_build(lg)
  
  year_start <- as.Date(gg$layout$coord$limits$x[1], origin = "1970-01-01")
  year_end <- as.Date(gg$layout$coord$limits$x[2], origin = "1970-01-01")
  age_start <- gg$layout$coord$limits$y[1]
  age_end <- gg$layout$coord$limits$y[2]
  
  data <- data.frame(birth, entry, exit, stringsAsFactors = FALSE)
  
  lifelines <- data %>%
    mutate(id = 1:n()) %>%
    mutate(birth = as.Date(birth, origin = "1970-01-01"),
           entry = as.Date(entry, origin = "1970-01-01"),
           exit = as.Date(exit, origin = "1970-01-01")) %>%
    mutate(x = as.Date(ifelse(is.na(entry), birth, entry), origin = "1970-01-01"),
           xend = as.Date(ifelse(is.na(exit), year_end, exit), origin = "1970-01-01"),
           y = ifelse(is.na(entry), 0, age_from_start_and_end_date(birth, entry)),
           yend = ifelse(is.na(exit), age_from_start_and_end_date(birth, year_end), age_from_start_and_end_date(birth, exit)))
  
  lg <- lg + geom_segment(data = lifelines, aes(x = .data$x, xend = .data$xend, y = .data$y, yend = .data$yend), colour = colour, alpha = alpha, lwd = lwd)
  
  if (lineends == TRUE) {
    lg <- lg + geom_point(data = lifelines[!is.na(lifelines$exit),], aes(x = .data$xend, y = .data$yend), size=2, shape = 3)
  }
  
  return(lg)
  
}

