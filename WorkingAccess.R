#install.packages("jsonlite")
library(jsonlite)
#install.packages("httpuv")
library(httpuv)
#install.packages("httr")
library(httr)
#install.packages("plotly")
library(plotly)
#install.packages("devtools")
require(devtools)

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


#List of user IDs
IDs = githubDB$login
userNames = c(IDs)

#Create an empty vector and data frame
users = c()
usersDB = data.frame(
  username = integer(),
  following = integer(),
  followers = integer(),
  repos = integer(),
  dateCreated = integer()
)

#Loops through users and adds to list
for(i in 1:length(userNames))
{
  
  followingURL = paste("https://api.github.com/users/", userNames[i], "/following", sep = "")
  followingRequest = GET(followingURL, gtoken)
  followingContent = content(followingRequest)
  
  #Does not add users if they have no followers
  if(length(followingContent) == 0)
  {
    next
  }
  
  
  
  followingDF = jsonlite::fromJSON(jsonlite::toJSON(followingContent))
  followingLogin = followingDF$login
  
  #Loop through 'following' users
  for (j in 1:length(followingLogin))
  {
    #Check no two users are the same
    if (is.element(followingLogin[j], users) == FALSE)
    {
      #Adds each user list
      users[length(users) + 1] = followingLogin[j]
      
      #Collect each followers information
      followingUrl2 = paste("https://api.github.com/users/", followingLogin[j], sep = "")
      following2 = GET(followingUrl2, gtoken)
      followingContent2 = content(following2)
      followingDF2 = jsonlite::fromJSON(jsonlite::toJSON(followingContent2))
      
      #The people user following
      followingNumber = followingDF2$following
      
      #The people following user
      followersNumber = followingDF2$followers
      
      #Repository count
      reposNumber = followingDF2$public_repos
      
      #What year the account was created 
      yearCreated = substr(followingDF2$created_at, start = 1, stop = 4)
      
      #Add users data to a new row in dataframe
      usersDB[nrow(usersDB) + 1, ] = c(followingLogin[j], followingNumber, followersNumber, reposNumber, yearCreated)
      
    }
    next
  }
  #Stop when there are more than 150 users
  if(length(users) > 150)
  {
    break
  }
  next
  }

#Link to plotly
Sys.setenv("plotly_username"="ElizabethBolger")
Sys.setenv("plotly_api_key"="VSRPqdR4bGZVYATNRsnw")

#Plot one graphs repositories vs followers by year.
#Takes into account 150 of Jason's follower


#X-axis displays shows the no. of repositories per user.
#Y-axis displays  the no. of followers of each each of Jason's followers.
plotRF = plot_ly(data = usersDB, x = ~repos, y = ~followers, text = ~paste("Followers: ", followers, "<br>Repositories: ", repos, "<br>Date Created:", dateCreated), color = ~dateCreated)
plotRF
#Sends graph to plotly
api_create(plotRF, filename = "Repositories vs Followers")
#Plot can be viewed : https://plot.ly/~ElizabethBolger/1/#/

#Plot two graphs following vs followers by year.

#X-axis displays the no. of users followed by each of Jason's followers.
#Y-axis shows the no. of followers of each of Jason's followers.
plotFF = plot_ly(data = usersDB, x = ~following, y = ~followers, text = ~paste("Followers: ", followers, "<br>Following: ", following), color = ~dateCreated)
plotFF
#Sends graph to plotly
api_create(plotFF, filename = "Following vs Followers")
#Plot can be viewed: https://plot.ly/~ElizabethBolger/3/

#Below code is to produce plot 3.
#Graph the 10 most popular languages used by Jason's followers
#Same 150 users from two previous plots are used.
languages = c()


