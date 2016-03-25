lexis.grid <- function(year.start, year.end, age.start, age.end) {
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
  # create data.frame for diagonal geom_segment()
  dia <- data.frame()
  for (i in 1:length(year.seq[-length(year.seq)])) {
    for (j in 1:length(age.seq[-length(age.seq)])) {
      a <- year.seq[i]
      b <- year.seq[i+1]
      c <- age.seq[j]
      d <- age.seq[j+1]
      dia <- rbind(dia, c(a, b, c, d))
    }
  }
  colnames(dia) <- c("a","b","c","d")
  dia$a <- as.Date(dia$a, origin = "1970-01-01")
  dia$b <- as.Date(dia$b, origin = "1970-01-01")
  
  # Basic plot
  gg <- ggplot() + 
    geom_segment(aes(x = year.seq, xend = year.seq, y = age.start, yend = age.end)) +
    geom_segment(aes(x = year.start, xend = year.end, y = age.seq, yend = age.seq)) +
    geom_segment(aes(x = dia$a, xend = dia$b, y = dia$c, yend = dia$d))

  # Plot appearance
  gg <- gg + 
    scale_x_date(date_breaks="1 year", expand=c(0,0), date_labels="%Y", name="Year") +
    scale_y_continuous(expand=c(0,0), breaks=age.seq, name="Age") +
    coord_fixed(ratio = 365.25, xlim=c(year.start,year.end), ylim = c(age.start, age.end)) +
    theme_bw() + 
    theme(
      panel.grid.major = element_blank(),
      panel.grid.minor = element_blank()
      )
  return(gg)
}