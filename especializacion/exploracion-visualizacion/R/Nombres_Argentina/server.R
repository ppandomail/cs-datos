#
# This is the server logic of a Shiny web application. You can run the
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)

# Define server logic required to draw a histogram

shinyServer(function(input, output) {

  output$Grafico_por_anio <- renderPlotly({
      
    grafico1 <- nomres_arg %>%
      filter(
        nombre %in% input$nombre_filtro,
        anio >= min(input$anio_filtro), 
        anio <= max(input$anio_filtro)
      )
    
    ggplotly(
      ggplot(
          data = grafico1,
          mapping = aes(x = anio, y = cantidad, fill = nombre)
        ) +
        geom_col(position = "stack") +
        theme_classic()
    )
  })
  
  output$Nube_de_palabras <- renderPlot({
      
    grafico1 <- nomres_arg %>%
      filter(
          anio >= min(input$anio_filtro), 
          anio <= max(input$anio_filtro)
      ) %>%
      group_by(nombre) %>%
      summarise(cantidad = sum(cantidad)) %>%
      arrange(desc(cantidad)) %>%
      head(10)
    
    ggplot(data = grafico1,
         mapping = aes(
             label = nombre,
             size = cantidad,
             color = factor(sample.int(10, nrow(grafico1), replace = TRUE)),
             angle = 90 * sample(c(0, 1), nrow(grafico1), replace = TRUE, prob = c(60, 40))
         )
    ) +
      geom_text_wordcloud_area() +
      scale_size_area(max_size = 15) +
      theme_minimal()         
  })
})
