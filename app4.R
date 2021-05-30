library(shiny)
library(shinydashboard)
library(BCRPR)
library(xts)
library(dygraphs)
library(plotly)


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
#########################
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
    menuItem("AnalisisUnivariado",id = "charts1", icon = icon("arrow-alt-circle-right"),#badgeLabel = "Importante",badgeColor ="red",
             menuSubItem("inflation", tabName = "subitem1"),
             menuSubItem("Embi",tabName = "subitem2"),
             menuSubItem("TcNominal",tabName = "subitem3"),
             menuSubItem("BonosSoberanos",tabName="subitem4")
    ),
    menuItem("AnalisisBivariado",id = "chartsID",icon = icon("arrow-alt-circle-right"),
             menuSubItem("Inlacion-InflacionS",tabName = "rubros_funnel"),    #MÃ¡s icons:https://fontawesome.com/icons?d=gallery
             menuSubItem("Por NÃºmero de Contratos", tabName = "funnel_n")
    ),
    #menuSubItem("Entidades por Monto",tabName="entidt_mon")),
    menuItem("Aplicación Econometrica", tabName = "eco",icon = icon("arrow-alt-circle-right")),
    menuItem("Aplicación Macrodinámica",tabName = "macro",icon = icon("arrow-alt-circle-right")),
    menuItem("API para desarrolladores", tabName="api",icon = icon("arrow-alt-circle-right")),
    menuItem("BCRP-search", tabName="busca",icon = icon("arrow-alt-circle-right")),
    menuItem("Repositorio de Git-Hub",tabName = "Git-Hub", icon=icon("github-square")),
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
            div(#style="font-size: 100%; width:100%;overflow-x: scroll",
                
                #div(style="font-size: 100%; width:100%;overflow-x: scroll",
                
                #fluidRow(
                 # column(width=8,  
                  #       valueBox("9 Meses","Periodo: Marzo-Diciembre",icon=icon("hourglass-3"),color="yellow"),
                   #      valueBoxOutput("num"),
                         #valueBox("xx", "Monto Total", color = "green"),
                    #     valueBoxOutput("monto"),
                         #infoBoxOutput("info"),
                         
                  #)
                  #,column(width = 4,
                   #       imageOutput("manos", width="50%",height="150px")
                  #)
                #),
               
                
                #fluidRow(column(width=8,
                                infoBox("Transparencia","100%",icon=icon("thumbs-up")),
                                infoBox("Dato abiertos", "100%"),
                #)
               
                #),
                
                fluidRow(
                  box(title="Coeficiente de Dolarizacion (%)",status="primary",
                      solidHeader = T,dygraph(grafico2),
                      width=12, height=500)
                  ,
                  #box(dolar, width=4)
                  
                  
                  
                ))
            
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
      box(status="primary",solidHeader = T  ,width = 12,title="INFLACION VS INFLACION SUBYACENTE",dygraph(grafico1))
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
