#' Plot a Lexis Diagram.
#' 
#' lexisplotr is an easy to use function to plot Lexis Diagrams.
#' 
#' Required date format: \code{"dd/mm/yyyy"}.
#' 
#' The function determines the aspect ratio of the x- and y-axis to enforce
#' isosceles triangles. The aspect ratio will not be effected by defining
#' \code{width} and \code{height} in \code{pdf()} or other graphic devices.
#' 
#' Because the returned object is a ggplot2 graph, the overall appearence of
#' the graph can be edited by adding e.g. \code{themes()} to the plot.
#' 
#' @param from_year integer, set the year the Lexis Diagram starts with
#' (January 1st).
#' @param to_year integer, set the year the Lexis Diagram ends with (January
#' 1st).
#' @param from_age integer, set the age the Lexis Diagram starts with.
#' @param to_age integer, set the age the Lexis Diagram ends with.
#' @param cohort integer, set a cohort to emphasize.
#' @param year integer, set a year to emphasize.
#' @param age integer, set an age to emphasize.
#' @param lifelines list, set lifelines to be drawn. The list contains each
#' lifeline as a vector specifying the date of birth of the respective person,
#' the date of the beginning of the observation and the date of the end of the
#' observation. Dates in format \code{"dd/mm/yyyy"}.
#' @param polygon list, set polygons to be drawn. The list contains each
#' lifeline as a vector specifying the coordinates of the polygon. The vector
#' contains the coordinates on the x-axis (dates) followed by the coordintes of
#' the y-axis (integer).  Dates in format \code{"dd/mm/yyyy"}.
#' @param xlab character, set the label for the x-axis. Default: "Year".
#' @param ylab character, set the label for the y-axis. Default: "Age".
#' @param year_col character, set the colour used to emphasize \code{year}.
#' Default: \code{"red"} with \code{alpha=0.5}.
#' @param cohort_col character, set the colour used to emphasize \code{cohort}.
#' Default: \code{"green"} with \code{alpha=0.5}.
#' @param age_col character, set the colour used to emphasize \code{age}.
#' Default: \code{"blue"} with \code{alpha=0.5}.
#' @param ll_col character, set the colour used for \code{lifelines}. Default:
#' \code{"blue"}.
#' @param poly_col character, set the colour used for \code{polygons}. Default:
#' \code{"grey"}.
#' @param title character, title of the plot. Default: "Lexis Diagram".
#' @return The functions returns a ggplot2-plot.
#' @note To save the plot, using \code{pdf()} is recommended since it will
#' achieve good results and avoid overlapping in most cases. Unix users may use
#' \code{x11()} to start a new graphical device to preview the plot.
#' @author Philipp Ottolinger
#' @seealso %% ~~objects to See Also as \code{\link{help}}, ~~~
#' \code{\link{ggplot2}}
#' @references %% ~put references to the literature/web site here ~
#' @keywords hplot
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
#'            lifelines=list(c("03/03/1900","01/07/1900","27/06/1901"),
#'                           c("01/06/1900","01/01/1901","31/12/1903"),
#'                           c("23/09/1902","23/09/1902","31/12/1904")))
#'                           
#' ## Emphasize a certain Lexis Triangle
#' lexisplotr(from_year=1900, to_year=1905, from_age=0, to_age=5,
#'           polygon=list(c("01/01/1901","31/12/1901","31/12/1901","01/01/1901",1,1,2,1))
#'            
#' ## Change the size of the axis texts
#' lexis <- lexisplotr(from_year=1900, to_year=1905, from_age=0, to_age=5)
#' lexis <- lexis + theme(axis.text = element_text(size=10))
#' lexis
#' 
#' ## Save the plot to pdf
#' pdf("LexisDiagram.pdf")
#' lexisplotr(from_year=1900, to_year=1905, from_age=0, to_age=5)
#' dev.off()
#' 
lexisplotr <- function(from_year, to_year, from_age, to_age, cohort,year,age,lifelines,polygon,
                       xlab="Year",ylab="Age", year_col="red", cohort_col="green", age_col="blue", ll_col="blue", poly_col="grey", title="Lexis Diagram") {
  
  
  ##### create data #####
  aseq <<- from_age:to_age
  adist <- to_age - from_age
  yyseq <<- (from_year - (adist)):(to_year+(adist))
  yy_start.d <<- as.Date(paste("01/01/",yyseq[1],sep=""),"%d/%m/%Y") 
  yy_end.d <<- as.Date(paste("01/01/",yyseq[length(yyseq)],sep=""),"%d/%m/%Y")
  yyseq.d <<- seq(yy_start.d, yy_end.d,"year")
  from_year.d <<- as.Date(paste("01/01/",from_year,sep=""),"%d/%m/%Y")
  to_year.d <<- as.Date(paste("01/01/",to_year,sep=""),"%d/%m/%Y")
  yseq.d <<- seq(from_year.d, to_year.d, "year")
  
  ##### basic plot settings #####
  lex <- ggplot() +
    theme(axis.line = element_line(colour="black", size=0.3)) +
    theme(axis.ticks = element_line(colour="black")) +
    theme(axis.text = element_text(size=14, colour="black")) +
    theme(axis.title = element_text(size=18, face="bold")) + 
    theme(plot.title = element_text(size=25, face="bold")) +
    theme(panel.grid.major.y = element_blank()) +
    theme(panel.background = element_rect(fill='white', colour='black')) +
    theme(panel.grid.major.x = element_blank())
  
  ##### plot grid #####
  lex <- lex
  lex <- lex + scale_y_continuous(name=ylab,limits=c(from_age, to_age), breaks=from_age:to_age,expand = c(0,0)) 
  lex <- lex + scale_x_date(name=xlab,limits=c(from_year.d,to_year.d),breaks = date_breaks("year"),labels = date_format("%Y"),expand = c(0,0)) 
  lex <- lex + geom_segment(aes(x=seq(yyseq.d[1],to_year.d,"year"), xend=seq(from_year.d,yyseq.d[length(yyseq.d)],"year"),y=aseq[1],yend=aseq[length(aseq)])) 
  lex <- lex + geom_segment(aes(x=seq(from_year.d, to_year.d,"year"),xend=seq(from_year.d, to_year.d,"year"), y=aseq[length(aseq)],yend=aseq[1])) 
  lex <- lex + geom_segment(aes(x=from_year.d, xend=to_year.d, y=aseq[1]:aseq[length(aseq)],yend=aseq[1]:aseq[length(aseq)]))
  lex <- lex + ggtitle(title)
  
  ##### plot year #####
  if (!missing(year)) {
    x_coord <- c(year, year+1, year+1, year)
    y_coord <- c(aseq[1], aseq[1], aseq[length(aseq)],aseq[length(aseq)])
    coord <- data.frame(x_coord=as.Date(paste("01/01/",x_coord,sep=""), "%d/%m/%Y"), y_coord)
    lex <- lex + geom_polygon(data=coord,aes(x=x_coord,
                                             y=y_coord),
                              fill=year_col,
                              alpha=0.5)
  }
  ##### plot cohort #####
  if (!missing(cohort)) {
    x_coord  <- c(cohort,cohort+1,cohort+1+adist,cohort+adist)
    y_coord <- c(aseq[1], aseq[1], aseq[length(aseq)],aseq[length(aseq)])
    coord <- data.frame(x_coord=as.Date(paste("01/01/",x_coord,sep=""), "%d/%m/%Y"), y_coord)
    lex <- lex + geom_polygon(data=coord,aes(x=x_coord,
                                             y=y_coord),
                              fill=cohort_col,
                              
                              alpha=0.5)  
  }
  
  #####plot age #####
  if (!missing(age)) {
    x_coord <- c(from_year, to_year, to_year, from_year)
    y_coord <- c(age, age, age+1, age+1)
    coord <- data.frame(x_coord=as.Date(paste("01/01/",x_coord,sep=""), "%d/%m/%Y"), y_coord)
    lex <- lex + geom_polygon(data=coord,aes(x=x_coord,
                                             y=y_coord),
                              fill=age_col,
                              alpha=0.5)  
    
  } 
  
  ##### plot lifelines #####
  if (!missing(lifelines)) {
    for (i in 1:length(lifelines)) {
      ll <- matrix(lifelines[[i]], ncol=3, byrow=TRUE)      
      ll_df <- data.frame(start=as.Date(ll[,2],"%d/%m/%Y"),
                          born=as.Date(ll[,1],"%d/%m/%Y"), 
                          end=as.Date(ll[,3],"%d/%m/%Y"))
      ll_df <- data.frame(ll_df,
                          start_age= as.numeric(difftime(ll_df$start,ll_df$born)/364.25),
                          end_age= as.numeric(difftime(ll_df$end,ll_df$born)/364.25))
      lex <- lex + geom_segment(data=ll_df, aes(x=start,xend=end,y=start_age,yend=end_age),
                                col=ll_col, size=1)
    }
  }
  
  ##### plot polygons #####
  if (!missing(polygon)) {
    #pg <- matrix(polygon, ncol=8, byrow=TRUE)
    for (i in 1:length(polygon)) {
      pg_df <- data.frame(x1=as.Date(polygon[[i]][1],"%d/%m/%Y"),
                          x2=as.Date(polygon[[i]][2],"%d/%m/%Y"),
                          x3=as.Date(polygon[[i]][3],"%d/%m/%Y"),
                          x4=as.Date(polygon[[i]][4],"%d/%m/%Y"),
                          y1=as.numeric(polygon[[i]][5]),
                          y2=as.numeric(polygon[[i]][6]),
                          y3=as.numeric(polygon[[i]][7]),
                          y4=as.numeric(polygon[[i]][8]))
      lex <- lex + geom_polygon(data=pg_df, aes(x=c(x1,x2,x3,x4),
                                                y=c(y1,y2,y3,y4)),
                                fill=poly_col, alpha=0.5)
    }
    
  }
  
  ##### return #####
  return(lex + theme(aspect.ratio=(to_age-from_age)/(to_year-from_year)))
}

