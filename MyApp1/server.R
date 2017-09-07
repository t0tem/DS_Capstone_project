
library(shiny)

shinyServer(function(input, output) {
   
  output$prediction <- renderPrint({
      text <- input$text
      predict.word(text)
  })
   
  
})
