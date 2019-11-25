#install.packages("jsonlite")
library(jsonlite)
#install.packages("httpuv")
library(httpuv)
#install.packages("httr")
library(httr)

# Can be github, linkedin etc depending on application
oauth_endpoints("github")

# Change based on what you 
myapp <- oauth_app(appname = "Access_Github",
                   key = "8d5f8e3baf1d5224e3e2",
                   secret = "43116acd50511ba7c882f14f7e1249bbefef0b01")

# Get OAuth credentials
github_token <- oauth2.0_token(oauth_endpoints("github"), myapp)

# Use API
gtoken <- config(token = github_token)
req <- GET("https://api.github.com/users/jtleek/repos", gtoken)

# Take action on http error
stop_for_status(req)

# Extract content from a request
json1 = content(req)

# Convert to a data.frame
gitDF = jsonlite::fromJSON(jsonlite::toJSON(json1))

# Subset data.frame
gitDF[gitDF$full_name == "jtleek/datasharing", "created_at"] 

#Connecting to my Plotly account 
Sys.setenv("plotly_username"="ElizabethBolger")
Sys.setenv("plotly_api_key"="Lg3FKICVHpfQVL6JoOm8")

#Function that returns a list of the provided user's followers. 
getFollowers <- function(username)
{
  URL <- paste("https://api.github.com/users/", username , "/followers", sep="")
  followers = fromJSON(URL)
  return (followers$login)
}

#Function that returns a list of the people the provided user is following. 
getFollowing <- function(username)
{
  URL <- paste("https://api.github.com/users/", username , "/following", sep="")
  followers = fromJSON(URL)
  return (followers$login)
}

#Function that returns a list of the provided user's repositories
getRepositories <- function(username)
{
  URL <- paste("https://api.github.com/users/", username , "/repos", sep="")
  repos = fromJSON(URL) 
  repos$committs
  return (repos$name)
}
