# setwd('~/Downloads/scheme_dashboard/responses/')
list_packages <- c('dplyr','stringr','shinydashboard','shiny','shinyjs','mongolite')
lapply(list_packages,require,character.only=T)

# Mongo credentials -------------------------------------------------------
options(mongodb = list(
  "host" = "127.0.0.1"
))


# Database names ----------------------------------------------------------
databaseName <- "scheme_db"
collectionName <- "scheme_collection"

db <- mongo(collection = collectionName,
            url = sprintf(
              "mongodb://%s/%s",
              options()$mongodb$host,
              databaseName))

body <- dashboardBody(
  useShinyjs(),
  tabItems(
    tabItem("num1",tags$div('apoorv'))))

ui <- dashboardPage(
  dashboardHeader(title = tags$a(href='http://socialcops.com',
                                 tags$img(src='http://i.imgur.com/8Qh9OZJ.png',height='60',width='200'))),
  dashboardSidebar(sidebarMenu(id = 'tabs',
                               # menuItem("View a scheme", tabName = "scheme_view",icon  = icon("line-chart")),
                               menuItem("Scheme Updation", tabName = "num1",icon  = icon("bars"))
                               )),
  
  body
)

server <- shinyServer(function(session, input, output) {})
shinyApp(ui,server)