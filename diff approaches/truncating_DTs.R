library(data.table)
setwd("data")


get_scores <- function(DT) {
    DT[, c("root", "prediction") := 
           tstrsplit(word, " (?=[^ ]*$)", perl = TRUE)][, word := NULL] 
    #splitting at last whitespace, much faster than 'stringr::word'
    DT[, root.n := sum(n), by = root] #count frequencies of 'root'
    DT[, score := n/root.n]
    setcolorder(DT, c(2,3,4,1,5))
    DT
}


system.time(load("full RData/dt5.RData"))
dt5s <- dt5[n > 1]
rm(dt5)
system.time(get_scores(dt5s))
save(dt5s, file = "full RData/dt5s.RData")
## RESTART SESSION ##


system.time(load("full RData/dt4.RData"))
dt4s <- dt4[n > 1]
rm(dt4)
system.time(get_scores(dt4s))
save(dt4s, file = "full RData/dt4s.RData")
## RESTART SESSION ##


system.time(load("full RData/dt3.RData"))
dt3s <- dt3[n > 1]
rm(dt3)
system.time(get_scores(dt3s))
save(dt3s, file = "full RData/dt3s.RData")
## RESTART SESSION ##


system.time(load("full RData/dt2.RData"))
dt2s <- dt2[n > 1]
rm(dt2)
system.time(get_scores(dt2s))
save(dt2s, file = "full RData/dt2s.RData")
## RESTART SESSION ##




