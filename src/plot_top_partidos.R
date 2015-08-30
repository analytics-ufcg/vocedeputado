library(dplyr)
library(ggplot2)
library(scales)

df_top = read.table("top_deputados_por_usuario.dat", header = T)

n_users = length(unique(df_top$usuario))
n_temas = length(unique(df_top$tema))

dff = df_top %>% group_by(nome_dep) %>% 
  mutate(partido = partido_dep) %>% 
  summarise(total = n(), freq = n() / (n_users * n_temas)) %>% 
  arrange(desc(freq))

df_plot = dff %>% 
  left_join(group_by(df_top, nome_dep), by="nome_dep") %>% 
  select(nome_dep, total, freq, partido_dep) %>% 
  distinct()

partidos = select(df_plot, partido_dep, freq, total_partido = total)
partidos = partidos %>%
  group_by(partido_dep) %>%
  summarise( votos_partido = sum(total_partido))

partidos = partidos %>%
  mutate(freq = votos_partido / sum(df_plot$total))

to_plot_repr_por_partido = arrange(partidos, desc(freq))
to_plot_repr_por_partido$destaque = to_plot_repr_por_partido$partido_dep %in% c('pt','pmdb','pcdob','psb', 'psd' , 'psdb', 'dem')

p = ggplot(df_plot, aes(as.numeric(partido_dep), freq))
p = p + geom_jitter(size = 3, color = "gray", alpha = 0.5)
p = p + geom_text(show_guide = TRUE, vjust=-0.2, vjust=-0.25, hjust=0, data = filter(to_plot_repr_por_partido, destaque == TRUE),
                  aes(x=as.numeric(partido_dep), y=freq, label=toupper(partido_dep), 
                      colour=toupper(partido_dep)), position = "jitter", size = 6)
p = p + scale_colour_hue("Partido", guide=guide_legend(override.aes=list(size=10, shape = utf8ToInt("A"))))
p = p + scale_y_continuous(labels = percent, limit = c(0,0.3))
p = p + xlab(NULL) + ylab("Representatividade")
p = p + theme_bw()
p = p + theme(axis.ticks = element_blank(), axis.text.x = element_blank()) + theme(text = element_text(size=20))
print(p)