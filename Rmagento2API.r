# Created by Alex Levashov, https://levashov.biz 
# Magento API R experiments
# Create a special magento admin user in your Magento admin
# Give it access to the resources you need to handle through API
# write the username and password


library(jsonlite)
library(httr)

#get auth token

url <- "https://shop.altima.net.au/index.php/rest/V1/integration/admin/token"

myquery = list (username = "YOUR USERNAME", password = "YOUR PASSWORD") 
# Magento admin user credentials above
# change them to yours


myqueryj = toJSON(myquery, pretty = TRUE, auto_unbox = TRUE)

req <- POST(url, add_headers ("Content-Type" = "application/json"),  body = myquery, encode = "json")

token <-rawToChar(req$content[2:33])

# get list of orders


url <- "https://shop.altima.net.au/index.php/rest/V1/orders?"
# don't forget to change domain in the URL above to your store here and in other URLs below

auth <- paste0("Bearer ", token)

myquery <- list("searchCriteria[filter_groups][0][filters][0][field]"="created_at",
"searchCriteria[filter_groups][0][filters][0][value]"="2017-01-01 00:00:00",
"searchCriteria[filter_groups][0][filters][0][condition_type]"="gt")

request <- GET(url, add_headers ("Content-Type" = "application/json", "Authorization" = auth), query = myquery)

orders <- content(request, as ="parsed")

# Get some products
url <- "https://shop.altima.net.au//index.php/rest/V1/products?"
myquery <- list("searchCriteria[filter_groups][0][filters][0][field]"="name",
                "searchCriteria[filter_groups][0][filters][0][value]"="%lookbook%",
                "searchCriteria[filter_groups][0][filters][0][condition_type]"="like")

request <- GET(url, add_headers ("Content-Type" = "application/json", "Authorization" = auth), query = myquery)
products <- content(request, as = "parsed")

