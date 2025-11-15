library(shiny)
library(blacksummer)
library(dplyr)
library(ggplot2)
library(bslib)

ui <- fluidPage(
  theme = bs_theme(bootswatch = "flatly"),
  titlePanel("🔥 Black Summer Bushfire Risk Explorer"),
  
  sidebarLayout(
    
    sidebarPanel(
      h3("Controls"),
      
      selectInput(
        "index",
        "Choose an Index:",
        choices = unique(bushfire_risk$index)
      ),
      
      selectInput(
        "metric_choice",
        "What do you want to explore?",
        choices = c(
          "Baseline vs Current Probability",
          "Risk Ratio vs Lower Bound"
        )
      ),
      
      hr(),
      p("Data source: van Oldenborgh et al. (2021)")
    ),
    
    mainPanel(
      h3("Interactive Visualization"),
      
      plotOutput("main_plot", height = "350px"),
      
      hr(),
      h3("Summary Table"),
      tableOutput("summary_table"),
      
      hr(),
      h3("Interpretation Guide"),
      p("• Probabilities show how often extreme conditions occur."),
      p("• Risk ratio shows how much MORE LIKELY fire weather is today."),
      p("• Lower bound is a conservative estimate used by scientists.")
    )
  )
)

server <- function(input, output, session){
  
  selected_row <- reactive({
    bushfire_risk |> filter(index == input$index)
  })
  
  output$main_plot <- renderPlot({
    row <- selected_row()
    
    if (input$metric_choice == "Baseline vs Current Probability") {
      
      df <- data.frame(
        Scenario = c("Baseline Climate", "Current Climate"),
        Probability = c(row$baseline_prob, row$current_prob)
      )
      
      ggplot(df, aes(x = Scenario, y = Probability, fill = Scenario)) +
        geom_col() +
        scale_fill_manual(values = c("#1f77b4", "#ff7f0e")) +
        labs(
          title = paste("Probability Shift for", row$index),
          y     = "Probability"
        ) +
        theme_minimal(base_size = 14)
      
    } else {
      
      df <- data.frame(
        Scenario = c("Risk Ratio", "Conservative Lower Bound"),
        Value    = c(row$risk_ratio, row$lower_bound)
      )
      
      ggplot(df, aes(x = Scenario, y = Value, fill = Scenario)) +
        geom_col() +
        scale_fill_manual(values = c("#d62728", "#2ca02c")) +
        labs(
          title = paste("Risk Ratio Comparison for", row$index),
          y     = "Risk Factor (×)"
        ) +
        theme_minimal(base_size = 14)
    }
  })
  
  output$summary_table <- renderTable({
    selected_row()
  })
}

shinyApp(ui, server)
