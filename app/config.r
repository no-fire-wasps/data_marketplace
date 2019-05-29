PROJECT <- "dragnet"

# if(substr(Sys.getenv("HOSTNAME"), 7, 7) == "1"){ # CHECK IF RSHINY IS RUNNING IN PROD  
#   # DATAIKU PROD
#   dku_env <- "https://yyzdku1903.ana.corp.aviva.com:10000/public/api/v1"
#   DKU_KEY <- "a6RVT7NlPnfeWynlfM2ep7f7ZWug9aG3"
# }else{
#   # DATAIKU QA
#   dku_env <- "https://yyzdku2903.ana.corp.aviva.com:10000/public/api/v1"
#   DKU_KEY <- "We5e8t2x8ueW3uVkZbI6pUdtMOJmLDD9"
# }

SEARCH_KEYWORD_ENDPOINT <- "http://127.0.0.1:5000/search_keyword"

# 
# DKU_ENDPOINT_POLICY_MASTER <- file.path(dku_env, PROJECT, "policy_master", "run")
# 
# DKU_ENDPOINT_INTEL_RULES <- file.path(dku_env, PROJECT, "intel_rules", "run")
# 
# DKU_ENDPOINT_NON_INTEL_RULES <- file.path(dku_env, PROJECT, "non_intel_rules", "run")
# 
# DKU_ENDPOINT_SET_POLICY_STATUS <- file.path(dku_env, PROJECT, "set_policy_status", "run")
# 
# DKU_ENDPOINT_SET_ALERT_STATUS <- file.path(dku_env, PROJECT, "set_alert_status", "run")

INVESTIGATORS <- c('Please Select', 'Sami Rashid', 'Jeremy Meltzer', 'Jonathan Smith', 'Kasia Rokicka', 'Eve Alber',
                   'Sarah Galati', 'Christopher Raguseo', 'Paul Menezes', 'Shawn Cooper', 'Devon Hercules', 'Regine Henriques')

OUTCOMES <- c('Please Select', 'Open', 'Open - Investigation Intiated', 
              'Closed', 'Closed - Investigation Initiated','Closed - Investigation Successful',
              'Closed - Investigation Discontinued', 'Closed - No Action', 'Closed - False Positive')
