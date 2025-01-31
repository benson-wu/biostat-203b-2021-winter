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
library(shinythemes)
library(shinydashboard)
library(tab)
library(Hmisc)
library(tidyverse)
library(shinyjs)
library(ggtext)
library(hrbrthemes)

options(scipen=10000)



# Define UI for application that draws a histogram
ui <- fluidPage(theme = shinytheme("cerulean"),
    useShinyjs(),
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
                        selected = "Insurance status"),
            radioButtons(inputId = "stratification",
                         label = 
                    "Stratify by patients who died within 30 days of admission",
                         choices = stratification_choices,
                         selected = "No"),
            sliderInput(inputId = "bins",
                        label = "Select number of bins", 
                        min=1, max=50, value=10, step=1)
            
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
  

  #Enable slider only for continuous variables
  value <- reactive(input$variables)
  observeEvent(value(), 
               {if(value() %in% categorical_variables){
                  shinyjs::disable("bins")
               }else{
                 shinyjs::enable("bins")
               }
                 }
  )
  
  #Print summary table
    output$sum <- renderPrint({
      #If no to stratifications
      if(input$stratification == "No"){
        #Continuous
        if(input$variables %in% continuous_variables){
          table<-summary(icu_cohort[[input$variables]])
          table
        }
        
        #Categorical
        else if(input$variables %in% categorical_variables){
          table<-table(icu_cohort[[input$variables]], useNA = "ifany")
          table
        }
      }
      #If yes to stratifications
      else{
        #Continuous
        if(input$variables %in% continuous_variables){
          table<-tapply(icu_cohort[[input$variables]], 
                        icu_cohort$died_within_30_days, summary)
          table
          
        }
        
        #Categorical
        else if(input$variables %in% categorical_variables){
          table<-table(icu_cohort[[input$variables]], 
                       icu_cohort$died_within_30_days, useNA = "ifany")
          table
        }
      }
    })
    
    
    
    
    
    output$histogram <- renderPlot({
      #If/if else loop to determine what category we're in
      #This will allow the the labs() option to call on the correct x label
      #Solution for reactive xlabel names: https://community.rstudio.com/t/reactive-axis-labels-in-shiny-with-ggplot-display-user-selected-label-not-variable-name/17560/2
      if (input$var_cat=="Demographic"){
        xlabel<-names(demographic_variables[which(demographic_variables == 
                                                    input$variables)])
      } else if (input$var_cat=="Admission"){
        xlabel<-names(admission_variables[which(admission_variables == 
                                                  input$variables)])
      } else if (input$var_cat=="Lab measurements"){
        xlabel<-names(lab_variables[which(lab_variables == input$variables)])
      } else {
        xlabel<-names(vitals_variables[which(vitals_variables == 
                                               input$variables)])
      }
      
      #GENERATE PLOTS
      #If no stratification
      if(input$stratification == "No"){
        #Continuous
        if(input$variables %in% continuous_variables){
          min<-quantile(icu_cohort[[input$variables]], c(0.25), na.rm=TRUE)
          max<-quantile(icu_cohort[[input$variables]], c(0.75), na.rm=TRUE)
          iqr<-max-min
          lower_fence<-min-(1.5*iqr)
          upper_fence<-max+(1.5*iqr)
          icu_cohort %>%
            ggplot(aes_string(x=input$variables)) + 
            geom_histogram(aes(y=..density..), bins = input$bins, 
                           colour="black", fill="blue", alpha=0.2) +
            labs(x=xlabel) +
            #Only display non-outlier values
            scale_x_continuous(limits = c(lower_fence, upper_fence)) +
            labs(caption = str_c(caption1, caption2, caption3)) + 
            theme(plot.caption = element_markdown(hjust = 0))
          
            
          
        }
        #Categorical
        else if(input$variables %in% categorical_variables){
          
          #Condition on categorical variables that have a lot of/long labels
          #so that we can graph the xlabels at an angle
          if(input$variables %in% many_categories_variables){
            icu_cohort %>% drop_na(input$variables) %>% 
              ggplot() + geom_bar(aes_string(x=input$variables),
                                  fill="blue", colour="black", alpha=0.2) + 
              theme(axis.text.x=element_text(angle=60,hjust=1)) +
              labs(x=xlabel)
          }
          else{
            icu_cohort %>% drop_na(input$variables) %>% 
              ggplot() + geom_bar(aes_string(x=input$variables),
                                  fill="blue", colour="black", alpha=0.2) + 
              labs(x=xlabel)
          }
          
        }
      }
      #If yes to stratification
      else{
        #Continuous
        if(input$variables %in% continuous_variables){
          min<-quantile(icu_cohort[[input$variables]], c(0.25), na.rm=TRUE)
          max<-quantile(icu_cohort[[input$variables]], c(0.75), na.rm=TRUE)
          iqr<-max-min
          lower_fence<-min-(1.5*iqr)
          upper_fence<-max+(1.5*iqr)
          icu_cohort %>%
            ggplot(aes_string(x=input$variables, color ="died_within_30_days", 
                              fill="died_within_30_days")) + 
            geom_histogram(aes(y=..density..), bins = input$bins,
                           alpha=0.4, position = 'identity') +
            labs(x=xlabel) +
            #Only display non-outlier values
            scale_x_continuous(limits = c(lower_fence, upper_fence)) +
            labs(caption = str_c(caption1, caption2, caption3)) + 
            theme(plot.caption = element_markdown(hjust = 0)) +
            guides(fill=guide_legend(title="Death status"), color = FALSE)
          
        }
        #Categorical
        else if(input$variables %in% categorical_variables){
          
          #Condition on categorical variables that have a lot of/long labels
          #so that we can graph the xlabels at an angle
          if(input$variables %in% many_categories_variables){
            icu_cohort %>% drop_na(input$variables) %>% 
              ggplot() + geom_bar(aes_string(x=input$variables, 
                                             fill="died_within_30_days"),
                                  position="dodge", alpha=0.6) + 
              theme(axis.text.x=element_text(angle=60,hjust=1)) +
              labs(x=xlabel) +
              guides(fill=guide_legend(title="Death status"), color = FALSE)
          }
          else{
            icu_cohort %>% drop_na(input$variables) %>% 
              ggplot() + geom_bar(aes_string(x=input$variables, 
                                             fill="died_within_30_days"),
                                  position="dodge", alpha=0.6) + 
              labs(x=xlabel) +
              guides(fill=guide_legend(title="Death status"), color = FALSE)
          }
        }
        
      }
    })
}

# Run the application 
shinyApp(ui = ui, server = server)
