#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)

# Define UI for application that draws a histogram
shinyUI(fluidPage(

    # Application title
    titlePanel("Nombres de Argentina"),

    # Sidebar with a slider input for number of bins
    sidebarLayout(
        sidebarPanel(
            selectInput("nombre_filtro", 
                        label = "Selecciona Nombre", 
                        choices = nombres, 
                        selected = c("Juan","Maria"),
                        multiple = TRUE),
            
            sliderInput("anio_filtro", 
                        label = "Selecciona Anio",
                        min = 1922, 
                        max = 2015, 
                        value = c(2000, 2010))
        ),

        # Show a plot of the generated distribution
        mainPanel(
          plotlyOutput("Grafico_por_anio"),
          plotOutput("Nube_de_palabras")
        )
    )
))

