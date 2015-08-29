library(foreach)
library(doMC)
library(dplyr)

df_user = read.csv("../data/out.csv")
df_dep  = read.csv("../data/out_dep.csv")

args      = commandArgs(trailingOnly = TRUE)
num_cores = as.integer(args[1])
users     = as.character(unique(df_user$usuario))

dfa = df_user %>% filter(usuario == users[1]) %>% full_join(df_dep, by="tema")  

try(system(paste("echo ", length(users), " > result.out", sep=""), intern = TRUE))

registerDoMC(cores=num_cores)
x <- foreach(i = 1:length(users), .combine='cbind') %dopar% {

    u = users[i]
    
    try(system(paste("echo ", u, " >> result.out", sep=""), intern = TRUE))
  
    dfx = df_user %>% filter(usuario == u) %>% full_join(df_dep, by="tema")  
    dff = data.frame(dfx)
    
    names(dff) = c("tema","usuario", "lat", "lon", "opiniao_usuario", "data", "partido_dep", "nome_dep", "uf_dep", "id_dep", "opiniao_dep")
    
    dff
}

names(x) = c("tema","usuario", "lat", "lon", "opiniao_usuario", "data", "partido_dep", "nome_dep", "uf_dep", "id_dep", "opiniao_dep")

file_name     = "opinioes_user_deputados.dat"

write.table(x, file=file_name, row.names=FALSE)

  
  