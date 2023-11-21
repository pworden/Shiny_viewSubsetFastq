# Load required libraries
library(shiny)
library(ggplot2)
library(Biostrings)
library(ShortRead)

# Set the maximum upload size to 30 MB
options(shiny.maxRequestSize = 30 * 1024^2)

# Define the UI
ui <- fluidPage(
  titlePanel("FASTQ Read Lengths Analysis"),
  
  sidebarLayout(
    sidebarPanel(
      fileInput("file", "Choose a FASTQ file"),
      sliderInput("lengthSlider", "Read Length Range", min = 0, max = 0, value = c(0, 0)),
      textInput("minLengthInput", "Min Length", value = ""),
      textInput("maxLengthInput", "Max Length", value = ""),
      actionButton("updateBtn", "Update"),
      downloadButton("downloadFastqBtn", "Download Subset FASTQ"),
      downloadButton("downloadFastaBtn", "Download Subset FASTA")
    ),
    
    mainPanel(
      plotOutput("readLengthPlot")
    )
  )
)

# Define the server logic
server <- function(input, output, session) {
  data <- reactiveVal(NULL)
  filtered_data <- reactiveVal(NULL)
  fastq_data <- reactiveVal(NULL)
  
  observeEvent(input$file, {
    inFile <- input$file
    if (!is.null(inFile) && tolower(substr(inFile$name, nchar(inFile$name) - 5, nchar(inFile$name))) == ".fastq") {
      fastq_data(readFastq(inFile$datapath))
      read_lengths <- width(fastq_data())
      query_min_length <- min(read_lengths)
      query_max_length <- max(read_lengths)
      updateSliderInput(session, "lengthSlider", min = query_min_length, max = query_max_length, value = c(query_min_length, query_max_length))
      data(data.frame(ReadLength = read_lengths))
      filtered_data(data())
    }
  })
  
  observe({
    req(input$lengthSlider)
    updateTextInput(session, "minLengthInput", value = input$lengthSlider[1])
    updateTextInput(session, "maxLengthInput", value = input$lengthSlider[2])
  })
  
  observeEvent(input$updateBtn, {
    req(input$minLengthInput, input$maxLengthInput)
    min_length <- as.numeric(input$minLengthInput)
    max_length <- as.numeric(input$maxLengthInput)
    filtered <- data()$ReadLength[data()$ReadLength >= min_length & data()$ReadLength <= max_length]
    filtered_data(data.frame(ReadLength = filtered))
  })
  
  output$readLengthPlot <- renderPlot({
    req(filtered_data())
    ggplot(filtered_data(), aes(x = ReadLength)) +
      geom_histogram(binwidth = 1, colour = "black", fill = "grey80") +
      labs(title = "Read Length Distribution", x = "Read Length", y = "Frequency")
  })
  
  observeEvent(input$updateBtn, {
    req(input$minLengthInput, input$maxLengthInput)
    min_length <- as.numeric(input$minLengthInput)
    max_length <- as.numeric(input$maxLengthInput)
    updateSliderInput(session, "lengthSlider", value = c(min_length, max_length))
  })
  
  observeEvent(input$updateBtn, {
    updateTextInput(session, "minLengthInput", value = "")
    updateTextInput(session, "maxLengthInput", value = "")
  })
  
  output$downloadFastqBtn <- downloadHandler(
    filename = function() {
      paste0("subsetted_file_", input$lengthSlider[1], "-", input$lengthSlider[2], ".fastq")
    },
    content = function(file) {
      req(data(), fastq_data())
      subset_fastq <- fastq_data()[width(fastq_data()) >= input$lengthSlider[1] & width(fastq_data()) <= input$lengthSlider[2]]
      writeFastq(subset_fastq, file, compress = FALSE)
    }
  )
  
  output$downloadFastaBtn <- downloadHandler(
    filename = function() {
      paste0("subsetted_file_", input$lengthSlider[1], "-", input$lengthSlider[2], ".fasta")
    },
    content = function(file) {
      req(data(), fastq_data())
      subset_fastq <- fastq_data()[width(fastq_data()) >= input$lengthSlider[1] & width(fastq_data()) <= input$lengthSlider[2]]
      writeFasta(subset_fastq, file, compress = FALSE)
    }
  )
}

# Run the Shiny app
shinyApp(ui, server)


