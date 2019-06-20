#' Tidy triangular data (Lexis triangles)
#' 
#' Take raw data from a data source (e.g. Human Mortality Database) and make it 'tidy'.
#' 
#' @param triangle_data data.frame, A data.frame containing raw triangle data.
#' @param source character, The source of the raw data. Supported sources: HMD.
#' @details When using raw triangular data from HMD or other sources, the data is not well prepared for further use. \code{tidy_triangular_data} does some transformations to prepare the data, mainly for visualization using \code{ggplot2}.
#' @return A data.frame.
#' @author Philipp Ottolinger
#' @importFrom tidyr gather
#' @importFrom dplyr select mutate group_by %>% left_join
#' @export tidy_triangle_data
#' @examples
#' \dontrun{
#' triangles <- readHMDweb("RUS", "Deaths_lexis", "your@email.com", "your_password")
#' }

tidy_triangle_data <- function(triangle_data, source = "HMD") {
  
  if (source == "HMD") {
  
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
    
  } else {
    
    stop(sprintf("Not implemented for data source %s", source))
    
  }
  
}