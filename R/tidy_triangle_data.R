#' @importFrom tidyr gather
#' @importFrom dplyr select mutate group_by %>% left_join
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
    select(.data$id, .data$Female, .data$Male, .data$Total)
  
  x_coords <- triangle_data %>%
    select(.data$id, .data$x1, .data$x2, .data$x3) %>%
    group_by(.data$id) %>%
    gather("coord", "x", .data$x1, .data$x2, .data$x3) %>%
    mutate(index = 1:n()) %>%
    select(.data$id, .data$index, .data$x)
  
  y_coords <- triangle_data %>%
    select(.data$id, .data$y1, .data$y2, .data$y3) %>%
    group_by(.data$id) %>%
    gather("coord", "y", .data$y1, .data$y2, .data$y3) %>%
    mutate(index = 1:n()) %>%
    select(.data$id, .data$index, .data$y)
  
  tidy_triangles <- values %>%
    left_join(x_coords) %>%
    left_join(y_coords) %>%
    select(.data$id, .data$index, .data$x, .data$y, .data$Female, .data$Male, .data$Total)
  
  return(tidy_triangles)
  
}