# #' Emphasize a certain cohort in a Lexis grid
# #' 
# #' Takes an existing Lexis grid and adds a coloured rectangle to highlight a certain cohort.
# #' 
# #' @param lg, an existing object originally created with \code{lexis.grid()}.
# #' @param cohort date, set the cohort to highlight starting from a specific date.
# #' @param fill character, set the colour of the rectangle. Default is \code{"green"}.
# #' @param alpha numeric, set the level of transparency of the rectangle. Default is \code{0.5}.
# #' @details Takes an existing Lexis grid and adds a coloured rectangle to the plot. The rectangle will highlight a certain cohort in the Lexis grid.
# #' @author Philipp Ottolinger
# #' @import ggplot2
# #' @importFrom utils tail
# #' @importFrom lubridate years
# #' @export lexis.cohort2
# #' @examples
# #' library(LexisPlotR)
# #' lg <- lexis.grid(year.start = 1900, year.end = 1905, age.start = 0, age.end = 5)
# #' lexis.cohort2(lg = lg, cohort = "1901-06-01")
# 
# lexis.cohort2 <- function(lg, cohort, fill = "green", alpha = 0.5) {
#   if (!is.ggplot(lg)) { stop("No valid ggplot object.") }
#   year.start <- as.Date(ggplot_build(lg)$data[[1]][1,1], origin="1970-01-01")
#   year.end <- as.Date(tail(ggplot_build(lg)$data[[1]]$xend,1), origin = "1970-01-01")
#   age.start <- ggplot_build(lg)$data[[1]][1,3]
#   age.end <- tail(ggplot_build(lg)$data[[1]]$yend,1)
#   x <- NULL
#   y <- NULL
#   cdate <- as.Date(cohort, origin = "1970-01-01")
#   print(cdate)
#   df <- data.frame(x = c(as.numeric(cdate), 
#                          as.numeric(cdate + years(1)), 
#                          as.numeric(cdate + years(1)) + age.end*365, 
#                          as.numeric(cdate) + age.end*365),
#                    y = c(0,0,age.end, age.end))
#   print(df)
#   df$x <- as.Date(df$x, origin = "1970-01-01")
#   lg <- lg + geom_polygon(data = df, aes(x,y), fill = fill, alpha = alpha)
#   return(lg)
# }
# 
