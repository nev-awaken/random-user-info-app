createDatabase <- function() {
  con <- connectToDatabase("postgres", autoCreateDb = TRUE)

  if (is.list(con) && isTRUE(con$error)) {
    cat("Error connecting to the default database:", con$message, "\n")
    return(con)
  }

  result <- tryCatch({
    dbGetQuery(con, "SELECT 1 FROM pg_database WHERE datname = 'ambiorix_test'")
  }, error = function(e) {
    cat("Error checking database existence:", conditionMessage(e), "\n")
    return(list(error = TRUE, message = paste("Error checking database existence:", conditionMessage(e))))
  })

  if (is.list(result) && isTRUE(result$error)) {
    dbDisconnect(con)
    return(result)
  }

  if (nrow(result) == 0) {
    tryCatch({
      dbExecute(con, "CREATE DATABASE ambiorix_test")
      cat("Database 'ambiorix_test' created successfully.\n")
    }, error = function(e) {
      cat("Error creating database:", conditionMessage(e), "\n")
      dbDisconnect(con)
      return(list(error = TRUE, message = paste("Error creating database:", conditionMessage(e))))
    })
  } else {
    cat("Database 'ambiorix_test' already exists.\n")
  }

  dbDisconnect(con)
  return(list(error = FALSE))
}

setupDatabase <- function() {
  create_result <- createDatabase()

  if (is.list(create_result) && isTRUE(create_result$error)) {
    return(create_result)
  }

  con <- connectToDatabase()

  if (is.list(con) && isTRUE(con$error)) {
    cat("Error connecting to the database:", con$message, "\n")
    return(con)
  }

  result_table <- tryCatch({
    dbGetQuery(con, "SELECT 1 FROM information_schema.tables WHERE table_name = 'users'")
  }, error = function(e) {
    cat("Error checking table existence:", conditionMessage(e), "\n")
    return(list(error = TRUE, message = paste("Error checking table existence:", conditionMessage(e))))
  })

  if (is.list(result_table) && isTRUE(result_table$error)) {
    dbDisconnect(con)
    return(result_table)
  }

  if (nrow(result_table) == 0) {
    tryCatch({
      dbExecute(con, "CREATE TABLE users (
                id SERIAL PRIMARY KEY,
                name VARCHAR(255),
                registered_date DATE,
                phone_number VARCHAR(20),
                created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
            )")
      cat("Table 'users' created successfully.\n")
    }, error = function(e) {
      cat("Error creating table:", conditionMessage(e), "\n")
      dbDisconnect(con)
      return(list(error = TRUE, message = paste("Error creating table:", conditionMessage(e))))
    })
  } else {
    cat("Table 'users' already exists.\n")
  }

  cat("Database and table setup complete. Exiting setupDatabase.\n")
  dbDisconnect(con)
  return(list(error = FALSE))
}