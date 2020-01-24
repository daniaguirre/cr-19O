library(Rfacebook)

oauth <- fbOAuth(app_id = "253004429005763",
                 
                 app_secret = "42eb45da47f1390dfc1369e149ff2156",
                 
                 extended_permissions = "public_profile,user_friends")


save(oauth, file="fb_oauth")



    # Get friend info:
    my.friends <- getFriends(oauth, simplify=F)
    # Get friend network in two formats, matrix and edge list:
    fb.net.mat <- getNetwork(oauth, format="adj.matrix")+0 
    # bool,+0 to get numeric
    fb.net.el <- as.data.frame(getNetwork(oauth, format = "edgelist"))