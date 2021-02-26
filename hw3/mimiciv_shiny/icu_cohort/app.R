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
library(shinydashboard)
library(formattable)
library(qwraps2)

icu_cohort <- readRDS("/Users/bensonwu/Documents/UCLA/2020-2021/Winter 2021/BIOSTAT_203B/biostat-203b-2021-winter/hw3/mimiciv_shiny/icu_cohort.rds")
icu_cohort$insurance <-factor(icu_cohort$insurance)
# Define UI for application that draws a histogram
ui <- fluidPage(theme = shinytheme("cerulean"),

    # Application title
    titlePanel("ICU Cohort Data"),

    # Sidebar with a slider input for number of bins 
    sidebarLayout(
        sidebarPanel(
            h3("Select the inputs"),
            selectInput(inputId = "var_cat",
                        label = "Choose category",
                        choices = variable_categories, 
                        selected = "Demographic"),
            selectInput(inputId = "variables", 
                        label = "Choose variable", 
                        choices = demographic_variables,
                        selected = "Insurance status")
        ),

        # Show a plot of the generated distribution
        mainPanel(
           h2("Summary of the variable"),
           verbatimTextOutput("sum"),
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
  
    output$sum <- renderPrint({

      #Continuous
      if(input$variables %in% continuous_variables){
        table<-summary(icu_cohort[[input$variables]])
        formattable(table)
      }
      
      #Categorical
      else if(input$variables %in% categorical_variables){
        table<-table(icu_cohort[[input$variables]], useNA = "ifany")
        formattable(table)
      }
    })
    
    
    
    
    
    output$histogram <- renderPlot({
      #If/if else loop to determine what category we're in
      #This will allow the the labs() option to call on the correct x label
      #Solution for reactive xlabel names: https://community.rstudio.com/t/reactive-axis-labels-in-shiny-with-ggplot-display-user-selected-label-not-variable-name/17560/2
      if (input$var_cat=="Demographic"){
        xlabel<-names(demographic_variables[which(demographic_variables == input$variables)])
      } else if (input$var_cat=="Admission"){
        xlabel<-names(admission_variables[which(admission_variables == input$variables)])
      } else if (input$var_cat=="Lab measurements"){
        xlabel<-names(lab_variables[which(lab_variables == input$variables)])
      } else {
        xlabel<-names(vitals_variables[which(vitals_variables == input$variables)])
      }
      
      #GENERATE PLOTS
      #Continuous
      if(input$variables %in% continuous_variables){
        ggplot(icu_cohort, aes_string(x=input$variables)) + 
          geom_histogram(aes(y=..density..)) + labs(x=xlabel)
      }
      #Categorical
      else if(input$variables %in% categorical_variables){
        ggplot(icu_cohort) + 
          geom_bar(aes_string(x=input$variables)) + 
          labs(x=xlabel)
      }
    })
}

# Run the application 
shinyApp(ui = ui, server = server)
