library(shiny)
library(blacksummer)
library(dplyr)
library(ggplot2)
library(bslib)
library(leaflet)

# ---- Metadata to explain each index ----------------------------------------

index_meta <- data.frame(
  index = c("FWI7x-SM", "MSR-SM", "TempExt", "RainDef"),
  
  nice_name = c(
    "FWI7x-SM – Fire Weather Index (7-day, Soil Moisture adjusted)",
    "MSR-SM – Multi-day Severe Fire Weather (Soil Moisture)",
    "TempExt – Extreme Temperature Indicator",
    "RainDef – Rainfall Deficit Indicator"
  ),
  
  what_it_measures = c(
    "A fire-weather index combining heat, wind and dryness averaged over 7 days, adjusted for soil moisture.",
    "How many multi-day periods experience severe fire-weather conditions, including soil dryness.",
    "How often extreme hot-temperature events occur during a season.",
    "How strongly rainfall deficits contribute to dangerously dry fuel conditions."
  ),
  
  why_important = c(
    "Dry soils + persistent heat increase the likelihood of dangerous fire conditions.",
    "Multi-day severe fire weather leads to prolonged windows where large fires can develop.",
    "Extreme heat dries out fuels, increases evaporation and boosts ignition risk.",
    "Rainfall deficits leave vegetation dry, making fuel more combustible and fire spread easier."
  ),
  
  region_desc = c(
    "South-eastern Australia, focusing on conditions that combine dryness and heat.",
    "South-eastern Australia, where Black Summer conditions aligned with record soil moisture deficits.",
    "Broad south-eastern Australia where extreme heat events are most impactful.",
    "Areas affected by prolonged dryness and rainfall shortages across south-eastern Australia."
  ),
  
  # Simple approximate map locations:
  lat = c(-34.5, -35.0, -33.8, -34.8),
  lon = c(148.0, 147.2, 149.0, 146.5),
  
  stringsAsFactors = FALSE
)
# ---- UI ---------------------------------------------------------------------

ui <- fluidPage(
  theme = bs_theme(
    bootswatch = "journal",
    primary = "#d9534f",
    secondary = "#5bc0de",
    base_font = font_google("Nunito"),
    heading_font = font_google("Poppins")
  ),
  
  # header
  div(
    style = "background: linear-gradient(90deg, #fff5f0, #ffe9e6);
             border-bottom: 1px solid #f5c6cb;
             padding: 24px 20px; margin-bottom: 10px;",
    fluidRow(
      column(
        8,
        h1("🔥 Black Summer Bushfire Risk Explorer",
           style = "font-weight:700; margin-top:0;"),
        p(
          "Explore how climate change has altered the probability and intensity of ",
          "bushfire-favourable weather in south-eastern Australia. ",
          "Use the controls to move between the historical climate and today’s warming world, ",
          "and see how key fire-weather indices have changed.",
          style = "font-size:16px; max-width:900px;"
        )
      ),
      column(
        4,
        div(
          style = "background-color:#ffffffcc; border-radius:14px;
                   padding:12px 16px; box-shadow:0 0 8px rgba(0,0,0,0.05);",
          strong("How to use this app"),
          tags$ul(
            tags$li("Pick a fire-weather indicator on the left."),
            tags$li("Switch climate worlds and watch probabilities change."),
            tags$li("Read the text panels to interpret what the numbers mean.")
          )
        )
      )
    )
  ),
  
  # Main layout
  sidebarLayout(
    sidebarPanel(
      width = 3,
      h3("Controls", style = "font-weight:600;"),
      div(
        style = "font-size:13px; color:#666; margin-bottom:10px;",
        "Start by choosing a fire-weather indicator. Each index summarises a ",
        "different aspect of dangerous bushfire conditions."
      ),
      
      selectInput(
        "index",
        "Fire-weather Indicator:",
        choices = setNames(index_meta$index, index_meta$nice_name),
        selected = "MSR-SM"
      ),
      
      radioButtons(
        "climate_world",
        "Climate World:",
        choices = c(
          "Historical climate (pre-industrial)" = "historical",
          "Current climate (~1°C warming)"      = "current",
          "Future climate (+2°C warming)"       = "future"
        ),
        selected = "current"
      ),
      
      sliderInput(
        "year_range",
        "Years shown in heat-trend simulation:",
        min = 1900,
        max = 2025,
        value = c(1980, 2025),
        sep = ""
      ),
      
      hr(),
      p(
        tags$span("💡 Tip:"),
        " These numbers come from climate-model attribution results for the 2019–2020 ",
        "Black Summer bushfire season.",
        style = "font-size:12px; color:#555;"
      ),
      p(
        tags$em("Source: van Oldenborgh et al. (2021)"),
        style = "font-size:11px; color:#777; margin-top:4px;"
      )
    ),
    
    mainPanel(
      width = 9,
      
      tabsetPanel(
        id = "main_tabs",
        
        # ---- Tab 1: Heat trend ------------------------------------------------
        tabPanel(
          title = "1. Heat Trend",
          br(),
          h3("Simulated Temperature Anomalies Over Time"),
          p(
            "This panel mimics the kind of temperature trends used in attribution studies. ",
            "Move the year slider or change the climate world to see how the ",
            "average anomaly shifts upwards in a warming climate."
          ),
          plotOutput("heat_plot", height = "320px"),
          br(),
          div(
            style = "background-color:#fdf8f5; border-radius:10px; padding:10px 14px;
                     border:1px solid #f5c6cb; font-size:13px;",
            strong("Interpretation: "),
            "Lines that sit higher on the y-axis represent warmer conditions. ",
            "In the future (+2°C) world, extreme heat events become both ",
            "hotter and more frequent, setting the stage for dangerous fire weather."
          )
        ),
        
        # ---- Tab 2: Probabilities & risk -------------------------------------
        tabPanel(
          title = "2. Probabilities & Risk",
          br(),
          h3("How Much More Likely is Extreme Fire Weather?"),
          p(
            "Here we compare the probability of extreme conditions between the ",
            "baseline (historical) climate and today’s (or future) climate for your ",
            "chosen index."
          ),
          
          fluidRow(
            column(
              6,
              h4("Probability of Extreme Conditions"),
              plotOutput("prob_plot", height = "260px")
            ),
            column(
              6,
              h4("Risk Ratio vs Lower Bound"),
              plotOutput("rr_plot", height = "260px")
            )
          ),
          
          br(),
          h4("Summary Values"),
          p("These are the exact model-derived values for the selected index:"),
          tableOutput("summary_table"),
          
          br(),
          h4("How to Read These Numbers"),
          tags$ul(
            tags$li("",
                    strong("Baseline probability"),
                    " – how often extreme fire-weather would occur in a pre-industrial climate."
            ),
            tags$li("",
                    strong("Current probability"),
                    " – how often the same conditions occur in today’s climate."
            ),
            tags$li("",
                    strong("Risk ratio"),
                    " – how many times more likely the event is today compared with baseline."
            ),
            tags$li("",
                    strong("Lower bound"),
                    " – a conservative ‘safe estimate’ that still shows a meaningful increase."
            )
          )
        ),
        
        # ---- Tab 3: Index & Region -------------------------------------------
        tabPanel(
          title = "3. Index & Region",
          br(),
          h3("Where and What Does This Index Represent?"),
          
          fluidRow(
            column(
              6,
              h4(textOutput("index_title")),
              tags$div(
                style = "background-color:#f9fbff; border-radius:10px;
                         padding:10px 14px; border:1px solid #d0e2ff;
                         font-size:13px;",
                strong("What does this index measure?"),
                p(textOutput("index_what"), style = "margin-bottom:6px;"),
                strong("Why is it important for bushfire risk?"),
                p(textOutput("index_why"), style = "margin-bottom:6px;"),
                strong("Region focus:"),
                p(textOutput("index_region"), style = "margin-bottom:0;")
              )
            ),
            column(
              6,
              h4("Approximate Region in South-Eastern Australia"),
              leafletOutput("region_map", height = "280px")
            )
          ),
          
          br(),
          div(
            style = "background-color:#fefbf4; border-radius:10px; padding:10px 14px;
                     border:1px solid #ffe8a1; font-size:13px;",
            strong("Why a regional view? "),
            "Attribution studies often focus on a specific region where conditions were extreme. ",
            "For the Black Summer bushfires, south-eastern Australia experienced a rare ",
            "combination of record heat, severe fire-weather indices, and natural climate drivers."
          )
        )
      )
    )
  )
)

# ---- SERVER -----------------------------------------------------------------

server <- function(input, output, session) {
  
  # Join main data with metadata for the selected index
  selected_row <- reactive({
    inner_join(
      bushfire_risk,
      index_meta,
      by = "index"
    ) |> 
      filter(index == input$index)
  })
  
  # ---- Heat trend simulation ----
  heat_data <- reactive({
    years <- 1900:2020
    base_trend <- seq(0, 2, length.out = length(years))  # gradual warming
    
    offset <- dplyr::case_when(
      input$climate_world == "historical" ~ -0.5,
      input$climate_world == "current"    ~ 0,
      input$climate_world == "future"     ~ 1
    )
    
    set.seed(42)
    temp <- rnorm(
      length(years),
      mean = base_trend + offset,
      sd = 0.35
    )
    
    data.frame(Year = years, Temp = temp)
  })
  
  output$heat_plot <- renderPlot({
    df <- heat_data() |>
      filter(Year >= input$year_range[1],
             Year <= input$year_range[2])
    
    world_label <- dplyr::case_when(
      input$climate_world == "historical" ~ "Historical climate (pre-industrial)",
      input$climate_world == "current"    ~ "Current climate (~1°C warming)",
      TRUE                                ~ "Future climate (+2°C warming)"
    )
    
    ggplot(df, aes(Year, Temp)) +
      geom_line(color = "#d9534f", linewidth = 1) +
      geom_smooth(method = "lm", se = FALSE, color = "#5bc0de") +
      labs(
        title = world_label,
        y = "Temperature anomaly (°C)",
        x = NULL
      ) +
      theme_minimal(base_size = 13) +
      theme(
        plot.title = element_text(face = "bold"),
        panel.grid.minor = element_blank()
      )
  })
  
  # ---- Probability plot ----
  output$prob_plot <- renderPlot({
    row <- selected_row()
    
    df <- data.frame(
      Scenario = c("Baseline climate", "Current climate"),
      Probability = c(row$baseline_prob, row$current_prob)
    )
    
    # If user chooses "future", scale up current_prob as a simple illustration
    if (input$climate_world == "future") {
      df$Probability[2] <- df$Probability[2] * 1.5
    }
    
    ggplot(df, aes(x = Scenario, y = Probability, fill = Scenario)) +
      geom_col(width = 0.6) +
      scale_fill_manual(values = c("#5bc0de", "#d9534f")) +
      labs(
        y = "Probability of extreme conditions",
        x = NULL
      ) +
      theme_minimal(base_size = 13) +
      theme(legend.position = "none")
  })
  
  # ---- Risk ratio plot ----
  output$rr_plot <- renderPlot({
    row <- selected_row()
    
    df <- data.frame(
      Scenario = c("Risk ratio", "Conservative lower bound"),
      Value    = c(row$risk_ratio, row$lower_bound)
    )
    
    ggplot(df, aes(x = Scenario, y = Value, fill = Scenario)) +
      geom_col(width = 0.6) +
      scale_fill_manual(values = c("#d9534f", "#5cb85c")) +
      labs(
        y = "Multiplicative change (×)",
        x = NULL
      ) +
      theme_minimal(base_size = 13) +
      theme(legend.position = "none")
  })
  
  # ---- Summary table ----
  output$summary_table <- renderTable({
    selected_row()[, c(
      "index", "region", "metric",
      "baseline_prob", "current_prob",
      "risk_ratio", "lower_bound"
    )]
  })
  
  # ---- Index / region text panels ----
  output$index_title   <- renderText(selected_row()$nice_name)
  output$index_what    <- renderText(selected_row()$what_it_measures)
  output$index_why     <- renderText(selected_row()$why_important)
  output$index_region  <- renderText(selected_row()$region_desc)
  
  # ---- Leaflet region map ----
  output$region_map <- renderLeaflet({
    row <- selected_row()
    
    leaflet() |>
      addProviderTiles(providers$Esri.WorldTopoMap) |>
      setView(lng = row$lon, lat = row$lat, zoom = 5) |>
      addCircleMarkers(
        lng = row$lon,
        lat = row$lat,
        radius = 8,
        color = "#d9534f",
        fillColor = "#d9534f",
        fillOpacity = 0.8,
        popup = paste0(
          "<b>", row$nice_name, "</b><br/>",
          row$region_desc
        )
      )
  })
}

shinyApp(ui, server)
