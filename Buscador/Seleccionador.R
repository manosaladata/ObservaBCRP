library(shiny)
library(shinydashboard)
ui = dashboardPage(
  dashboardHeader(title="BuscadorBCRP"),
  dashboardSidebar(
    sidebarMenu(
      selectInput("choose",
                             label="Categoria",
                             choices = c("Moneda_credito","Precios","Tipo_cambio","Balanza de Pagos","PBI","Finanzas_Publicas","Indicadores_Internacionales",
                                         "Indicadores_Coyuntura_Economica", "Informacion_Regional","Compendio_Historia_Economica")),
       
      
      
      selectInput("choose",
                             label="Categoria",
                             choices = c("Moneda_credito","precios")),
      
      
      menuItem("Seccion 1", tabName = "p1", icon=icon("dashboard")),
      menuItem("Seccion 2", tabName = "p2", icon=icon("users")),
      fileInput(inputId='archivo',
                label="Importa tu archivo:")
    )
  ),
  dashboardBody(),
  tags$head(
    tags$img(src='122.jpg',height='80',width='230'),
    
  )
)
server = function(input, output) {
}
shinyApp(ui, server)