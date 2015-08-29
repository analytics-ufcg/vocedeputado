setwd("~/Projects/eudeputado")
repostas = read.csv("data/respostas.csv",stringsAsFactors=FALSE)
library(dplyr)
by_tailnum <- group_by(flights, tailnum)
grouped <-repostas %>%
  group_by(tema,opiniao) %>%
    summarise(
      arr = n()
    ) 
