#install.packages
library(jsonlite)
library(httpuv)
library(httr)

oauth_endpoints("github")

myapp = oauth_app(appname = "Software_Engineering_API",
                  key = "8d5f8e3baf1d5224e3e2",
                  secret = "43116acd50511ba7c882f14f7e1249bbefef0b01")

# Get OAuth credentials
github_token = oauth2.0_token(oauth_endpoints("github"), myapp)

# Use API
gtoken = config(token = github_token)
UserFollowingData = GET("https://api.github.com/users/jtleek/following", gtoken)
UserFollowingDataContent = content(UserFollowingData)
UserFollowingDataFrame = jsonlite::fromJSON(jsonlite::toJSON(UserFollowingDataContent))

followersLogins = c(UserFollowingDataFrame$login)

# Extract content from a request
json1 = content(req)

# Convert to a data.frame
gitDF = jsonlite::fromJSON(jsonlite::toJSON(json1))

# Subset data.frame
gitDF[gitDF$full_name == "jtleek/datasharing", "created_at"] 