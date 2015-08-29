library(foreach)
library(doMC)
library(dplyr)

df_user = read.csv("../data/out.csv")
df_dep  = read.csv("../data/out_dep.csv")

args      = commandArgs(trailingOnly = TRUE)
num_cores = as.integer(args[1])
users     = as.character(unique(df_user$usuario))

registerDoMC(cores=num_cores)
x <- foreach(i = 1:length(users), .combine='cbind') %dopar% {

    u = users[i]
    
    try(system(paste("echo ", i/length(users), " > result.out", sep=""), intern = TRUE))
  
    dfx = df_user %>% filter(usuario == u) %>% full_join(df_dep, by="tema") %>% group_by(usuario, nome) %>% mutate(total = n()) %>% filter(opiniao == s_opiniao) %>% mutate(factor = n()/total*100) %>% arrange(desc(factor))
  
    file_name     = paste("users/opinioes_user_deputados_", u, ".dat", sep="")
    write.table(dfx, file=file_name, row.names=FALSE, col.names = FALSE)
}


#names(x) = c("tema","usuario", "lat", "lon", "opiniao_usuario", "data", "partido_dep", "nome_dep", "uf_dep", "id_dep", "opiniao_dep")

#file_name     = "opinioes_user_deputados.dat"

#write.table(x, file=file_name, row.names=FALSE)

  
  
