library(twitteR)
library(stringr)
library(igraph)

api_key <- "z5zA30mP0tnu6QxYZQKmAOYd2"
api_secret <- "JTqIVp7oQOeo8oXhWuQWW8f9Z6dmxCihT19wLThIyB8keNQT0W"
access_token <- "213082131-4jTcuzi93NGyLSwzC3mngA13R1lVWewhMIvR43nS"
access_token_secret <- "97vnYbxo0pnJszhHXtn9aSc3VtkoAnOvbqMqcpptCUI7O"

setup_twitter_oauth(api_key,api_secret,access_token,access_token_secret)

tweets = searchTwitter("#AvionPresidencial", n=150)
tweet_txt = sapply(tweets, function(x) x$getText()) 

# regular expressions to find retweets
grep("(RT|via)((?:\\b\\W*@\\w+)+)", tweets, ignore.case=TRUE, value=TRUE)

# which tweets are retweets
rt_patterns = grep("(RT|via)((?:\\b\\W*@\\w+)+)", tweet_txt, ignore.case=TRUE)

# show retweets (these are the ones we want to focus on)
tweet_txt[rt_patterns]

#VISUALIZE RETWITTS IN R
# we create a list to store user names
who_retweet = as.list(1:length(rt_patterns))
who_post = as.list(1:length(rt_patterns))

# for loop
for (i in 1:length(rt_patterns))
{
  # get tweet with retweet entity
  twit = tweets[[rt_patterns[i]]]
  # get retweet source
  poster = str_extract_all(twit$getText(),"(RT|via)((?:\\b\\W*@\\w+)+)")
  #remove ':'
  poster = gsub(":", "", unlist(poster))
  # name of retweeted user
  who_post[[i]] = gsub("(RT @|via @)", "", poster, ignore.case=TRUE)
  # name of retweeting user
  who_retweet[[i]] = rep(twit$getScreenName(), length(poster))
}

# and we put it off the list
who_post = unlist(who_post)
who_retweet = unlist(who_retweet)

#GENERATE THE NETWORK GRAPH
# two column matrix of edges
retweeter_poster = cbind(who_retweet, who_post)

# generate graph
rt_graph = graph.edgelist(retweeter_poster)

# get vertex names  
ver_labs = get.vertex.attribute(rt_graph, "name", index=V(rt_graph))

#PLOT THE GRAPH
# choose some layout

glay = layout_with_kk(rt_graph)

# plot
par(bg="white", mar=c(1,1,1,1))
plot(rt_graph, layout=glay,
     vertex.color="black",
     vertex.size=10,
     vertex.label=ver_labs,
     vertex.label.family="sans",
     vertex.shape="none",
     vertex.label.color=hsv(h=.165, s=.28, v=.08, alpha=1),
     vertex.label.cex=0.85,
     edge.arrow.size=0.8,
     edge.arrow.width=0.5,
     edge.width=3,
     edge.color=hsv(h=0, s=1, v=1, alpha=1))
# edge.color=("#408080")
# add title
title("nTweets on #AvionPresidencial : Who retweets whom",
      cex.main=1, col.main="black")