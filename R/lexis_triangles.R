#' Fill Lexis triangles by HMD data
#' 
#' The function opens an existing Lexis grid and fill the triangles according to data from the Human Mortality Database.
#' 
#' @param lg, an existing object originally created with \code{lexis.grid()}.
#' @param hmd.data, a data.frame created with \code{prepare.hmd()}.
#' @param column character, the name of the column of \code{hmd.data} the triangles shall be filled with.
#' @details The function creates a subset of \code{hmd.data} that fits in the dimensions of the existing Lexis grid.
#' The triangles will be filled according to the data in \code{column}.
#' @author Philipp Ottolinger
#' @import ggplot2
#' @importFrom utils tail
#' @export lexis.hmd
#' @examples 
#' library(LexisPlotR)
#' lg <- lexis.grid(year.start = 1980, year.end = 1985, age.start = 0, age.end = 5)
#' # Load sample data
#' path <- system.file("extdata", "Deaths_lexis_sample.txt", package = "LexisPlotR")
#' deaths.triangles <- prepare.hmd(path)
#' lexis.hmd(lg = lg, hmd.data = deaths.triangles, column = "Total")
#' 
#' ### Plot data not explicitly present in HMD data
#' deaths.triangles$RatioMale <- deaths.triangles$Male / deaths.triangles$Total
#' lexis.hmd(lg, deaths.triangles, "RatioMale")

lexis_triangles <- function(lg, triangles_data, column) {
  
  gg <- ggplot_build(lg)
  
  year_start <- as.Date(gg$layout$coord$limits$x[1], origin = "1970-01-01")
  year_start <- as.numeric(substr(year_start,1,4))
  year_end <- as.Date(gg$layout$coord$limits$x[2], origin = "1970-01-01")
  year_end <- as.numeric(substr(year_end,1,4))
  age_start <- gg$layout$coord$limits$y[1]
  age_end <- gg$layout$coord$limits$y[2]
  
  filterYear <- year_start:(year_end - 1)
  filterAge <- age_start:(age_end - 1)
  
  data <- triangles_data[triangles_data$Year %in% filterYear & triangles_data$Age %in% filterAge,]
  
  #
  n <- dim(data)[1]
  data$id <- 1:n
  
  xs <- data %>% 
    group_by(id) %>% 
    gather("x", "xx", x1, x2, x3) %>% 
    mutate(index = 1:n()) %>%
    select(id, index, xx)
  
  ys <- data %>%
    group_by(id) %>%
    gather("y", "yy", y1, y2, y3) %>%
    mutate(index = 1:n()) %>%
    select(id, index, yy)
  
  values <- data %>%
    select(id, Male)
  
  triangles <- xs %>%
    left_join(ys) %>%
    left_join(values)
  #
  
  n <- dim(data)[1]
  
  for (i in 1:n) {
    xx <- c(data[i,"x1"],data[i,"x2"],data[i,"x3"])
    yy <- c(data[i,"y1"],data[i,"y2"],data[i,"y3"])
    zz <- data[i, column]
    df <- data.frame(xx,yy,zz)
    lg <- lg + geom_polygon(data = df, aes(x = xx, y = yy, fill=zz))
  }
  lg <- lg + labs(fill = column)
  return(lg)
}