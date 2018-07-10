dashboardPage(
dashboardHeader(
  title = "Next Word Prediction App"
),

dashboardSidebar(
  sidebarMenu(
    menuItem("App", tabName = "app", icon = icon("keyboard")),
    menuItem("Exploratory Analysis", tabName = "exploratory_analysis", icon = icon("chart-bar")),
    menuItem("Sampling and Modeling", tabName = "sampling", icon = icon("splotch")),
    menuItem("About", tabName = "about", icon = icon("address-card"))
  )
  
),


dashboardBody(
  tags$head(
    tags$link(rel = "stylesheet", type = "text/css", href = "https://use.fontawesome.com/releases/v5.1.0/css/all.css")),
  ### changing theme
  shinyDashboardThemes(
    theme = "blue_gradient"
  ),
  
    tabItems(tabItem(tabName = "app",
                    
                    fluidRow(
                      box(
                        title = "Insert Text Below", width = 12, solidHeader = TRUE, status = "primary",
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
            
            tabItem(tabName = "exploratory_analysis",
                    includeHTML('exploratory_analysis.html')),
            
            tabItem(tabName = "sampling",
                    includeHTML("Prediction.html")),
            
            tabItem(tabName = "about",
                    includeHTML("About.html"))
            
          )
)
)