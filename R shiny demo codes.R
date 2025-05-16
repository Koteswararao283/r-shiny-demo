#Demo for shiny

library(shiny)
ui <- fluidPage(
)
server <- function(input, output, session) {
}
shinyApp(ui, server)

ui <- fluidPage(
  titlePanel("Shiny Elements Example"),
  sidebarLayout(
    sidebarPanel(
      numericInput("numInput", "Enter a number:", value = 0),
      sliderInput("numSlider", "Select a value:", min = 0, max = 100, value = 50),
      sliderInput("numSlider", "Select a value:", min = 0, max = 100, value = c(50,60)),
      actionButton("actionBtn", "Click Me"),
      checkboxInput("singleCheckbox", "Check me"),
      checkboxGroupInput("multiCheckbox", "Select options:",
                         choices = c("Option 1", "Option 2", "Option 3")),
      radioButtons("rb", "Choose one:",
                   choiceNames = list(
                     icon("angry"),
                     icon("smile"),
                     icon("sad-tear")
                   ),
                   choiceValues = list("angry", "happy", "sad")
      ),
      radioButtons("radioBtn", "Choose one:",
                   choices = c("Option A", "Option B", "Option C"), selected = NULL),
      selectInput("dropdownMenu", "Choose one:",
                  choices = c("Option 1", "Option 2", "Option 3"), selected = NULL),
      selectInput("dropdownMenu", "Choose one:",
                  choices = c("Option 1", "Option 2", "Option 3"), selected = NULL,multiple = TRUE),
      textInput("txtInput", "Enter text:"),
      textAreaInput("story", "Tell me about yourself", rows = 3),
      dateInput("dob", "When were you born?"),
      dateRangeInput("holiday", "When do you want to go on vacation next?"),
      fileInput("upload", "Upload csv file", accept = ".csv")
    ),
    mainPanel(
    )
  )
)

ui <- fluidPage(
  textOutput("text"),
  verbatimTextOutput("code"),
  tableOutput("static"),
  dataTableOutput("dynamic"),
  plotOutput("plot", width = "400px"),
  plotlyOutput("plotly")
)


server <- function(input, output, session) {
  output$text <- renderText({
    "Hello friend!"
  })
  output$code <- renderPrint({
    summary(1:10)
  })
  output$static <- renderTable(head(mtcars))
  output$dynamic <- renderDT(mtcars, options = list(pageLength = 5))
  output$plotly <- renderPlotly({
    plot_ly(data = iris, x = ~Sepal.Length, y = ~Sepal.Width, color = ~Species, type = "scatter", mode = "markers")
  })
  output$plot <- renderPlot(plot(1:5), res = 96)
}

library(shiny)

ui <- fluidPage(navbarPage(
  "My Shiny App",
  tabPanel("tab 1",
           sidebarPanel(
             fileInput("upload", "Upload csv file", accept = ".csv")
             # numericInput("numInput", "Enter a number:", value = 0)
           ),
           mainPanel(
             tableOutput("head")
             # dataTableOutput("head")
           )
  )
))

server <- function(input, output, session) {
  data <- reactive({
    req(input$upload)
    read.csv(input$upload$datapath)
  })
  # observeEvent(input$upload, {
  #       showNotification("File uploaded", duration = 10)
  # 
  # })
  output$head <- renderTable({
    # if(input$numInput<5){validate("
    #   enter number more than 5"
    # )}
    # head(data(), input$numInput)
    head(data(), 10)
  })
  
  
  # output$head <- renderDT(data(), options = list(pageLength = 5))
  # output$head <- renderDT(data(), options = list(pageLength = 5))
  
}
shinyApp(ui, server)


library(shiny)
# library(shinythemes)
library(plotly)

ui <- fluidPage(#theme= shinytheme("united"),
  navbarPage(
    "My Shiny App",
    tabPanel("Data",
             sidebarPanel(
               fileInput("upload", "Upload csv file", accept = ".csv")
             ),
             mainPanel(
               tableOutput("head")
             )
    ),
    tabPanel("Table",
             sidebarPanel(
               selectInput("x", "X", choices = NULL),
               selectInput("y", "Y", choices = NULL),
               selectInput("color", "color", choices = NULL),
               actionButton("simulate", "plot",class = "btn-success")
             ),
             mainPanel(
               plotlyOutput("plot")
             )
    )
  ))

server <- function(input, output, session) {
  data <- reactive({
    req(input$upload)
    read.csv(input$upload$datapath)
  })
  
  output$head <- renderTable({
    head(data(), 10)
  })
  
  observeEvent(data(), {
    choices <- names(data())
    updateSelectInput(inputId = "x", choices = choices)
    updateSelectInput(inputId = "y", choices = choices)
    updateSelectInput(inputId = "color", choices = choices)
  })
  
  
  output$plot <- renderPlotly({
    if(input$simulate>0){
      plot_ly(data = data(), x = ~get(input$x), y = ~get(input$y), color = ~get(input$color), type = "scatter", mode = "markers")%>%
        layout(
          title = "Customized Scatter Plot",
          xaxis = list(title = input$x),
          yaxis = list(title = input$y)
        )
    }})
}
shinyApp(ui, server)