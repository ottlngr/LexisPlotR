#' Plot a Lexis Diagram.
#' 
#' lexisplotr is an easy to use function to plot Lexis Diagrams.
#' 
#' 
#' @param from_year integer, set the year the Lexis Diagram starts with.
#' @param to_year integer, set the year the Lexis Diagram ends with.
#' @param from_age integer, set the age the Lexis Diagram starts with.
#' @param to_age integer, set the age the Lexis Diagram ends with.
#' @param cohort integer, set a cohort to emphasize.
#' @param year integer, set a year to emphasize.
#' @param age integer, set an age to emphasize.
#' @param lifelines list, set lifelines to be drawn. The list contains each
#' lifeline as a vector specifying the date of the beginning of the observation 
#' and the date of the end of the observation. Dates in format \code{"dd.mm.yyyy"}.
#' @param triangle list, set triangles to be drawn. The list contains each lifeline
#' as a vector of a year-age-combination and a keyword to determine whether the upper \code{"u"}
#' or lower \code{"l"} triangle shall be drawn.
#' @param colors vector, set the colors used for \code{cohort, year, age, lifelines, triangle}.
#' Default: \code{colors=c("yellow", "green", "blue", "red", "purple")}
#' @param title character, title of the plot. Default: "Lexis Diagram".
#' @param envir, Default: \code{environment()}. Should not be changed. Needed as a workarround.
#' @details Required date format: \code{"dd.mm.yyyy"}.
#' 
#' The function determines the aspect ratio of the x- and y-axis to enforce
#' isosceles triangles. The aspect ratio will not be effected by defining
#' \code{width} and \code{height} in \code{pdf()} or other graphic devices.
#' 
#' Because the returned object is a ggplot2 graph, the overall appearence of
#' the graph can be edited by adding e.g. \code{themes()} to the plot.
#' @return The functions returns a ggplot2-plot.
#' @note To save the plot, using \code{pdf()} is recommended since it will
#' achieve good results and avoid overlapping in most cases. Unix users may use
#' \code{x11()} to start a new graphical device to preview the plot.
#' @author Philipp Ottolinger
#' @seealso \code{\link{ggplot}}
#' @keywords hplot
#' @export lexisplotr
#' @import ggplot2
#' @examples
#' library(LexisPlotR)
#' 
#' ## Plot a Lexis Diagram grid
#' lexisplotr(from_year=1900, to_year=1905, from_age=0, to_age=5)
#' 
#' ## Emphasize a certain cohort, year and age
#' lexisplotr(from_year=1900, to_year=1905, from_age=0, to_age=5,
#'            cohort=1901, year=1903, age=2)
#'            
#' ## Plot lifelines
#' lexisplotr(from_year=1900, to_year=1905, from_age=0, to_age=5,
#'            lifelines=list(c("30.06.1900", "23.09.1903"),
#'                           c("01.01.1901", "31.12.1904")))
#'                           
#' ## Emphasize a certain triangles
#' lexisplotr(from_year=1900, to_year=1905, from_age=0, to_age=5,
#'            triangle=list(c(1901,2,"u"),c(1902,4,"l")))
#'           
#' ## Change the size of the axis text
#' lexis <- lexisplotr(from_year=1900, to_year=1905, from_age=0, to_age=5)
#' lexis <- lexis + theme(axis.text = element_text(size=10))
#' lexis
lexisplotr <- function(from_year, 
                       to_year, 
                       from_age, 
                       to_age, 
                       age, 
                       cohort, 
                       year, 
                       triangle, 
                       lifelines,
                       colors=c("yellow", "green", "blue", "red", "purple"),
                       title="Lexis Diagram",
                       envir=environment()){
  
  #### Create data ####
  from_year.d <- as.Date(paste("01.01.", from_year, sep=""), "%d.%m.%Y")
  to_year.d <- as.Date(paste("01.01.", to_year, sep=""),"%d.%m.%Y")
  years <- from_year:to_year
  years.d <- seq(from_year.d, to_year.d, "year")
  ages <- from_age:to_age
  
  
  #### Plot grid ####
  lex <- ggplot() +
    geom_abline(
      aes(
        intercept=-as.numeric(from_year.d)/364.25+seq(-to_age+1,to_age-1,1), 
        slope=1/364.25),
      lwd=0.4) + 
    geom_hline(
      yintercept=seq(from_age,to_age,1),
      lwd=0.4) +
    geom_vline(
      xintercept = as.numeric(years.d),
      lwd=0.4) +
    scale_x_date(
      limits=c(from_year.d, to_year.d), 
      date_breaks="1 year", 
      expand=c(0,0),
      date_labels="%Y",
      name="Year") +
    scale_y_continuous(
      limits=c(from_age, to_age), 
      expand=c(0,0),
      breaks=ages,
      name="Age")
  
  #### Appearance ####
  lex <- lex +
    theme_bw() +
    theme(
      aspect.ratio=(to_age-from_age)/(as.numeric(to_year.d)/364.25-as.numeric(from_year.d)/364.25),
      axis.line = element_line(colour="black", size=0.3),
      axis.ticks = element_line(colour="black"),
      axis.text.x = element_text(size=14, colour="black"),
      axis.text.y = element_text(size=14, colour="black"),
      axis.title = element_text(size=18, face="bold"),
      plot.title = element_text(size=25, face="bold", vjust=1.5),
      panel.grid.major.y = element_blank(),
      panel.background = element_rect(fill='white', colour='black'),
      panel.grid.major.x = element_blank()) +
    ggtitle("Lexis Diagram")
  
  #### Plot age ####
  if (!missing(age)) {
    lex <- lex + 
      geom_polygon(
        aes(x=c(from_year.d, to_year.d, to_year.d, from_year.d), 
            y=c(age,age, age+1, age+1)), 
        fill=colors[1], 
        col=colors[1], 
        alpha=0.5)
  }
  #### plot cohort ####
  if (!missing(cohort)) {
    lex <- lex + 
      geom_polygon(
        aes(x=c(as.Date(paste("01.01.", cohort, sep=""), "%d.%m.%Y"),
                as.Date(paste("01.01.", cohort+1, sep=""), "%d.%m.%Y"),
                to_year.d, 
                to_year.d),
            y=c(from_age, 
                from_age, 
                to_age-2, 
                to_age-1)),
        col=colors[2], 
        fill=colors[2], 
        alpha=0.5)
  }
  #### plot year ####
  if (!missing(year)) {
    lex <- lex + 
      geom_polygon(
        aes(
          x=c(as.Date(paste("01.01.", year, sep=""), "%d.%m.%Y"),
              as.Date(paste("01.01.", year+1, sep=""), "%d.%m.%Y"),
              as.Date(paste("01.01.", year+1, sep=""), "%d.%m.%Y"),
              as.Date(paste("01.01.", year, sep=""), "%d.%m.%Y")),
          y=c(from_age, from_age, to_age, to_age)),
        col=colors[3], 
        fill=colors[3], 
        alpha=0.5)
  }
  #### plot triangles ####
  #triangle <- list(c(1988,2,"u"),c(1988,3,"u"))
  if (!missing(triangle)) {
    for (i in 1:length(triangle)) {
      if (triangle[[i]][3] == "u") {
        lex <- lex + 
          geom_polygon(
            aes_string(
              x=c(as.Date(paste("01.01.", as.numeric(triangle[[i]][1]), sep=""), "%d.%m.%Y"),
                  as.Date(paste("01.01.", as.numeric(triangle[[i]][1])+1, sep=""), "%d.%m.%Y"),
                  as.Date(paste("01.01.", as.numeric(triangle[[i]][1]), sep=""), "%d.%m.%Y")),
              y=c(as.numeric(triangle[[i]][2]),
                  as.numeric(triangle[[i]][2])+1,
                  as.numeric(triangle[[i]][2])+1)),
            col=colors[4],
            fill=colors[4],
            alpha=0.5
          )
      }
      if (triangle[[i]][3] == "l") {
        lex <- lex + 
          geom_polygon(
            aes_string(
              x=c(as.Date(paste("01.01.", as.numeric(triangle[[i]][1]), sep=""), "%d.%m.%Y"),
                  as.Date(paste("01.01.", as.numeric(triangle[[i]][1])+1, sep=""), "%d.%m.%Y"),
                  as.Date(paste("01.01.", as.numeric(triangle[[i]][1])+1, sep=""), "%d.%m.%Y")),
              y=c(as.numeric(triangle[[i]][2]),
                  as.numeric(triangle[[i]][2]),
                  as.numeric(triangle[[i]][2])+1)), 
            col=colors[4],
            fill=colors[4],
            alpha=0.5
          )
      }
    }
  }
  #### Plot lifelines ####
  # lifelines <- list(c("01.06.1987","01.06.1993"))
  if (!missing(lifelines)) {
    for (i in 1:length(lifelines)) {
      ll <- lifelines[[i]]
      lex <- lex + 
        geom_segment(
          aes_string(
            x=as.Date(ll[1], "%d.%m.%Y"),
            xend=as.Date(ll[2], "%d.%m.%Y"),
            y=0,
            yend=as.numeric(as.Date(ll[2], "%d.%m.%Y")-as.Date(ll[1], "%d.%m.%Y"))/364.25),
          col=colors[5],
          lwd=1
        )
    }
  }
  #### return ####
  return(lex)
}

#### Test call ####
# lexisplotr(
#   from_year=1987,
#   to_year=1994,
#   from_age=0,
#   to_age=7, 
#   age=4, 
#   cohort=1988, 
#   year=1991, 
#   triangle=list(c(1987,2,"u"),c(1992,1,"l"), c(1989,5,"u")), 
#   lifelines = list(c("01.06.1987","01.06.1993"), c("01.02.1991","30.11.1993"))
# )