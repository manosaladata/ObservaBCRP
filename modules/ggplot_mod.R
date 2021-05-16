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
grafico2<-dygraph(grafico1)

plotly1UI<-function(id) {plotlyOutput(NS(id,"grafico2"))}

plotly1Server<-function(id){
  moduleServer(id, function(input, output, session) {
    output$grafico2<-renderPlotly(({grafico2}))})}



tc<-importbcrp('RD38112BM','2005','2007')

