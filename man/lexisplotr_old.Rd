\name{lexisplotr}
\alias{lexisplotr}
%- Also NEED an '\alias' for EACH other topic documented here.
\title{
Plot a Lexis Diagram.
}
\description{
lexisplotr is an easy to use function to plot Lexis Diagrams. 
}
\usage{
lexisplotr(from_year, to_year, from_age, to_age,
            cohort, year, age, lifelines, polygon, 
            xlab = "Year", ylab = "Age", 
            year_col = "red", cohort_col = "green", age_col = "blue", ll_col = "blue",
            poly_col = "grey", 
            title = "Lexis Diagram")
}
%- maybe also 'usage' for other objects documented here.
\arguments{
  \item{from_year}{
integer, set the year the Lexis Diagram starts with (January 1st).
}
  \item{to_year}{
integer, set the year the Lexis Diagram ends with (January 1st).
}
  \item{from_age}{
integer, set the age the Lexis Diagram starts with.
}
  \item{to_age}{
integer, set the age the Lexis Diagram ends with.
}
  \item{cohort}{
integer, set a cohort to emphasize.
}
  \item{year}{
integer, set a year to emphasize.
}
  \item{age}{
integer, set an age to emphasize.
}
  \item{lifelines}{
list, set lifelines to be drawn. The list contains each lifeline as a vector specifying 
the date of birth of the respective person, the date of the beginning of the 
observation and the date of the end of the observation. Dates in format 
\code{"dd/mm/yyyy"}.
}
  \item{polygon}{
list, set polygons to be drawn. The list contains each lifeline as a vector 
specifying the coordinates of the polygon. The vector contains the coordinates 
on the x-axis (dates) followed by the coordintes of the y-axis (integer). 
Dates in format \code{"dd/mm/yyyy"}.
}
  \item{xlab}{
character, set the label for the x-axis. Default: "Year".
}
  \item{ylab}{
character, set the label for the y-axis. Default: "Age".
}
  \item{year_col}{
character, set the colour used to emphasize \code{year}. Default: \code{"red"} with 
\code{alpha=0.5}.
}
  \item{cohort_col}{
character, set the colour used to emphasize \code{cohort}. Default: \code{"green"} 
with \code{alpha=0.5}.
}
  \item{age_col}{
character, set the colour used to emphasize \code{age}. Default: \code{"blue"} with 
\code{alpha=0.5}.
}
  \item{ll_col}{
character, set the colour used for \code{lifelines}. Default: \code{"blue"}.
}
  \item{poly_col}{
character, set the colour used for \code{polygons}. Default: \code{"grey"}.
}
  \item{title}{
character, title of the plot. Default: "Lexis Diagram".
}
}
\details{
Required date format: \code{"dd/mm/yyyy"}.

The function determines the aspect ratio of the x- and y-axis to enforce isosceles 
triangles. The aspect ratio will not be effected by defining \code{width} and 
\code{height} in \code{pdf()} or other graphic devices.

Because the returned object is a ggplot2 graph, the overall appearence of the graph 
can be edited by adding e.g. \code{themes()} to the plot.
}
\value{
The functions returns a ggplot2-plot.
}
\references{
%% ~put references to the literature/web site here ~
}
\author{
Philipp Ottolinger
}
\note{
To save the plot, using \code{pdf()} is recommended since it will achieve good results 
and avoid overlapping in most cases. Unix users may use \code{x11()} to start a new 
graphical device to preview the plot.
}
\seealso{
%% ~~objects to See Also as \code{\link{help}}, ~~~
\code{\link{ggplot2}}
}
\examples{
## Plot a Lexis Diagram grid
lexisplotr(from_year=1900, to_year=1905, from_age=0, to_age=5)

## Emphasize a certain cohort, year and age
lexisplotr(from_year=1900, to_year=1905, from_age=0, to_age=5,
           cohort=1901, year=1903, age=2)
           
## Plot lifelines
lexisplotr(from_year=1900, to_year=1905, from_age=0, to_age=5,
           lifelines=list(c("03/03/1900","01/07/1900","27/06/1901"),
                          c("01/06/1900","01/01/1901","31/12/1903"),
                          c("23/09/1902","23/09/1902","31/12/1904")))
                          
## Emphasize a certain Lexis Triangle
lexisplotr(from_year=1900, to_year=1905, from_age=0, to_age=5,
           polygon=list(c("01/01/1901","31/12/1901","31/12/1901","01/01/1901",1,1,2,1))
           
## Change the size of the axis texts
#lexis <- lexisplotr(from_year=1900, to_year=1905, from_age=0, to_age=5)
#lexis <- lexis + theme(axis.text = element_text(size=10))
#lexis

## Save the plot to pdf
#pdf("LexisDiagram.pdf")
#lexisplotr(from_year=1900, to_year=1905, from_age=0, to_age=5)
#dev.off()
}
\keyword{hplot}
