# LexisPlotR


LexisPlotR is a tool to easily plot Lexis Diagrams. It is mainly based on Hadley Wickham's [ggplot2](https://github.com/hadley/ggplot2) and wraps necessary steps like drawing the grid, emphasizing certain areas or inserting lifelines in a single function.

![LexisPlotR_example](https://github.com/ottlngr/LexisPlotR/blob/master/LexisPlotR_example.png)

## Installation

You can install the latest version of **`LexisPlotR`** by using `install_github()` from the `devtools`-package:

    install.packages("devtools")
    library(devtools)
    install_github("ottlngr/LexisPlotR")
    library(LexisPlotR)