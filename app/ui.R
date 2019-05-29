#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
# 
#    http://shiny.rstudio.com/
#
## Libraries
library("devtools") 
library("shiny")
library("shinydashboard")
library("shinythemes")
library("flexdashboard") # gauge charts
library("httr") # call Dataiku's APIs
library("jsonlite") # parse JSON file
library("shinyjs") # allows run of javascript code
library("DT") # highlight row from renderdatatable
library("leaflet") # map
library("shinyWidgets") 
library("shinydashboardPlus") # allows right sidebar
library("ECharts2Shiny")
library("shinycssloaders")
library("geosphere") # used in combination with leaflet
library("data.table")
library("scales")
library("plyr")
library('profvis')
library("dplyr")

shinyUI(
  dashboardPage(
    skin = 'black',
    header = dashboardHeader(title='Data Marketplace'),
    sidebar = dashboardSidebar(disable = TRUE),
    body = dashboardBody(
      tags$head(tags$link(rel = "stylesheet", type = "text/css", href = "styles.css")),
      shinyjs::useShinyjs(),
      fillPage(
        wellPanel(
          fluidRow(
            column(8, textInput("key_words", label = "Key Words", width='100%')),
            column(1, actionButton("click_search", label = "CLICK ME MFER")),
            column(3, uiOutput("type_filter", label = "Key Words", width='100%')))
        ),
        fluidRow(
          box(withSpinner(
            DT::dataTableOutput('results'), 8), title = strong("frig sakes rick"), width = "100%"))
        #,
        #column(1,actionButton("click_search", label = uiOutput("search"))),
        #column(1,actionButton("click_reset", label = uiOutput("clear_dash"))))
      )
    )
  )
)