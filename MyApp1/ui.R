library(shiny)

shinyUI(
    navbarPage(
        title = div(img(src="logo2.png", style="margin-top: -38px;", height = 100)),
        windowTitle = "NextWordio - it helps you to type",
        collapsible = TRUE,
        
        tabPanel(
            "App",
            fluidPage(
                tags$head(
                    tags$link(rel = "icon", type = "image/png", href = "icon.png"),
                    #tags$style(HTML("@import url('//fonts.googleapis.com/css?family=Lobster');")),
                    tags$style(HTML("@import url('//fonts.googleapis.com/css?family=Permanent Marker');")),
                    tags$style(HTML("@import url('//fonts.googleapis.com/css?family=Indie Flower');"))),
                titlePanel(title = ""),
                
                wellPanel(
                    #style creadits to jtleek's Papr https://github.com/jtleek/papr/tree/master/www
                    style = "box-shadow: 0 4px 8px 0 rgba(0,0,0,0.2);
                        padding: 8px;
                        border: 1px solid #ccc;
                        border-radius: 5px;
                        max-width: 800px;
                        margin: 0 auto;",
                    
                    p(strong(em("welcome to")), align = "center", 
                      style = "font-size: 18px; font-family: Indie Flower;"),
                    h2("NextWordio", align = "center", 
                       style = "font-size: 330%; font-family: Permanent Marker; margin-top: -22px;"),
                    p(strong(em("the app that predicts the next word as you type*")), align = "center",
                      style = "font-family: Indie Flower;"),
                    
                    textAreaInput("text", label = "", value = "", 
                                  resize="vertical", rows = 2,
                                  placeholder = "start typing something here..."),
                    p(em("Predicted words are shown below (leftmost is the most probable one)"), style = "font-size: 90%;"),
                    actionButton("choice1", label = textOutput("word1")),
                    actionButton("choice2", label = textOutput("word2")),
                    actionButton("choice3", label = textOutput("word3")),
                    helpText("you can click on one of them to add it to the text", style = "font-size: 90%;"),
                    helpText("* The only supported language so far is English", 
                             align = "right", style = "font-size: 80%")
                )
            )
        ),
        tabPanel(
            "How does it work?",
            fluidPage(
                wellPanel(
                    style = "box-shadow: 0 4px 8px 0 rgba(0,0,0,0.2);
                        padding: 8px;
                        border: 1px solid #ccc;
                        border-radius: 5px;
                        max-width: 800px;
                        margin: 0 auto;",
                    helpText("The present App serves as a capstone project on Coursera 
                             Data Science Specialization provided by Johns Hopkins University."),
                    helpText("The App works thanks to a built-in prediction algorithm 
                             based on", 
                             a("N-gram language model.", href="https://en.wikipedia.org/wiki/N-gram", target = "_blank")
                    ),
                    helpText("The model was built from a text ",
                             a("Corpus provided by Heliohost", 
                               href="https://web-beta.archive.org/web/20160930083655/http://www.corpora.heliohost.org/aboutcorpus.html", 
                               target = "_blank"),
                             "(i.e. 4 million lines of text collected from publicly available sources by a web crawler)."),
                    helpText("Text mining was applied to the Corpus using R programming 
                             language (see 'Credits' for packages used) to obtain several 
                             frequency tables of n-grams (all the way from 5- to 1-gram).
                             These tables feed the algorithm."),
                    helpText("Algorithm also makes use of a smoothing technique 
                             called \"Stupid backoff\" that was developed in Google in 2007. This technique doesn't generate 
                             normalized probabilities and instead uses the relative frequencies according to the
                             following rule:"),
                    #div(withMathJax("$$S(w_{i}|w^{i-1}_{i-k+1})=\\begin{cases}
                    #            \\frac{count(w^{i}_{i-k+1})}{count(w^{i-1}_{i-k+1})}&if count(w^{i}_{i-k+1})>0
                    #            \\\\0.4S(w_{i}|w^{i-1}_{i-k+2}) & otherwise
                    #            \\end{cases}$$"), width = "100%"),
                    #building formula manually makes it look nice on laptop, but ugly on mobile
                    #better put picture
                    div(img(src="sbo.png", width = "100%", style = "max-width: 400px;"), style = "text-align: center;"),
                    helpText("which means that if there is no matching n-gram found in the table
                             we 'back off' to the lower order (n-1)-gram applying a coefficient 0.4 to its' score.
                             While being quite simple to implement this technique proved to show a good
                             accuracy on high volumes of text.")
                )
            )
        ),
        tabPanel(
            "How accurate is it?",
            fluidPage(
                wellPanel(
                    style = "box-shadow: 0 4px 8px 0 rgba(0,0,0,0.2);
                        padding: 8px;
                        border: 1px solid #ccc;
                        border-radius: 5px;
                        max-width: 800px;
                        margin: 0 auto;")
            )
        ),
        tabPanel(
            "Who made it?",
            fluidPage(
                wellPanel(
                    style = "box-shadow: 0 4px 8px 0 rgba(0,0,0,0.2);
                        padding: 8px;
                        border: 1px solid #ccc;
                        border-radius: 5px;
                        max-width: 800px;
                        margin: 0 auto;")
            )
        ),
        tabPanel(
            "Credits",
            fluidPage(
                wellPanel(
                    style = "box-shadow: 0 4px 8px 0 rgba(0,0,0,0.2);
                        padding: 8px;
                        border: 1px solid #ccc;
                        border-radius: 5px;
                        max-width: 800px;
                        margin: 0 auto;")
            )
        )
    )
)