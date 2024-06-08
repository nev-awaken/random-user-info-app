library(httr)
library(jsonlite)
library(DBI)
library(coro)
library(RPostgres)

callAndStoreUserData <- async(function() {
    data <- await(api_call())
    con <- dbConnect(Postgres(),
            user = "postgres",
            host = "localhost",
            password = "sa",
            dbname = "ambiorix_test",
            port = "5432")
    await(storeUserData(con, data))
    dbDisconnect(con)
})

api_call <- async(function() {
    response <- GET("https://randomuser.me/api/")
    if (status_code(response) == 200) {
        result <- content(response, "text")
        cat("API Result:", result, "\n\n")
        return(result)
    } else {
        cat("API request failed with status code:", status_code(response), "\n")
        return(NULL)
    }
})

storeUserData <- async(function(con, data) {
    if (!is.null(data)) {
        tryCatch(
            {
                parsed_data <- fromJSON(data, flatten = TRUE)
                
                if (is.data.frame(parsed_data$results) && nrow(parsed_data$results) > 0) {
                    result <- parsed_data$results[1, ]
                    
                    if (!is.null(result$name.first) && !is.null(result$name.last)) {
                        name <- paste(result$name.first, result$name.last)
                    } else {
                        name <- NA
                    }
                    
                    if (!is.null(result$registered.date)) {
                        registered_date <- tryCatch(as.Date(result$registered.date), error = function(e) NA)
                    } else {
                        registered_date <- NA
                    }
                    
                    if (!is.null(result$phone)) {
                        phone_number <- result$phone
                    } else {
                        phone_number <- NA
                    }
                    
                    query <- sprintf("INSERT INTO users (name, registered_date, phone_number) VALUES ('%s', '%s', '%s')",
                                     name, format(registered_date, "%Y-%m-%d"), phone_number)
                    tryCatch({
                        dbExecute(con, query)
                    }, error = function(e) {
                        message(sprintf('Error in dbExecute: %s', e$message))
                        
                    })
                    
                    cat("User data stored successfully.\n")
                } else {
                    cat("Invalid or empty results in the API response. Data not stored.\n")
                }
            },
            error = function(e) {
                cat("Error parsing API response:", conditionMessage(e), "\n")
            }
        )
    } else {
        cat("Invalid API response. Data not stored.\n")
    }
})


