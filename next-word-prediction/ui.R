header <- dashboardHeader(
  title = "Next Word Prediction App"
)

sidebar <- dashboardSidebar(
  sidebarMenu(
    menuItem("App", tabName = "app", icon = icon("keyboard")),
    menuItem("Exploratory Analysis", tabName = "Exploratory_Analysis", icon = icon("chart-bar")),
    menuItem("Sampling and Modeling", tabName = "Sampling", icon = icon("splotch")),
    menuItem("About", tabName = "About", icon = icon("address-card"))
    
  )
)

body <- dashboardBody(
  tags$head(
    tags$link(rel = "stylesheet", type = "text/css", href = "https://use.fontawesome.com/releases/v5.1.0/css/all.css")),
  ### changing theme
  shinyDashboardThemes(
    theme = "blue_gradient"
  ),
  
  tabItems(
    tabItem(tabName = "app",
            fluidRow(
              box(
                title = "Insert Text Below", width = 12, solidHeader = TRUE, status = "warning",
                textInput('fitb',label='',value='Try me out'),
                uiOutput('suggestions')
              ),
              box(
                title = "Prediction Probability", width = 6, solidHeader = TRUE, status = "primary",
                plotOutput('histo')
              ),
              box(
                title = "Word Cloud", width = 6, solidHeader = TRUE, status = "primary",
                plotOutput('cloud')
              )
            )
    ),
    tabItem(tabName = "Exploratory_Analysis",
            includeHTML('exploratory_analysis.html')
    ),
    tabItem(tabName = "Sampling",
            includeHTML("Prediction.html")
    ),
    
    tabItem(tabName = "About",
            includeHTML("About.html")
    )
  )
)


dashboardPage(
  header,
  sidebar,
  body
)