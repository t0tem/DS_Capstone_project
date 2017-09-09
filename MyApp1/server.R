
library(shiny)

shinyServer(function(input, output) {
   
  output$word1 <- renderText({
      text <- input$text
      predict.word(text)[1]
  })
  
  output$word2 <- renderText({
      text <- input$text
      predict.word(text)[2]
  })
  
  output$word3 <- renderText({
      text <- input$text
      predict.word(text)[3]
  })
   
  
})
