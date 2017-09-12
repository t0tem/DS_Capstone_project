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
                    p(strong(em("an app that predicts the next word as you type*")), align = "center",
                      style = "font-family: Indie Flower; font-size: 95%;"),
                    
                    textAreaInput("text", label = "", value = "", 
                                  resize="vertical", rows = 2,
                                  placeholder = "Start typing something here. For example \"I want to\""),
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
                    helpText("This App serves as a capstone project in Coursera 
                             Data Science Specialization provided by Johns Hopkins University.
                             SwiftKey - company developer of a predictive keyboard 
                             for Android and iOS acted as a corporate parner in this capstone, 
                             helping to formulate the real-world problematics behind the project idea."),
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
                             Being simplier to implement than classical techniques 
                             (such as Kneser–Ney smoothing or Good–Turing discounting) 
                             this technique proved to show a good accuracy on high volumes of text.")
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
                        margin: 0 auto;",
                    helpText("Accuracy of the algorithm has been measured with an independent ",
                             a("benchmarking tool.", 
                               href="https://github.com/hfoffani/dsci-benchmark", 
                               target = "_blank"),
                             " This tool goes through randomly selected 599 lines from blogs
                             and 793 lines of tweets generating >28000 next word predictions each time
                             comparing them to the real next word in text."),
                    helpText("Results are below:"),
                    div(img(src="Benchmark_result.png", width = "100%", style = "max-width: 500px;"), style = "text-align: center;"),
                    br(),
                    helpText("This means that ", strong("14.21%")," of time algorithm matches the correct
                             word with its' top-1 prediction.", strong("22.91%")," of time one of 
                             3 predicted words is correct. In the meantime each prediction takes only ",
                             strong("10-11 milliseconds"), " to run (which is quite fast) and 
                             uses only ", strong("146MB of RAM"), " on Shinyapps.io server."),
                    helpText("This result is one the highest reported on Coursera forum by the 
                             students of Data Science Specialization. For comparison 
                             SwiftKey's own industrial result is known to be around 30%.")
                )
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
                        margin: 0 auto;",
                    helpText("This app was made by"),
                    fluidRow(
                        column(
                            2, offset = 1,
                            img(src="Photo.jpg", width = "100%", style = "border-radius: 100%; max-width: 100px;")   
                        ),
                        column(
                            8,
                            p("Vadim KULAGIN", style = "font-size: 200%; 
                              font-family: Permanent Marker; margin-top: 18px; margin-bottom: -4px;"),
                            p(strong(em("a Data Scientist")), style = "font-size: 115%; font-family: Indie Flower;")
                        )
                    ),
                    br(),
                    helpText("Any feedback and contribution is welcome on ",
                             a("GitHub.", href = "https://github.com/t0tem/DS_Capstone_project", target = "_blank"), 
                             "You can also reach out to me on ", 
                             a("LinkedIn.", href = "https://www.linkedin.com/in/vadim-kulagin-7b892095/", target = "_blank"))
                )
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
                        margin: 0 auto;",
                    helpText("1. Data Science Specialization on ",
                             a("Coursera", 
                               href = "https://www.coursera.org/specializations/jhu-data-science", 
                               target = "_blank"),
                             "(and that's the",
                             a("dataset", 
                               href = "https://d396qusza40orc.cloudfront.net/dsscapstone/dataset/Coursera-SwiftKey.zip", 
                               target = "_blank"),
                             "used in the Capstone)."),
                    helpText("2. Glorious course instructors:",
                             a("Jeff Leek,", 
                               href = "https://www.coursera.org/instructor/~694443", 
                               target = "_blank"),
                             a("Roger D. Peng,", 
                               href = "https://www.coursera.org/instructor/rdpeng", 
                               target = "_blank"),
                             "and",
                             a("Brian Caffo.", 
                               href = "https://www.coursera.org/instructor/~688901", 
                               target = "_blank")),
                    helpText("3. Stanford lectures on Natural Language Procession by 
                             Professor Dan Jurafsky & Chris Manning on ",
                             a("Youtube.", 
                               href = "https://www.youtube.com/watch?v=nfoudtpBV68&list=PL4LJlvG_SDpxQAwZYtwfXcQr7kGnl9W93", 
                               target = "_blank")),
                    helpText("4. Modern information theory track on ",
                             a("KhanAcademy.", 
                               href = "https://www.khanacademy.org/computing/computer-science/informationtheory/moderninfotheory/v/symbol-rate-information-theory", 
                               target = "_blank")),
                    helpText("5.",
                             a("\"The Information\"", 
                               href = "https://www.amazon.com/Information-History-Theory-Flood/dp/1400096235", 
                               target = "_blank"),
                        "by James Gleick - an amazing book on Theory of Information."),
                    helpText("6.",
                             a("\"Large Language Models in Machine Translation\"", 
                               href = "http://www.aclweb.org/anthology/D07-1090.pdf", 
                               target = "_blank"),
                             "(Brants et al., 2007, Google Inc.) - a paper first 
                             introducing Stupid backoff method."),
                    helpText("7. Main R packages used on the project: ",
                             a("quanteda,", 
                               href = "http://quanteda.io/", 
                               target = "_blank"),
                             a("data.table,", 
                               href = "https://cran.r-project.org/web/packages/data.table/data.table.pdf", 
                               target = "_blank"),
                             a("shiny.", 
                               href = "https://shiny.rstudio.com/", 
                               target = "_blank")),
                    helpText("8.",
                             a("RStudio", 
                               href = "https://www.rstudio.com/", 
                               target = "_blank"),
                             "- the one and only IDE for R."),
                    helpText("9.",
                             a("Benchmarking tool", 
                               href = "https://github.com/hfoffani/dsci-benchmark", 
                               target = "_blank"),
                             "created by Jan-San and Hernán Foffani."),
                    helpText("10. ",
                             a("Papr", 
                               href = "https://shiny.rstudio.com/gallery/papr.html", 
                               target = "_blank"),
                             "- \"Tinder for pre-prints\", an app created by Jeff Leek, 
                             the main source of inspiration for NextWordio web layout."),
                    helpText("11.",
                             a("Stack Overflow", 
                               href = "https://stackoverflow.com/questions/tagged/r", 
                               target = "_blank"),
                             "- an endless source of knowledge and support."),
                    helpText("12.",
                             a("Free Logo Design", 
                               href = "https://www.freelogodesign.org/index.html", 
                               target = "_blank"),
                             "- an easy way to have a nice logo online. For free.")
                )
            )
        )
    )
)