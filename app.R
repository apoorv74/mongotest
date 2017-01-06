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


# Getting all database data -----------------------------------------------
all_db_data <- function(){
  scheme_data <- db$find()
  scheme_data
}


# Loading data in DB ------------------------------------------------------
loadData <- function() {
  # Connect to the database
  db <- mongo(collection = collectionName,
              url = sprintf(
                "mongodb://%s/%s",
                options()$mongodb$host,
                databaseName))
  # Read all the entries
  data <- db$find()
  data
}


# Schemes first interaction with the database -----------------------------

firstWrite <- function(data) {
  # Connect to the database
  db <- mongo(collection = collectionName,
              url = sprintf(
                "mongodb://%s/%s",
                options()$mongodb$host,
                databaseName))
  # Insert the data into the mongo collection as a data.frame
  # data <- as.data.frame(t(data))
  db$insert(data)
}



# All fields of the database ----------------------------------------------
scheme_table <- loadData()
# browser()
if(nrow(scheme_table)  == 0){
  scheme_table <- data.frame(matrix(data = '-', ncol = length(fieldsAll)))
  names(scheme_table)[] <- fieldsAll
}
scheme_table[is.na(scheme_table)] <- '-'

# Server code -------------------------------------------------------------


server <- shinyServer(function(session, input, output) {
  
  output$scheme_id <- renderText(db$aggregate()$scheme_name)
})


shinyApp(ui,server)
