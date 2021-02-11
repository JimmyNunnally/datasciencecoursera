#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#
library(shiny)

# Define UI for miles per gallon app ----

ui <- fluidPage(
  
  # App title ----
  titlePanel("Best Ramen"),
  
  # Sidebar layout with input and output definitions ----
  sidebarLayout(
    
    # Sidebar panel for inputs ----
    sidebarPanel(
      
      # Input: Selector for variable to plot against stars ----
      
      selectInput("variable", "Variable:",
                  c("Style" = "Style",
                    "Country" = "Country")),
                    
      
      # Input: Checkbox for whether outliers should be included ----
      checkboxInput("outliers", "Show outliers", TRUE)
      
    ),
    
    # Main panel for displaying outputs ----
    mainPanel(
      
      # Output: Formatted text for caption ----
      h3(textOutput("caption")),
      
      # Output: Plot of the requested variable vs star rating ----
      plotOutput("RamenPlot")
      
    )
  )
)


# Define server logic to plot various variables against mpg ----
server <- function(input, output) {
  RamenData <- read.csv(file = "ramen-ratings.csv")
  RamenData$Stars<-as.numeric(RamenData$Stars)  
  # Compute the formula text ----
  # This is in a reactive expression since it is shared by the
  # output$caption and output$mpgPlot functions
  formulaText <- reactive({
    paste("Stars ~", input$variable)
  })
  
  # Return the formula text for printing as a caption ----
  output$caption <- renderText({
    formulaText()
  })
  
  # Generate a plot of the requested variable against mpg ----
  # and only exclude outliers if requested
  output$RamenPlot <- renderPlot({
    boxplot(as.formula(formulaText()),
            data = RamenData,
            outline = input$outliers,
            col = "#75AADB", pch = 19)
  })
  
}
# Run the application 
shinyApp(ui = ui, server = server)




