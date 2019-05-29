library(DT)
library(data.table)
library(httr)
library(jsonlite)
library(shiny)
library(shinyjs)

## Config
source("config.r", encoding="UTF-8")
httr::set_config(config(ssl_verifypeer = FALSE, ssl_verifyhost = FALSE))

shinyServer(function(input, output, session) {
  
  ###################
  #### API STUFF ####
  ## Request API function
  
  post_request_dku_api <- function(endpoint, payload){
    response_raw <- POST(url = endpoint, body = payload, encode = "json")
    #response_clean <- content(response_raw)$response
    return(content(response_raw))
  }
  
  ## API: Intel Rules
  api_search_keywords <- reactive({
    payload <- list(keyword = input$key_words, item_type = "")
    response <- post_request_dku_api(SEARCH_KEYWORD_ENDPOINT, payload)
    response
  })
  
  observeEvent({input$click_search}, {
    
    ## CALL TEH API
    resp <- api_search_keywords()
    ## FOR SOME REASON WORKING WITH JSON SUCKS IN R SORRY
    resp <- data.frame(jsonlite::fromJSON(jsonlite::toJSON(resp$response)))
    df <- data.frame("item_type" = unlist(resp$item_type),
                     "name" = unlist(resp$name),
                     "description" = unlist(resp$description))
    
    output$results <- DT::renderDataTable({
      dt <- datatable(df)
    })
  })
  
  output$type_filter <- renderUI({
    selectInput("type_filter", selected = "Select Everything", label = FALSE, choices = c(
      'Search everything',
      '- Data Source -',
      'Business App',
      'Outside Source',
      '- Data Access -',
      'Analytics App',
      'Corporate Report',
      'Regulatory Report',
      '- Data Structure -',
      'Domain',
      'Entity',
      'Attribute',
      'Formula',
      'Metric',
      '- Data Storage -',
      'Database',
      'Data Set (Schema)',
      'Table',
      'Column',
      '- Data Flow -',
      'Message Format',
      'Transformation Service'
    ))
  })
  #source("www/javascript.r")
})
