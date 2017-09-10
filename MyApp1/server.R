
library(shiny)

shinyServer(function(session, input, output) {
    
    prediction <- reactive({predict.word(input$text)})
    
    output$word1 <- renderText({
        prediction()[1]
    })
    
    output$word2 <- renderText({
        prediction()[2]
    })
    
    output$word3 <- renderText({
        prediction()[3]
    })
    
    observeEvent(input$choice1, {
        addText <- paste(input$text,  prediction()[1])
        updateTextInput(session, "text", value = addText)
    })
    
    observeEvent(input$choice2, {
        addText <- paste(input$text,  prediction()[2])
        updateTextInput(session, "text", value = addText)
    })
    
    observeEvent(input$choice3, {
        addText <- paste(input$text,  prediction()[3])
        updateTextInput(session, "text", value = addText)
    })
    
})
