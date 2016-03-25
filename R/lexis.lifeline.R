lexis.lifeline <- function(lg, entry, exit = NA, colour = "red", alpha = 1, lwd = 0.5) {
  if (!is.ggplot(lg)) { stop("No valid ggplot object.") }
  entry <- as.Date(entry)
  exit <- as.Date(exit)
  year.start <- as.Date(ggplot_build(lg)$data[[1]][1,1], origin="1970-01-01")
  year.end <- as.Date(tail(ggplot_build(lg)$data[[1]]$xend,1), origin = "1970-01-01")
  age.start <- ggplot_build(lg)$data[[1]][1,3]
  age.end <- tail(ggplot_build(lg)$data[[1]]$yend,1)
  
  case <- data.frame(entry, exit)
  case$x <- entry
  case$xend <- ifelse(is.na(exit), year.end, exit)
  case$xend <- as.Date(case$xend, origin = "1970-01-01")
  case$y <- 0
  case$yend <- ifelse(is.na(exit), how.old(case$entry, year.end), how.old(case$entry, case$exit))
  lg <- lg + geom_segment(data = case, aes(x=x,xend=xend,y=y,yend=yend), colour = colour, alpha = alpha, lwd = 1)

return(lg)
}