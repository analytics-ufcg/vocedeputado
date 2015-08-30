library(dplyr)
library(ggplot2)
library(scales)

df_top = read.table("top_deputados_por_usuario.dat", header = T)

n_users = length(unique(df_top$usuario))
n_temas = length(unique(df_top$tema))
head()

dff = df_top %>% group_by(nome_dep) %>% mutate(partido = partido_dep) %>% summarise(total = n(), freq = n() / (n_users * n_temas)) %>% arrange(desc(freq))
  
df_plot = dff %>% left_join(group_by(df_top, nome_dep), by="nome_dep") %>% select(nome_dep, total, freq, partido_dep) %>% distinct()

desq_freq = unique(df_plot$freq)[1:5]

df_plot$destaque = df_plot$freq %in% desq_freq

p = ggplot(df_plot, aes(as.numeric(nome_dep), freq))
p = p + geom_jitter(size = 3, color = "gray70", alpha = 0.5)
p = p + geom_text(show_guide = TRUE, angle = 35, vjust=-0.25, hjust=0, data = filter(df_plot, destaque == TRUE), aes(x=as.numeric(nome_dep), y=freq, label=nome_dep, colour=toupper(partido_dep)), position = "jitter", size = 6)
p = p + scale_colour_hue("Partido", guide=guide_legend(override.aes=list(size=10, shape = utf8ToInt("A"))))
p = p + scale_y_continuous(labels = percent, limit = c(0,0.115))
p = p + xlab(NULL) + ylab("Representatividade")
p = p + theme_bw()
p = p + theme(axis.ticks = element_blank(), axis.text.x = element_blank()) + theme(text = element_text(size=20))
print(p)

library(grid)
grid.gedit("^key-[-0-9]+$", label = "N")