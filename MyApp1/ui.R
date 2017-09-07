library(shiny)

shinyUI(
    navbarPage(
        title = "",
        windowTitle = "",
        tabPanel(
            "Documentation (how to use the app)",
            fluidPage(
                fluidRow(
                    column(
                        10,
                        wellPanel()
                    )
                )
            )
        ),
        tabPanel(
            "The App itself",
            fluidPage(
                titlePanel(title = ""),
                hr(),
                sidebarLayout(
                    sidebarPanel(
                        textInput("text", label = h3("Text input"), value = "")
                    ),
                    mainPanel(
                        textOutput("prediction")
                    )
                )
            )
        )
    )
)