library(shiny)
library(shinydashboard)
library(BCRPR)
library(xts)
library(dygraphs)
library(plotly)

######MODULIZANDO#######
source("modules/ggplot_mod.R")

convertMenuItem <- function(mi,tabName) {
  mi$children[[1]]$attribs['data-toggle']="tab"
  mi$children[[1]]$attribs['data-value'] = tabName
  if(length(mi$attribs$class)>0 && mi$attribs$class=="treeview"){
    mi$attribs$class=NULL
  }
  mi
}

###### header
header <- dashboardHeader(title = "BCRPRDATOS")

###### siderbar
sidebar <- dashboardSidebar(
  sidebarUserPanel("DESDOLARIZACIONUSD$",
                   subtitle = a(href = "#", icon("circle", class = "text-success"), "Online"),
                   # Image file should be in www/ subdir
                   image = "https://www.notiultimas.com/wp-content/uploads/2017/01/dolar-asustado.png"
  ),
  
  
  sidebarMenu(
    tags$head(tags$style(HTML('
        a[href="#shiny-tab-widgets"] {
          z-index: -99999;
        }
        a[href="#"] {
          z-index: -99999;
        }
      ')),
    
    # Setting id makes input$tabs give the tabName of currently-selected tab
    id = "tabs",
    menuItem("InfoGeneral", tabName = "dashboard", icon = icon("dashboard")),
  
    convertMenuItem(menuItem("AnalisisUnivariado",tabName = "charts1", icon = icon("bar-chart-o"),selected = T,
                             menuSubItem("Inflation", tabName = "subitem1"),
                             menuSubItem("Embi", tabName = "subitem2"),
                             menuSubItem("TcNominal", tabName = "subitem3"),
                             menuSubItem("BonosSoberanos", tabName = "subitem4")),"charts1"),
    
    convertMenuItem(menuItem("AnalisisBivariado",tabName = "charts", icon = icon("bar-chart-o"),selected = T,
                            menuSubItem("Sub-item 3", tabName = "subitem3"),
                            menuSubItem("Sub-item 4", tabName = "subitem4")),"charts"),
    
        
    )
  )
  
  ####
  )


##### body
body <- dashboardBody(
  
  tabItems(
    tabItem("InfoGeneral",
            div(p("Dashboard tab content"))
    ),
    tabItem("AnalisisUnivariado",
          
    ),
    tabItem(tabName = "subitem1",fluidRow(
            box(status="primary",solidHeader = T  ,width = 10,title="INFLACION",plotly1UI(("grafico2"))
            ))
    ),     
            

    tabItem("subitem2",
            "Sub-item 2 tab content"
    ),
    tabItem("subitem3",
            "Sub-item 3 tab content"
    ),
    tabItem("subitem4",
            "Sub-item 4 tab content"
    ),
    
  
    tabItem("AnalisisBivariado",
            "tab content"
    ),
    tabItem("subitem3",
            "Sub-item 3 tab content"
    ),
    tabItem("subitem4",
            "Sub-item 4 tab content"
    ),
   
    
  )
)



#### Run  App
shinyApp(
  ui = dashboardPage(header, sidebar, body),
  server = function(input, output) { }
)
