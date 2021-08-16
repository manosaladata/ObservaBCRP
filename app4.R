library(shiny)
library(shinydashboard)
library(BCRPR)
library(xts)
library(dygraphs)
library(plotly)
library(dplyr) 
library(rvest) 
library(stringr)
library(ggmap)
library(ggplot2)
library(raster)
library(maptools)
library(rvest)
library(Rcpp)
library(httr)
library(xml2)
library(gganimate)
library(gifski)
library(jsonlite)
library(tidyverse)
library(tidytext)
library(lubridate)
library(scales)
library(xts)
library(BCRPR)
library(dygraphs)
library(rsconnect)
library(gapminder)
library(ggplot2)
library(shiny)
library(gganimate)
#####################################
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
anim_save("outfile.gif", animate(dinamico))
#####################################
google <- read_html("https://news.google.com/topstories?hl=es-419&gl=PE&ceid=PE%3Aes-419")
article_all <- google %>% html_nodes("article")
Hora <- article_all %>%
  html_node("time") %>%
  html_text()
Medio <- article_all %>%
  html_nodes("a.wEwyrc.AVN2gc.uQIVzc.Sksgp") %>%
  html_text()
Ultimas_Noticias <- article_all %>%
  html_nodes("a.DY5T1d") %>%
  html_text()
tb_news <- tibble(Ultimas_Noticias, Medio, Hora)
#########################
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
######################################
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
acdo<-round(acdo,2)
#####################################
###### header
header <- dashboardHeader(title = "BCRPRDATOS")
###### siderbar
sidebar <- dashboardSidebar(
  
  sidebarUserPanel("OBSERVA$DOLARIZACION",
                   subtitle = a(href = "#", icon("circle", class = "text-success"), "Online"),
                   # Image file should be in www/ subdir
                   image = "https://www.notiultimas.com/wp-content/uploads/2017/01/dolar-asustado.png"),
  
  sidebarMenu(                                 #Para crear un menÃº y se pueda abrir una nueva ventana por cada item.
    id="sidebarID",
    menuItem("Informacion General",tabName="map_mon", icon = icon("arrow-alt-circle-right")), #el tab Name=dep, permite relacionar el grÃÂ¡fico de dashboardBody
    menuItem("API para desarrolladores", tabName="api",icon = icon("arrow-alt-circle-right")),
    menuItem("BCRP-search", tabName="busca",icon = icon("arrow-alt-circle-right")),
    menuItem("Agradecimientos", tabName="gracias",icon = icon("hands")),
    menuItem("Donaciones", tabName = "dona", icon=icon("hand-holding-heart")),
    textInput("text_input","Contáctenos", value="asrodeno18@gmail.com"),
    
    textInput("text_input", "Aclaración", value="La información sobre sanciones y penalidades han sido obtenidas del buscador de proveedores y se actualiza cada cierto periodo (semanal o quincenal). En este sentido, es referencial. Para denuncias y otras cuestiones legales se debe verificar en la pÃ¡gina del Buscador de Proveedores. Para cualquier consulta u observaciÃ³n no dude en contactarse con nosotros.
                                ")
  ))

###### body
body <- dashboardBody(
  tabItems(
    tabItem(tabName = "map_mon",
            div(style="font-size: 100%; width:100%;overflow-x: scroll",
                
                fluidRow(
                  infoBox(
                    "Coef_Dolarizacion_actual", acdo , "(%)", icon = icon("line-chart"), color = "green"
                  ),
                  column(width = 4,
                         imageOutput("manos", width="50%",height="150px")
                  )
                ),
                
               mainPanel(
                  img(src="E:/GitHub/ObservaDolarizacion/outfile.gif", align = "left",height='250px',width='500px')
                ),
                
            
                
               
                  
                if (interactive()) {
                  shinyApp(
                    ui = fluidPage(
                      fluidRow(
                        column(7,
                               tableOutput('table')
                        )
                      )
                    ),
                    server = function(input, output) {
                      output$table <- renderTable(tb_news)
                    }
                  )})
            
            #,fluidRow(box(DT::dataTableOutput("ley")))
            # ,fluidRow(imageOutput("manos"))
            
    ),
    
    tabItem(tabName = "api",
            h1("API PARA DESARROLLADORES",style="font-family:Impact"),
            p(style="font-family:Impact", 
              "La Base de Datos de Estadísticas del BCRP (BCRPData) proporciona interfaces API para consultar series estadísticas desde otras aplicaciones Web. Las API pueden generar resultados en diversos formatos de 
              salida como HTML, Gráficos en FLASH, XLS, XML, JSON, JSONP, TXT y CSV.Consulte instrucciones en la ",
              a("Guía de Uso de API para Desarrolladores",
                href="https://estadisticas.bcrp.gob.pe/estadisticas/series/documentos/bcrpdataapi.pdf"))
            
    ),
   
     tabItem(tabName = "rubros_funnel",fluidRow(
      box(status="primary",solidHeader = T  ,width = 12,title="INFLACION VS INFLACION SUBYACENTE")
      ))),
     
   
  )

# Put them together into a dashboardPage
dashboardPage(
  dashboardHeader(title = "Simple tabs"),
  sidebar,
  body
)
#### Run App
shinyApp(
  ui = dashboardPage(header, sidebar, body),
  server = function(input, output) { }
)



