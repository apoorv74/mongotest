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
    tabItem("num1",uiOutput('scheme_id'))))

ui <- dashboardPage(
  dashboardHeader(title = tags$a(href='http://socialcops.com',
                                 tags$img(src='http://i.imgur.com/8Qh9OZJ.png',height='60',width='200'))),
  dashboardSidebar(sidebarMenu(id = 'tabs',
                               # menuItem("View a scheme", tabName = "scheme_view",icon  = icon("line-chart")),
                               menuItem("Scheme Updation", tabName = "num1",icon  = icon("bars"))
                               )),
  
  body
)
retrieval_function <- function(scheme_name){
  scheme_id <- db$find(query = paste0('{"scheme_name" : "',scheme_name,'" }'), 
                       fields = '{"_id" : 0}')
  scheme_id
}
server <- shinyServer(function(session, input, output) {
  scheme_id <- renderPrint(retrieval_function('new one'))
  
})
shinyApp(ui,server)