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
    # output$results <- DT::renderDataTable({
    #   # dt <- datatable(df_filtered(), colnames = c(dict[["industry_code"]][bool_lang()], dict[["segment"]][bool_lang()], dict[["description"]][bool_lang()]),
    #   #                 filter = "none", selection = "single", rownames = FALSE,
    #   #                 options = list(language = list(lengthMenu = paste(dict[["ot_lengthmenu"]][bool_lang()]),
    #   #                                                paginate = list(previous = paste(dict[["ot_previous"]][bool_lang()]), `next` = paste(dict[["ot_next"]][bool_lang()]))),
    #   #                                autoWidth = FALSE, dom = 'ltp', columnDefs = list(list(targets=c(0), visible=TRUE, width='75'),
    #   #                                                                                  list(targets=c(1), visible=TRUE, width='200'),
    #   #                                                                                  list(targets=c(2), visible=TRUE, width='500'))), style = "bootstrap", class = "table-bordered stripe")
    #   dt <- datatable(api_search_keywords()$clean)
     # })
    #df <- api_
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
    # inforce <- data.frame(matrix(unlist(api_search_keywords()), nrow=length(api_search_keywords()), byrow = T), stringsAsFactors = FALSE)
    # 
    # names(inforce) <- names(api_search_keywords()[[1]])
    
    #print(inforce$contains)
    # output$results <- DT::renderDataTable({
    #   DT <- datatable(data = inforce,
    #                   class = "display stripe hover",
    #                   filter = "none",
    #                   rownames = FALSE,
    #                   escape = FALSE,
    #                   selection = "single",
    #                   options = list(
    #                     dom = 'ltip',
    #                     order = list(list(5, 'desc')),
    #                     pageLength = 6,
    #                     lengthMenu = c(6, 10, 100),
    #                     scrollcollapse = TRUE,
    #                     scroller = TRUE,
    #                     scrollY = '30vh'
    #                   )
    #   )
    # })
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
  
  
  #############################
  #### REACTIVE DATAFRAMES ####
  
  ## Policy Alert List
  # df_policy <- function(){
  #   shiny::validate(need(api_policy_master(), "ERROR: 500 - Policy Alert Not Responding"))
  #   df <- data.frame(matrix(unlist(api_policy_master()), nrow=length(api_policy_master()), byrow = T), stringsAsFactors = FALSE)
  #   names(df) <- names(api_policy_master()[[1]])
  #   df$Score <- as.numeric(df$Score)
  #   df
  # }
  # 
  # ## Intel Rules
  # df_intel <- reactive({
  #   req(polCode())
  #   shiny::validate(need(api_intel_rules(), "ERROR: 500 - Intel Rules Not Responding"))
  #   df <- data.frame(matrix(unlist(api_intel_rules()), nrow=length(api_intel_rules()), byrow = T), stringsAsFactors = FALSE)
  #   names(df) <- names(api_intel_rules()[[1]])
  #   df
  # })
  # 
  # ## Nonintel Rules
  # df_nonintel <- reactive({
  #   req(polCode())
  #   shiny::validate(need(api_nonintel_rules(), "ERROR: 500 - Nonintel Rules Not Responding"))
  #   df <- data.frame(matrix(unlist(api_nonintel_rules()), nrow=length(api_nonintel_rules()), byrow = T), stringsAsFactors = FALSE)
  #   names(df) <- names(api_nonintel_rules()[[1]])
  #   df
  # })
  # 
  # ## Feedback Datatable
  # df_rules <- function(){
  #   nonintel_rules <- df_nonintel()
  #   intel_rules <- df_intel()
  #   
  #   if (dim(nonintel_rules)[2] > 1) {
  #     unique_nonintel <- unique(nonintel_rules[, c("Rule Number","Rule Description")])
  #     unique_nonintel[, "Type"] = "Non-Intel"
  #   } else {
  #     unique_nonintel <- NULL
  #   }
  #   
  #   if (dim(intel_rules)[2] > 1) {
  #     unique_intel <- unique(intel_rules[, c("Rule Number","Rule Description")])
  #     unique_intel[, "Type"] = "Intel"
  #   } else {
  #     unique_intel <- NULL
  #   }
  #   
  #   if (!is.null(unique_nonintel) & !is.null(unique_intel)) {
  #     unique_both <- data.table(rbind(unique_intel, unique_nonintel))
  #   } else if (is.null(unique_nonintel)) {
  #     unique_both <- data.table(unique_intel)
  #   } else if (is.null(unique_intel)) {
  #     unique_both <- data.table(unique_nonintel)
  #   }
  #   
  #   addRadioButtons <- '<input type="radio" name="%s" value=%d %s/>'
  #   
  #   for (i in seq_len(nrow(unique_both))) {
  #     unique_both[i, 'False Positive'] = sprintf(
  #       addRadioButtons, unique_both[i, 'Rule Number'], -1, '')
  #     unique_both[i, 'Positive Positive'] = sprintf(
  #       addRadioButtons, unique_both[i, 'Rule Number'], 1, '')
  #     unique_both[i, 'No Response'] = sprintf(
  #       addRadioButtons, unique_both[i, 'Rule Number'], 0, 'checked="checked"')
  #   }
  #   
  #   return(unique_both)
  # }
  # 
  # 
  ############################
  #### POLICY ALERT LIST  ####
  # output$master <- DT::renderDataTable({
  #   master_table <- df_policy()
  #   DT <- datatable(data = master_table,
  #                   class = "display stripe hover",
  #                   filter = "none",
  #                   rownames = FALSE,
  #                   escape = FALSE,
  #                   selection = "single",
  #                   options = list(
  #                     dom = 'ltip',
  #                     order = list(list(5, 'desc')),
  #                     pageLength = 6,
  #                     lengthMenu = c(6, 10, 100),
  #                     scrollcollapse = TRUE,
  #                     scroller = TRUE,
  #                     scrollY = '30vh'
  #                   )
  #   )
  # })
  
  ##########################
  #### INTEL RULES LIST ####
#   output$intel <- DT::renderDataTable({
#     DT::datatable(data = df_intel(),
#                   class = "display stripe hover",
#                   filter = "none",
#                   rownames = FALSE,
#                   escape = FALSE,
#                   selection = "single",
#                   options = list(
#                     autoWidth = TRUE,
#                     dom = 'ltip',
#                     columnDefs = list(list(visible=FALSE, targets=c(0,1)),
#                                       list(width = '200px', targets = "_all")),
#                     paging = FALSE,
#                     scrollcollapse = TRUE,
#                     scroller = TRUE,
#                     scrollX = TRUE,
#                     scrollY = '20vh'
#                   )
#     )
#   })
#   
#   #############################
#   #### NONINTEL RULES LIST ####
#   output$nonintel <- DT::renderDataTable({
#     DT::datatable(data = df_nonintel(),
#                   class = "display stripe hover",
#                   filter = "none",
#                   rownames = FALSE,
#                   escape = FALSE,
#                   selection = "single",
#                   options = list(
#                     dom = 'ltip',
#                     columnDefs = list(list(visible=FALSE, targets=c(0,1))),
#                     paging = FALSE,
#                     scrollcollapse = TRUE,
#                     scroller = TRUE,
#                     scrollX = TRUE,
#                     scrollY = '20vh'
#                   )
#     )
#   })
#   
#   ############################
#   #### FEEDBACK FOR RULES ####
#   output$feedback_dt <- DT::renderDataTable(
#     df_rules(), escape = FALSE, selection = 'none', server = FALSE, rownames = FALSE,
#     options = list(
#       dom = 't',
#       paging = FALSE, 
#       ordering = FALSE
#     ),
#     callback = JS("table.rows().every(function(i, tab, row) {
#                   var $this = $(this.node());
#                   $this.attr('id', this.data()[0]);
#                   $this.addClass('shiny-input-radiogroup');
# });
#                   Shiny.unbindAll(table.table().node());
#                   Shiny.bindAll(table.table().node());")
#   )
  
  # output$policy_id <- renderUI({
  #   strong(paste0("Editing Policy: ", as.character(polCode())))
  # })
  # 
  # output$assign_to <- renderUI({
  #   selectInput("assign_to", selected = "Please Select", label = "Assign To: ", choices = INVESTIGATORS)
  # })
  # 
  # output$outcome <- renderUI({
  #   selectInput("outcome", selected = "Please Select", label = "Outcome: ", choices = OUTCOMES)
  # })
  
  proxy = dataTableProxy('master')
  
  #########################
  ###### POLICY EDIT ######
  
  observeEvent(input$submit, {
    if (length(polCode()) == 0) {
      shiny::validate(need(polCode(), sendSweetAlert(session = session, title = "No Policy Selected",
                                                     text = "Please select a policy before submitting",
                                                     type = "warning", closeOnClickOutside = TRUE)))
    } else {
      api_set_policy_status_fix()
      api_policy_master()
      df_policy()
      replaceData(proxy, df_policy(), rownames = FALSE)
      reset("assign_to")
      reset("outcome")
      updateTextInput(session, "group_id", value="")
    }
  })
  
  #########################
  #### FEEDBACK SUBMIT ####
  observeEvent(input$feedback_btn, {
    for (row in 1:nrow(df_rules())) {
      if (df_rules()[row, "Type"] == "Intel") {
        flagged_policy <- polCode()
        rule_number <- df_rules()$"Rule Number"[row]
        ## FOR UNIQUE ROW IDENTIFITER
        #id <- df_intel()$"Unique Row Id"[
        #  (df_intel()$"Flagged Policy" == polCode()
        #   & df_intel()$"Rule Number" == df_rules()$"Rule Number"[row])]  ## THIS GETS THE UNIQUE ROW ID
        value <- input[[df_rules()$"Rule Number"[row]]] ## THIS GETS THE VALUE IN RADIO BUTTON
        shiny::validate(need(api_set_alert_status(flagged_policy, rule_number, value),  ## THIS CREATES THE API REQUEST
                             sendSweetAlert(session = session, title = "ERROR", text = "No Connection Established",
                                            type = "error", closeOnClickOutside = TRUE)))
      }
      else {
        flagged_policy <- polCode()
        rule_number <- df_rules()$"Rule Number"[row]
        ## FOR UNIQUE ROW IDENTIFITER
        #id <- df_nonintel()$"Unique Row Id"[
        #  (df_nonintel()$"Flagged Policy" == polCode()
        #   & df_nonintel()$"Rule Number" == df_rules()$"Rule Number"[row])]
        value <- input[[df_rules()$"Rule Number"[row]]]
        shiny::validate(need(api_set_alert_status(flagged_policy, rule_number, value),
                             sendSweetAlert(session = session, title = "ERROR", text = "No Connection Established",
                                            type = "error", closeOnClickOutside = TRUE)))
      }
      sendSweetAlert(session = session, title = "Feedback Submitted", text = "Thank you!",
                     type = "success", closeOnClickOutside = TRUE)
    }
  })
  
  polCode <- reactive({
    id <- input$master_rows_selected
    polCode <- df_policy()[id, "Policy Number"]
    polCode <- as.character(polCode)
  })
  
  observeEvent(input$master_rows_selected, {
    shinyjs::show("edit_box", anim=TRUE, animType = "slide")
    shinyjs::show("feedback_box", anim=TRUE, animType = "side")
  })
  #source("www/javascript.r")
  })
