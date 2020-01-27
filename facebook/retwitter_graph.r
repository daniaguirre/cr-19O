library(twitteR)
library(stringr)
library(igraph)

#INFORMACION DE LA APP
api_key <- "z5zA30mP0tnu6QxYZQKmAOYd2"
api_secret <- "JTqIVp7oQOeo8oXhWuQWW8f9Z6dmxCihT19wLThIyB8keNQT0W"
access_token <- "213082131-4jTcuzi93NGyLSwzC3mngA13R1lVWewhMIvR43nS"
access_token_secret <- "97vnYbxo0pnJszhHXtn9aSc3VtkoAnOvbqMqcpptCUI7O"

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

# convertimos a listas
quien_posteo = unlist(quien_posteo)
quien_retweeteo = unlist(quien_retweeteo)

# obtenemos la lista de enlaces
retweeter_edges = cbind(quien_retweeteo, quien_posteo)

# generamos un objeto de tipo grafo
rt_graph = graph.edgelist(retweeter_edges)

#renombramos las columnas de los enlace
colnames(retweeter_edges) <- c("Target", "Source")

#Creamos el archivo de enlaces
write.csv(retweeter_edges, file="retweeter-EDGES.csv", row.names=F)

#Obtenemos las etiquetas de los nodos
ver_labs = get.vertex.attribute(rt_graph, "name", index=V(rt_graph))
#Creamos el archivo de nodos
write.csv(ver_labs, file="retweeter-NODES.csv", row.names=F)