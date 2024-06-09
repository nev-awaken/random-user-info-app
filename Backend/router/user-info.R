source("./controller/all_user_info.R")
source("./controller/user_count_info.R")

router <- Router$new("/")

print(
   " im here "
)
router$get("api/users", get_all_user_info)
router$get("api/user-count", get_user_count_info)
router$get("api/test", function(req, res) {
  str <- paste(Sys.time())
  res$send(str)
})


print(
   " im here 2"
)