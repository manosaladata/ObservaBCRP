
# clean everything --------------------------------------------------------

rm(list=ls(all=TRUE))


# load maps ---------------------------------------------------------------

library(ggmap)
library(ggplot2)
library(raster)
library(maptools)

# first map of Brazil -----------------------------------------------------

mapa <- borders("world", regions = c("peru"), 
                fill = "grey70", colour = "black")

ggplot() + mapa + theme_bw() + xlab("Longitude (decimals)") + ylab("Latitude (decimals)") + 
  theme(panel.border = element_blank(), panel.grid.major = element_line(colour = "grey80"), panel.grid.minor = element_blank())

############################
###         NEWS          ##        
############################

library(dplyr) # for pipes and the data_frame function
library(rvest) # webscraping
library(stringr) # to deal with strings and to clean up our data

# extracting the whole website
google <- read_html("https://news.google.com/topstories?hl=es-419&gl=PE&ceid=PE%3Aes-419")
article_all <- google %>% html_nodes("article")

times <- article_all %>%
  html_node("time") %>%
  html_text()

vehicles <- article_all %>%
  html_nodes("a.wEwyrc.AVN2gc.uQIVzc.Sksgp") %>%
  html_text()

headlines <- article_all %>%
  html_nodes("a.DY5T1d") %>%
  html_text()


tb_news <- tibble(headlines, vehicles, times)
tb_news






#########################
inflacion<-importbcrp('PN01205PM','2011','2021')
inflacionsub<-importbcrp('PN01278PM','2011','2021')
inflacion<-inflacion[,2]
inflacionsub<-inflacionsub[,2]
inflacion<-as.numeric(inflacion)
inflacionsub<-as.numeric(inflacionsub)
fechas <- seq(as.Date("2011-01-01"),as.Date("2020-12-01"),"month")
#fechas <- format(fechas, format="%b %Y ")
bd<-cbind(inflacion,inflacionsub)
merge(bd, fechas, join = "inner")
bd<-as.data.frame(bd)
grafico1<-bd 
grafico1<-xts(grafico1,order.by = fechas)
rubros_funnel<-dygraph(grafico1) 
#########################
dolar<-importbcrp('PD09873MA','1980','2020')
dolar<-dolar[,2]
dolar<-as.numeric(dolar)
fechas <- seq(as.Date("1980-01-01"),as.Date("2020-12-01"),"year")
merge(dolar, fechas, join = "inner")
dolar<-as.data.frame(dolar)
grafico2<-dolar
grafico2<-xts(grafico2,order.by = fechas)
dygraph(grafico2)
acdo<-dolar[41,]
#########################
