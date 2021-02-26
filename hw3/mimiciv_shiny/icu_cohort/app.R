#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

#The app should provide easy access to the graphical and numerical summaries of 
#variables (demographics, lab measurements, vitals) in the ICU cohort.
source("generate_vals.R")

library(shiny)
library(ggplot2)
library(plotly)

# Define UI for application that draws a histogram
ui <- fluidPage(

    # Application title
    titlePanel("ICU Cohort Data"),

    # Sidebar with a slider input for number of bins 
    sidebarLayout(
        sidebarPanel(
            selectInput("var_cat","Choose category",
                         variable_categories),
            selectInput("variables", "Choose variable", 
                        demographic_variables)
        ),

        # Show a plot of the generated distribution
        mainPanel(
           plotOutput("histogram")
        )
    )
)

# Define server logic required to draw a histogram
server <- function(input, output, session) {
  observeEvent(input$var_cat,
               {
                 if (input$var_cat=="Demographic"){
                   updateSelectizeInput(session, input = "variables",
                                        choices = demographic_variables,
                                        selected = "Insurance status")
                
                 } else if (input$var_cat=="Admission"){
                   updateSelectizeInput(session, input = "variables",
                                        choices = admission_variables, 
                                        selected = "First care unit")
                 } else if (input$var_cat=="Lab measurements"){
                   updateSelectizeInput(session, input = "variables",
                                        choices = lab_variables, 
                                        selected = "Bicarbonate")
                 } else {
                   updateSelectizeInput(session, input = "variables",
                                        choices = vitals_variables, 
                                        selected = "Heart rate")
                 }
               })
    output$histogram <- renderPlot({
        # generate bins based on input$bins from ui.R
        # x    <- icu_cohort$los
        # bins <- seq(min(x), max(x), length.out = input$bins + 1)
        # 
        # # draw the histogram with the specified number of bins
        # hist(x, breaks = bins, col = 'darkgray', border = 'white')
        ggplot(icu_cohort, aes_string(input$variables)) + geom_histogram(aes(y=..density..)) + 
          labs(x=input$variables) 
    })
}

# Run the application 
shinyApp(ui = ui, server = server)
