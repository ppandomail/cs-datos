library(shiny)

paises <- read.csv("paises.csv", sep =";")

ui <- fluidPage(

    # Application title
    titlePanel("Dataset: Países - Variable: Tasa de Crecimiento"),

    # Sidebar with a slider input for number of bins 
    sidebarLayout(
        sidebarPanel(
            sliderInput("bins",
                        "Number of bins:",
                        min = 1,
                        max = 50,
                        value = 30)
        ),

        # Show a plot of the generated distribution
        mainPanel(
           plotOutput("distPlot")
        )
    )
)

# Define server logic required to draw a histogram
server <- function(input, output) {

    output$distPlot <- renderPlot({
        # generate bins based on input$bins from ui.R
        x <- na.omit(paises$Tasa_de_crecimiento)
        bins <- seq(min(x), max(x), length.out = input$bins + 1)

        # draw the histogram with the specified number of bins
        ggplot(paises, aes(Tasa_de_crecimiento)) +
        geom_histogram(colour = "darkgreen", fill = "white", breaks = bins) +
          theme_bw()
    })
}

# Run the application 
shinyApp(ui = ui, server = server)
