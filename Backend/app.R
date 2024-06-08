library(future)
library(ambiorix)
library(coro)
library(httr)
library(RPostgres)
library(promises)
library(yaml)

plan(multisession)

source("./job.R")
source("./user_info_request_handler.R")
PORT <- 1000
localhost <- "127.0.0.1"
app <- Ambiorix$new()

app$use(function(req, res) {
  res$header("Access-Control-Allow-Origin", "*")
  res$header("Access-Control-Allow-Methods", "GET, POST, PUT, DELETE, OPTIONS")
  res$header("Access-Control-Allow-Headers", "Content-Type, Authorization")
})

app$options("*", function(req, res) {
  res$header("Access-Control-Allow-Origin", "*")
  res$header("Access-Control-Allow-Methods", "GET, POST, PUT, DELETE, OPTIONS")
  res$header("Access-Control-Allow-Headers", "Content-Type, Authorization")
  res$send()
})

app$get("/api/users", ui_request_handler)

app$get("/api/test", function(req, res) {
  str <- paste(Sys.time())
  res$send(str)
})

promises::promise_all(job())

cat("Starting server on", localhost, ":", PORT, "\n")
app$start(port = PORT, host = localhost)
