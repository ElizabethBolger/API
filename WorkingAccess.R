#install.packages("jsonlite")
library(jsonlite)
#install.packages("httpuv")
library(httpuv)
#install.packages("httr")
library(httr)

# Can be github, linkedin etc depending on application
oauth_endpoints("github")

# Change based on what you 
myapp <- oauth_app(appname = "Access",
                   key = "3f4d83f6abbcf46d9e8f",
                   secret = "82257089e7c2c4180ff500fb215a614f4b8a4faa")
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


#Interrogate the Github API to extract data from my own github account and summarise

#Gets my data 
myData = fromJSON("https://api.github.com/users/ElizabethBolger")

#Displays number of followers
myData$followers

followers = fromJSON("https://api.github.com/users/ElizabethBolger/followers")
followers$login #Gives user names of all my followers

myData$following #Displays the number of people I am following

following = fromJSON("https://api.github.com/users/ElizabethBolger/following")
following$login #Gives the names of all the people I am following

myData$public_repos #Displays the number of repositories I have

repos = fromJSON("https://api.github.com/users/ElizabethBolger/repos")
repos$name #Details of the names of my public repositories
repos$created_at #Gives details of the date the repositories were created 
repos$full_name #gives names of repositories

#Used account of Jake Wharton  to produce plots, one of the most popular developers on Github.
#Used instead of my account as his account would produce more accurate results.

myData = GET("https://api.github.com/users/JakeWharton/followers?per_page=100;", gtoken)
stop_for_status(myData)
extract = content(myData)
#Converts into dataframe
githubDB = jsonlite::fromJSON(jsonlite::toJSON(extract))
githubDB$login


