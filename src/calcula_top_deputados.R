library(foreach)
library(doMC)
library(dplyr)

df_user = read.csv("../data/out.csv")
df_dep  = read.csv("../data/out_dep.csv")

args      = commandArgs(trailingOnly = TRUE)
num_cores = as.integer(args[1])
users     = as.character(unique(df_user$usuario))

df_result = c()

registerDoMC(cores=num_cores)
x <- foreach(i = 1:length(users), .combine='cbind') %dopar% {

    u = users[i]
    
    try(system(paste("echo ", i/length(users)*100, " > result.out", sep=""), intern = TRUE))
  
    dfx = df_user %>% filter(usuario == u) %>% full_join(df_dep, by="tema") %>% group_by(usuario, nome) %>% mutate(total = n()) %>% filter(opiniao == s_opiniao) %>% mutate(factor = n()/total*100) %>% arrange(desc(factor))
    
    dff = dfx %>% ungroup() %>% group_by(tema, usuario) %>% arrange(desc(factor)) %>% top_n(1)
    print(dff, n = 100)
    
    file_name     = paste("users/opinioes_user_deputados_", u, ".dat", sep="")
    write.table(dff, file=file_name, row.names=FALSE, col.names = FALSE)
    
    #df_result = rbind(df_result, dff)
}

#names(df_result)  = c("tema","usuario", "lat", "lon", "opiniao_usuario", "data", "partido_dep", "nome_dep", "uf_dep", "id_dep", "opiniao_dep", "total_prop", "factor")

#file_name         = "top_deputados_por_usuario.dat"
#write.table(df_result, file=file_name, row.names=FALSE)
