library(foreach)
library(doMC)
library(dplyr)

df_user = read.csv("../data/out.csv")
df_dep  = read.csv("../data/out_dep.csv")

users   = as.character(unique(df_user$usuario)) 

head(df_dep)

unique(df_user$opiniao)

dff = c()

for(i in length(users):1){
  
  u = users[i]
  
  file_name     = paste("users/opinioes_user_deputados_", u, ".dat", sep="")
  
  if(!file.exists(file_name)){
    
    print(i/length(users) * 100)
  
    dfx = df_user %>% filter(usuario == u) %>% full_join(df_dep, by="tema") %>% group_by(usuario, nome) %>% mutate(total = n()) %>% filter(opiniao == s_opiniao) %>% mutate(factor = n()/total*100) %>% arrange(desc(factor))
  
    file_name     = paste("users/opinioes_user_deputados_", u, ".dat", sep="")
    write.table(dff, file=file_name, row.names=FALSE, col.names = FALSE)
  
    dff = rbind(dff, dfx)  
    
  }
  
}

#dfx %>% ungroup %>% select(usuario, partido, nome, uf, factor) %>% distinct() %>% arrange(desc(factor))

file_name     = "opinioes_user_deputados.dat"
write.table(dff, file=file_name, row.names=FALSE, col.names = FALSE)


