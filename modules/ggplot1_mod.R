library(rvest)
library(httr)
library(xml2)
library(jsonlite)
library(tidyverse)
library(tidytext)
library(lubridate)
library(scales)
library(xts)
library(BCRPR)
library(dygraphs)

#buscar_indicador('diarias','bolsa-internacional')
#buscar_indicador('mensuales','indice-de-precios-variacion-mensual')

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

plotly1UI<-function(id) {plotlyOutput(NS(id,"rubros_funnel"))}

plotly1Server<-function(id){
  moduleServer(id, function(input, output, session) {
    output$rubros_funnel<-renderPlotly(({rubros_funnel}))})}

dolar<-importbcrp('PD09873MA','1980','2020')
dolar<-dolar[,2]
dolar<-as.numeric(dolar)
fechas <- seq(as.Date("1980-01-01"),as.Date("2020-12-01"),"year")
merge(dolar, fechas, join = "inner")
dolar<-as.data.frame(dolar)
grafico2<-dolar
grafico2<-xts(grafico2,order.by = fechas)
dygraph(grafico2)




