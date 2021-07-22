library(shiny)
library(shinydashboard)
library(BCRPR)
library(xts)
library(dygraphs)
library(plotly)
library(dplyr) 
library(rvest) 
library(stringr)
#####################################
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
    menuItem("AnalisisUnivariado",id = "charts1", icon = icon("arrow-alt-circle-right"),#badgeLabel = "Importante",badgeColor ="red",
             menuSubItem("inflation", tabName = "subitem1"),
             menuSubItem("Embi",tabName = "subitem2"),
             menuSubItem("TcNominal",tabName = "subitem3"),
             menuSubItem("BonosSoberanos",tabName="subitem4")
    ),
    menuItem("AnalisisBivariado",id = "chartsID",icon = icon("arrow-alt-circle-right"),
             menuSubItem("Inlacion-InflacionS",tabName = "rubros_funnel"),    #MÃ¡s icons:https://fontawesome.com/icons?d=gallery
             menuSubItem("Tc-tc", tabName = "funnel_n")
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
            div(style="font-size: 100%; width:100%;overflow-x: scroll",
                
                fluidRow(
                  infoBox(
                    "Coef_Dolarizacion_actual", 3 , "(%)", icon = icon("line-chart"), color = "green"
                  ),
                  column(width = 4,
                         imageOutput("manos", width="50%",height="150px")
                  )
                ),
                
                
                #fluidRow(column(width=8,
                #                infoBox("Transparencia","100%",icon=icon("thumbs-up")),
                #               infoBox("Dato abiertos", "100%"),
                #)
                
                #),
                if (interactive()) {
                  shinyApp(
                    ui = fluidPage(
                      fluidRow(
                        column(12,
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
