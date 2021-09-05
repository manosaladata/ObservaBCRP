## Only run this example in interactive R sessions

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

headlines[1:10]
vehicles[1:10]
times[1:10]
tb_news <- tibble(headlines, vehicles, times)



if (interactive()) {
  # table example
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
  )
  
  
  # DataTables example
  shinyApp(
    ui = fluidPage(
      fluidRow(
        column(5,
               dataTableOutput('table')
        )
      )
    ),
    server = function(input, output) {
      output$table <- renderDataTable(tb_news)
    }
  )
}















