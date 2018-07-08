header <- dashboardHeader(
  title = "Next Word Prediction App"
)

sidebar <- dashboardSidebar(
  sidebarMenu(
    menuItem("App", tabName = "app"),
    menuItem("Exploratory Analysis", tabName = "exploratory analysis")
  )
)

body <- dashboardBody(
  tags$head(
    tags$link(rel = "stylesheet", type = "text/css", href = "custom.css")),
  tabItems(
    tabItem(tabName = "app",
            fluidRow(
              box(
                title = "Starting typing", width = 12, solidHeader = TRUE, status = "warning",
                textInput('fitb',label='',value='Show me the way'),
                uiOutput('suggestions')
              ),
              box(
                title = "Probability Histogram", width = 6, solidHeader = TRUE, status = "primary",
                plotOutput('histo')
              ),
              box(
                title = "Word Cloud", width = 6, solidHeader = TRUE, status = "primary",
                plotOutput('cloud')
              )
            )
    ),
    tabItem(tabName = "exploratory analysis",
            includeMarkdown('exploratory analysis.Rmd')
    )
  )
)


dashboardPage(
  header,
  sidebar,
  body
)