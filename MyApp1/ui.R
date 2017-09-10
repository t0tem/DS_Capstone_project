library(shiny)

shinyUI(
    navbarPage(
        title = div(img(src="logo1.png", style="margin-top: -38px;", height = 100)),
        windowTitle = "",
        collapsible = TRUE,
        tabPanel(
            "App",
            fluidPage(
                titlePanel(title = ""),
               
                    wellPanel(
                        #style creadits to jtleek's Papr https://github.com/jtleek/papr/tree/master/www
                        style = "box-shadow: 0 4px 8px 0 rgba(0,0,0,0.2);
                        padding: 8px;
                        border: 1px solid #ccc;
                        border-radius: 5px;
                        max-width: 800px;
                        margin: 0 auto;",
                        
                        
                        textAreaInput("text", label = "Text input", value = "", 
                                      resize="vertical", rows = 2,
                                      placeholder = "type here..."),
                        
                        actionButton("choice1", label = textOutput("word1")),
                        actionButton("choice2", label = textOutput("word2")),
                        actionButton("choice3", label = textOutput("word3"))
                        
                    )
                    
               
            )
        ),
        tabPanel(
            "How does it work?",
            fluidPage(
                fluidRow(
                    column(
                        10,
                        wellPanel()
                    )
                )
            )
        )
    )
)