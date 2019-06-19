#' @importFrom tidyr gather
#' @importFrom dplyr select mutate group_by %>%
#' @export tidy_triangle_data
#' @examples 
#' triangles <- readHMDweb("RUS", "Deaths_lexis", "philipp.ottolinger@uni-rostock.de", "sterberate")

tidy_triangle_data <- function(triangle_data) {
  
  triangle_data$id <- 1:dim(triangle_data)[1]
  
  triangle_data$upper <- ifelse(triangle_data$Year - triangle_data$Age > triangle_data$Cohort, TRUE, FALSE)
  
  triangle_data$x1 <- ifelse(triangle_data$upper == FALSE, triangle_data$Year, triangle_data$Year)
  triangle_data$x2 <- ifelse(triangle_data$upper == FALSE, triangle_data$Year + 1, triangle_data$Year)
  triangle_data$x3 <- ifelse(triangle_data$upper == FALSE, triangle_data$Year + 1, triangle_data$Year + 1)
  
  triangle_data$x1 <- as.Date(paste(triangle_data$x1, "-01-01", sep = ""), origin = "1970-01-01")
  triangle_data$x2 <- as.Date(paste(triangle_data$x2, "-01-01", sep = ""), origin = "1970-01-01")
  triangle_data$x3 <- as.Date(paste(triangle_data$x3, "-01-01", sep = ""), origin = "1970-01-01")
  
  triangle_data$y1 <- ifelse(triangle_data$upper == FALSE, triangle_data$Age, triangle_data$Age)
  triangle_data$y2 <- ifelse(triangle_data$upper == FALSE, triangle_data$Age, triangle_data$Age + 1)
  triangle_data$y3 <- ifelse(triangle_data$upper == FALSE, triangle_data$Age + 1, triangle_data$Age + 1)
  
  values <- triangle_data %>% 
    select(id, Female, Male, Total)
  
  x_coords <- triangle_data %>%
    select(id, x1, x2, x3) %>%
    group_by(id) %>%
    gather("coord", "x", x1, x2, x3) %>%
    mutate(index = 1:n()) %>%
    select(id, index, x)
  
  y_coords <- triangle_data %>%
    select(id, y1, y2, y3) %>%
    group_by(id) %>%
    gather("coord", "y", y1, y2, y3) %>%
    mutate(index = 1:n()) %>%
    select(id, index, y)
  
  tidy_triangles <- values %>%
    left_join(x_coords) %>%
    left_join(y_coords) %>%
    select(id, index, x, y, Female, Male, Total)
  
  return(tidy_triangles)
  
}