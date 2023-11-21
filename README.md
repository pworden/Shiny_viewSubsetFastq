# Shiny App - viewSubsetFasq

---

## Summary - View and subset FASTQ read lengths

This Shiny app allows users to upload a FASTQ file, analyze the distribution of read lengths - including changing the maximum and minimum read lengths visible, and then download subsets of the original FASTQ file in both FASTQ and FASTA formats.

This Shiny app, written in R, is to visualiz read lengths from a FASTQ file via a histogram of read lengths. The maximum and minimum read lengths defined by the user can then serve as parameters to subset a fastq and/or fasta file.

---

## Setup

This app should run in any Windows, Mac, or Linux machine (with capacity for a user interface). You will need to install into R the following packages, or the R-environment that you are using (if on a server).

If installing into a conda R-environment. See instructions here. </br>
<https://astrobiomike.github.io/R/managing-r-and-rstudio-with-conda>

Or create a conda environment and install R and some basic R-packages. Then install those packages required by this Shiny app.

```R
# Create the conda environment
conda create --name r-base
# Activate the r-base conda environment
conda activate r-base
# Install a number of base R packages
conda install -c conda-forge r-base
```

### Required R-packages - Install through conda

Required R-packages:

* Shiny
* ggplot2
* Biostrings
* ShortRead

To install the necessary R-packages through conda, first activate the R conda environment which will be running the ***Shiny app***, then install all these four R-packages through conda, as below.

```R
# First activate your target conda environment
# eg. conda activate r-base

conda install -c conda-forge r-shiny
conda install -c conda-forge r-ggplot2
conda install -c bioconda bioconductor-biostrings
conda install -c biobuilds bioconductor-shortread
```

### Required R-packages - direct install into R (or an R-environment)

* **(i.e. not through conda)**

Sometimes a conda install of an R-package will fail but these packages can also be installed through R, Whether using a desktop/laptop computer or a server.

* Shiny
* ggplot2
* Biostrings
* ShortRead

The Biostrings and ShortRead R-packages are required by this script but to install directly into the R environment (i.e. if not using the conda installer) you will first need to install the *Bioconductor* R-package, followed by the package you need.

On a server Biostrings can be installed your target R environment by activating this environment, starting R on the server (type "R" and then enter), entering the code below, and then pressing enter to run. This loads in the BiocManager which then installs "Biostrings".

```R
if (!require("BiocManager", quietly = TRUE))
  install.packages("BiocManager")

BiocManager::install("Biostrings")
```

For the ShortRead R-package enter the following:

```R
if (!require("BiocManager", quietly = TRUE))
  install.packages("BiocManager")

BiocManager::install("ShortRead")
```

The remaining packages, ***Shiny*** and ***ggplot2***, can be installed like most R-packages:

```R
install.packages("Shiny")
install.packages("gglot2")
```

---

## Shiny App code summary

### R-Packages

* Shiny
* ggplot2
* Biostrings
* ShortRead

The necessary R packages for this App to work are those listed above. *Shiny* for creating the web application, *ggplot2* for creating plots, *Biostrings* for working with biological sequences, and *ShortRead* for reading FASTQ files.

## Set Maximum Upload Size

This line sets the maximum file upload size to 50 megabytes.

```R
# Set the maximum upload size to 30 MB
options(shiny.maxRequestSize = 50 * 1024^2)
```

### User Interface (UI)

The UI is defined using the Shiny framework. It includes a title panel, a sidebar layout with file input, sliders, text inputs, action buttons, and download buttons, and a main panel displaying a plot.

```R
ui <- fluidPage(
  # ... (UI components)
)
```

### Server Logic

The server function contains the logic for the Shiny app. It includes reactive values, event observers, and output definitions.

```R
server <- function(input, output, session) {
  # ... (Server logic)
}
```

### Reactive Values

These reactive values store the data frames for read lengths, filtered read lengths, and the original FASTQ data, respectively.

```R
data <- reactiveVal(NULL)
filtered_data <- reactiveVal(NULL)
fastq_data <- reactiveVal(NULL)
```

### Event Observers

* File Selection Observer:
  * Reads the selected FASTQ file and updates relevant UI components.
* Length Slider Observer:
  * Updates text inputs based on the selected range on the length slider.
* Update Button Observer:
  * Filters read lengths based on user-defined minimum and maximum values.
  * Updates the length slider and resets text inputs.

### Plot Output

This output renders a histogram plot of the read lengths using ggplot2.

```R
output$readLengthPlot <- renderPlot({
  # ... (Plot rendering logic)
})
```

### Download Handlers

These output functions define download handlers for generating and downloading subsetted FASTQ and FASTA files based on user-selected read length ranges.

```R
output$downloadFastqBtn <- downloadHandler(
  # ... (Download FASTQ file logic)
)

output$downloadFastaBtn <- downloadHandler(
  # ... (Download FASTA file logic)
)
```

### Run Shiny App

This line runs the Shiny app, combining the UI and server logic.

```R
shinyApp(ui, server)
```
