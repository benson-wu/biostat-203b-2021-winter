library(shiny)
library(tidyverse)
library(stringr)
library(rsconnect)
library(shinythemes)
library(plotly)
crime_master<-structure(list(ROADACCIDENT = c(142.69999694825, 120.40000152588, 
                                130.19999694825, 155.10000610352, NA, 181.10000610352, 54.20000076294, 
                                118.09999847413, 85.19999694825, 112.40000152588), CRIMESHARE = c(3142, 
                                                                                                  1695, 1554, 2806, 3368, 3164, 1359, 2013, 711, 2446), MURDER = c(267, 
                                                                                                                                                                   605, 309, 185, 65, 590, 93, 631, 501, 138), NAME = c("Khabarovsk Krai", 
                                                                                                                                                                                                                        "Chelyabinsk Oblast", "Novosibirsk Oblast", "Amur Oblast", "Magadan 
Oblast", 
                                                                                                                                                                                                                        "Krasnoyarsk Krai", "Karachay-Cherkess Republic", "Moscow", "Moscow", 
                                                                                                                                                                                                                        "Kostroma Oblast"), ID = c(29, 13, 49, 5, 41, 36, 26, 44, 44, 
                                                                                                                                                                                                                                                   34), YEAR = c(2009, 1992, 1990, 2007, 2001, 2007, 1999, 2009, 
                                                                                                                                                                                                                                                                 1991, 2000)), row.names = c(608L, 255L, 1009L, 102L, 852L, 753L, 
                                                                                                                                                                                                                                                                                             535L, 923L, 905L, 704L), class = "data.frame")
data(crime_master)
crime_plot <- crime_master

ui <- fluidPage(theme = shinytheme("cerulean"),
                
                titlePanel("My title"),
                
                sidebarLayout( 
                  sidebarPanel( 
                    
                    h3("Select the inputs"),
                    selectInput(inputId = "y", 
                                label = "Indicator to display on Y-axis", 
                                choices = c("Road accidents", 
                                            "Crime share", 
                                            "Murders"), 
                                selected = "Road accidents"),
                    
                    selectizeInput(inputId = "region", 
                                   label = "Select regions", 
                                   choices = c(crime_plot$NAME), 
                                   multiple = TRUE,
                                   options = list(maxItems = 5))), 
                  mainPanel(
                    h3("Plot indicators over time"),
                    plotlyOutput(outputId = "scatterplot"))))

server <- function(input, output){
  
  regions_subset <- reactive({ 
    filter(crime_plot, NAME %in% input$region)
  })
  
  output$scatterplot <- renderPlotly({
    yvarnames <- c("ROADACCIDENT","CRIMESHARE","MURDER")
    ggplotly(ggplot(data = regions_subset(), 
                    aes_string(x = "YEAR", y = yvarnames[input$y], color = "NAME")) + 
               geom_point() + 
               labs(x = "Year", y = input$y) +
               theme(text=element_text(size=10), axis.text.y=element_text(angle=90, hjust=1)) +
               scale_color_discrete(name = "Regions"))
  })
  
  output$event <- renderPrint({
    k <- event_data("plotly_hover")
    if (is.null(k)) "Hover on a point!" else d})}

shinyApp(ui = ui, server = server)

# Run the application 
shinyApp(ui = ui, server = server)
