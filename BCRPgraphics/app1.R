

# Loading libraries

library(shiny)
library(BCRPR)
library(shinydashboard)
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
library(dygraphs)
library(rsconnect)
library(gapminder)
library(ggplot2)
library(shiny)
library(gganimate)
library(shinydashboard)
library(tidyverse)
library(gganimate)
library(gifski)
library(shiny)
library(plotly)
library(DT)
library(gt)
library(gt)
library(htmltools)
library(ggplot2)
library(gapminder)
library(dplyr)
library(ggplot2)
library(gifski)
library(Rcpp)
library(dplyr)
library(gganimate)
library(remotes)
library(gtExtras)
library(googleVis)
library(readxl)
library(plotly)
library(xkcd)
library(apexcharter)
library(shinyWidgets)

inflacion12<-importbcrp('PN01273PM','2006','2022')
inflacionen<-importbcrp('PN01277PM','2006','2022')
expinf<-importbcrp('PD12912AM','2006','2022')
tasref<-importbcrp('PD04722MM','2006','2022')


inflacion12<-inflacion12[,2]
inflacionen<-inflacionen[,2]
expinf<-expinf[,2]
tasref<-tasref[,2]

inflacion12<-as.numeric(inflacion12)
inflacionen<-as.numeric(inflacionen)
expinf<-as.numeric(expinf)
tasref<-as.numeric(tasref)

inflacion12<-round(inflacion12,2)
inflacionen<-round(inflacionen,2)
expinf<-round(expinf,2)
tasref<-round(tasref,2)

Date <- seq(as.Date("2006-01-01"),as.Date("2021-09-01"),"month")
bd<-cbind(inflacion12, inflacionen,expinf,tasref,Date)
merge(bd, Date, join = "inner")
bd<-as.data.frame(bd)
bd$Date <- as.Date(bd$Date)
bd_gt <- gt(bd)
bd_gt


plus_percent <- function(.x) {
  glue::glue("{.x}%")
}
bd_gt <- bd_gt %>%
  fmt("inflacion12", fns = plus_percent) %>%
  fmt("inflacionen", fns = plus_percent) %>%
  fmt("expinf", fns = plus_percent)%>%
  fmt("tasref", fns = plus_percent)

bd_gt<-as.data.frame(bd_gt)
#mobility$Province <- as.factor(mobility$Province)


ui <- fluidPage(
     setBackgroundColor(
       color = c("#F7FBFF", "#2171B5"),
       gradient = "radial",
       direction = c("top", "left")
     ),
  
  sidebarLayout(
    
    sidebarPanel(
      h2("BCRP Data"),
      
      selectInput(inputId = "dv", label = "Category",
                  choices = c(INFLACION_12MESES="inflacion12", 
                              INFLACION_SIN_ALIMENTO_NI_ENERGIA="inflacionen", 
                              EXPECTATIVAS_DE_INFLACION="expinf", 
                              TASA_DE_INTERES_REFERENCIA="tasref"),
                  selected = "inflacion12"),
      #selectInput(inputId = "provinces", "Province(s)",
      #           choices = levels(mobility$Province),
      #          multiple = TRUE,
      #         selected = c("Utrecht", "Friesland", "Zeeland")),
      dateRangeInput(inputId = "date", "Date range",
                     start = min(bd$Date),
                     end   = max(bd$Date)),
      downloadButton(outputId = "download_data", label = "Download"),
    ),
    mainPanel(
      plotlyOutput(outputId = "plot"), br(),
      em("Principales variables con datos actualizados del BCRP"),
      br(), br(), br(),
      DT::dataTableOutput(outputId = "table")
      
    )
  )
)

server <- function(input, output) {
  filtered_data <- reactive({
    subset(bd,
           Date >= input$date[1] & Date <= input$date[2])})
  filtered_data1 <- reactive({
    subset(bd_gt,
           Date >= input$date[1] & Date <= input$date[2])})
  #  grafico1<-bd 
  #  grafico1<-xts(grafico1,order.by = fechas)
  #  grafico1 + transition_reveal(fechas)
  #  rubros_funnel<-dygraph(grafico1)   
  output$plot <- renderPlotly({
    ggplotly({
      p <- ggplot(filtered_data(), aes_string(x="Date", y=input$dv, colour="input$dv "))  + 
        geom_line(size = 1.5) +
        geom_point(size=1)  +
        ylab("% ")
      
      p
    })
  })
  
  output$table <- DT::renderDataTable(server = FALSE,rownames = FALSE,{
    filtered_data1()
    
  
  })
  
  output$download_data <- downloadHandler(
    filename = "download_data.csv",
    content = function(file) {
      data <- filtered_data()
      write.csv(data, file, row.names = FALSE)
    }
  )
  
}

shinyApp(ui = ui, server = server)
