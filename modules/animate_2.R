
library(gapminder)
library(dplyr)
library(ggplot2)
library(gifski)
library(Rcpp)
library(dplyr)
library(gganimate)

inflacion<-importbcrp('PN01205PM','2006','2021')
inflacion<-inflacion[,2]
inflacion<-as.numeric(inflacion)
fechas <- seq(as.Date("2006-01-01"),as.Date("2020-12-01"),"month")
#fechas <- format(fechas, format="%b %Y ")
bd<-cbind(inflacion)
merge(bd, fechas, join = "inner")
bd<-as.data.frame(bd)
dinamico<-bd %>%
  ggplot(aes(x= fechas,
             y= inflacion, 
             color = inflacion)) +
  geom_line(size=2) +
  geom_point(size=1) +
  labs(title = 'Inflacion-Peru en {frame_along}',
       x = 'Fecha',
       y = 'Inflacion') +
  theme_minimal() +
  transition_reveal(fechas)
dinamico
anim_save("outfile.gif", animate(dinamico))

