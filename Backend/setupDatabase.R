config <- read_yaml("config.yml")
postgres_config <- config$default$postgres

connectDatabase <- function() {
  # Connect to the default database (e.g., "postgres")
   con <- dbConnect(Postgres(),
                   user = postgres_config$user,
                   host = postgres_config$host,
                   password = postgres_config$password,
                   dbname = "postgres",
                   port = postgres_config$port)
  
  return(con)
}

createDatabase <- function(con) {

  result <- dbGetQuery(con, "SELECT 1 FROM pg_database WHERE datname = 'ambiorix_test'")
  
  if (nrow(result) == 0) {
  
    dbExecute(con, "CREATE DATABASE ambiorix_test")
    cat("Database 'ambiorix_test' created successfully.\n")
  } else {
    cat("Database 'ambiorix_test' already exists.\n")
  }
  
 
  dbDisconnect(con)
  

  con <- dbConnect(Postgres(),
                   user = postgres_config$user,
                   host = postgres_config$host,
                   password = postgres_config$password,
                   dbname = postgres_config$dbname,
                   port = postgres_config$port)
  

  result <- dbGetQuery(con, "SELECT 1 FROM information_schema.tables WHERE table_name = 'users'")
  
  if (nrow(result) == 0) {

    dbExecute(con, "CREATE TABLE users (
              id SERIAL PRIMARY KEY,
              name VARCHAR(255),
              registered_date DATE,
              phone_number VARCHAR(20),
              created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
          )")
    cat("Table 'users' created successfully.\n")
  } else {
    cat("Table 'users' already exists.\n")
  }
  
  return(con)
}

setupDatabase <- function() {
  con <- connectDatabase()
  con <- createDatabase(con)
  

  result_db <- dbGetQuery(con, "SELECT 1 FROM pg_database WHERE datname = 'ambiorix_test'")
  result_table <- dbGetQuery(con, "SELECT 1 FROM information_schema.tables WHERE table_name = 'users'")
  
  if (nrow(result_db) > 0 && nrow(result_table) > 0) {
    cat("Database and table setup complete. Exiting setupDatabase.\n")
    return(con)
  }
  
  return(con)
}