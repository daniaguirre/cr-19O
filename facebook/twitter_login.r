library(twitteR)
library(stringr)
library(igraph)

#INFORMACION DE LA APP

#AUTENTICACION
setup_twitter_oauth(api_key,api_secret,access_token,access_token_secret)

#DESCARGA 150 TWEETS MÁS RELEVANTES
tweets = searchTwitter("#AvionPresidencial", n=150)
#OBTIENE EL ATRIBUTO Text DE CADA TWEET
tweet_txt = sapply(tweets, function(x) x$getText()) 

# EXPRESION REGULAR PARA BUSCAR RETWEETS EN LOS TWEETS
#grep("(RT|via)((?:\\b\\W*@\\w+)+)", tweets, ignore.case=TRUE, value=TRUE)

# ALMACENA LOS TWEETS QUE SON RETWEETS
rt_patterns = grep("(RT|via)((?:\\b\\W*@\\w+)+)", tweet_txt, ignore.case=TRUE)

# SOLO MUESTRA LOS TWEETS QUE SON RETWEETS
tweet_txt[rt_patterns]

#VISUALIZANDO EL GRAFO
# Creamos una lista para guardar a los usuario
quien_retweeteo = as.list(1:length(rt_patterns))
quien_posteo = as.list(1:length(rt_patterns))

# for loop
#Itera todos los tweets que son retweets
for (i in 1:length(rt_patterns))
{
  # Obtiene el retweet
  twit = tweets[[rt_patterns[i]]]
  # Obtinen el tweet original (retweet source)
  poster = str_extract_all(twit$getText(),"(RT|via)((?:\\b\\W*@\\w+)+)")
  #elimina ':'
  poster = gsub(":", "", unlist(poster))
  # Obtiene el nombre del usuario del tweet original
  quien_posteo[[i]] = gsub("(RT @|via @)", "", poster, ignore.case=TRUE)
  # Obtiene el nombre del usuario que retweeteo
  quien_retweeteo[[i]] = rep(twit$getScreenName(), length(poster))
}

# and we put it off the list
quien_posteo = unlist(quien_posteo)
quien_retweeteo = unlist(quien_retweeteo)

#GENERATE THE NETWORK GRAPH
# two column matrix of edges
retweeter_edges = cbind(quien_retweeteo, quien_posteo)

# generate graph
rt_graph = graph.edgelist(retweeter_edges)

# get vertex names  
ver_labs = get.vertex.attribute(rt_graph, "name", index=V(rt_graph))

#PLOT THE GRAPH
# choose some layout

glay = layout_with_kk(rt_graph)

# plot
par(bg="white", mar=c(1,1,1,1))
plot(rt_graph, layout=glay,
     vertex.color="green",
     vertex.size=10,
     vertex.label=ver_labs,
     vertex.label.family="sans",
     vertex.shape="circle",
     vertex.label.color=hsv(h=.165, s=.28, v=.08, alpha=1),
     vertex.label.cex=0.85,
     edge.arrow.size=0.8,
     edge.arrow.width=0.5,
     edge.width=3,
     edge.color=hsv(h=0, s=1, v=1, alpha=1))
# edge.color=("#408080")
# add title
title("nTweets on #AvionPresidencial : Quien retweeteo a quien",
      cex.main=1, col.main="black")
