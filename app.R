library(sqldf)
library(shiny)
library(ggplot2)
library(dplyr)
library(plotly)
library(leaflet)
library(lubridate)
library(DT)
library(shinydashboard)


# Load Data
data("txhousing", package = "ggplot2")
tx <- txhousing

tx$sales[is.na(tx$sales)] <- median(tx$sales, na.rm = TRUE)
tx$volume[is.na(tx$volume)] <- median(tx$volume, na.rm = TRUE)
tx$median[is.na(tx$median)] <- median(tx$median, na.rm = TRUE)
tx$listings[is.na(tx$listings)] <- median(tx$listings, na.rm = TRUE)
tx$inventory[is.na(tx$inventory)] <- median(tx$inventory, na.rm = TRUE)

tx$unit_price <- tx$volume / tx$sales
collin <- read.csv("Collin Housing Activity.csv")
montgomery <- read.csv("Montgomery Housing Activity.csv")
austin <- read.csv("Austin Housing Activity.csv")

# Combine datasets for easier analysis
luxury_housing <- bind_rows(
  collin %>% mutate(County = "Collin County"),
  montgomery %>% mutate(County = "Montgomery County"),
  austin %>% mutate(County = "Austin County")
)

luxury_housing$Date <- as.Date(luxury_housing$Date, format="%Y-%m-%d")
# Ensure columns exist and transform data
luxury_housing <- luxury_housing %>%
  mutate(
    Sales_to_Inventory = ifelse(Active.Listings.EOM == 0, NA, Sales / Active.Listings.EOM),
    Avg_Unit_Price = ifelse(Sales == 0, NA, Dollar.Volume / Sales),
    Month = month(Date, label = TRUE),
    Year = year(Date)
  )

# UI
ui <- dashboardPage(
  dashboardHeader(title = "Luxury Real Estate Dashboard"),
  dashboardSidebar(
    
    sidebarMenu(
      menuItem("Home", tabName = "home", icon = icon("home")),
      menuItem("Unit price", tabName = "Unit_price", icon = icon("fire")),
      menuItem("Market Trends", tabName = "trends", icon = icon("chart-line")),
      menuItem("Supply & Demand", tabName = "supply_demand", icon = icon("balance-scale")),
      menuItem("Seasonality Trends", tabName = "seasonality", icon = icon("calendar-alt")),
      menuItem("Predictive Insights", tabName = "predictive", icon = icon("chart-bar")),
      menuItem("Geographic Insights", tabName = "geographic", icon = icon("globe")),
      menuItem("High Demand Cities", tabName = "high_demand", icon = icon("fire")),
      menuItem("Average Unit Price", tabName = "avg_unit_price", icon = icon("money-bill"))
    )
  ),
  dashboardBody(
    
    tabItems(
      tabItem(tabName = "home",
              fluidRow(
                box(title = "Welcome to the Texas Luxury Real Estate Market Dashboard", width = 12, status = "primary", solidHeader = TRUE,
                    p("Analyzing Market Trends, Demand & Predictive Insights"),
                    h3("Purpose"),
                    p("The purpose of this dashboard is to analyze housing market trends, highlight investment opportunities, and predict future price movements."),
                    h3("Target Audience"),
                    p("This dashboard is designed for:"),
                    tags$ul(
                      tags$li("Luxury Real Estate Brokers")),
                    h3("Data Source"),
                    p("Texas Housing Data"),
                    p("Household Income Data"),
                    p("External Reports from TRERC & Wikipedia"),
                    h3("Purpose"),
                    p("Our goal is to provide insights into luxury real estate trends between three counties of special interest to luxury brokers.")
                )
              )
      ),
      # Market Trends Tab
      tabItem(tabName = "Unit_price",
              fluidRow(
                
                box(title = "Average Unit Price", width = 12, status = "info", solidHeader = TRUE, plotOutput("unit_price_plot"))
                )
              ),

      tabItem(tabName = "trends",
              fluidRow(
                
                box(title = "Median Home Prices Over Time", width = 12, status = "primary", solidHeader = TRUE,
                    selectInput("county_trends", "Select County:", choices = unique(luxury_housing$County), multiple = TRUE),
                    plotlyOutput("median_price_plot")
                )
              )
      ),
      # Supply & Demand Tab
      tabItem(tabName = "supply_demand",
              fluidRow(
                box(title = "Inventory vs Sales Volume", width = 12, status = "info", solidHeader = TRUE,
                    plotlyOutput("supply_demand_plot")
                )
              )
      ),
      
      # Seasonality Trends Tab
      tabItem(tabName = "seasonality",
              fluidRow(
                box(title = "Luxury Home Sales Seasonality", width = 12, status = "warning", solidHeader = TRUE,
                    plotlyOutput("seasonality_plot")
                )
              )
      ),
      
      # Predictive Insights Tab
      tabItem(tabName = "predictive",
              fluidRow(
                box(title = "Correlation Between Inventory & Price", width = 12, status = "success", solidHeader = TRUE,
                    plotlyOutput("correlation_plot")
                )
              )
      ),
      
      # Geographic Insights Tab
      tabItem(tabName = "geographic",
              fluidRow(
                box(title = "Household Income by County", width = 12, status = "danger", solidHeader = TRUE,
                    leafletOutput("geo_map")
                )
              )
      ),
      
      # High Demand Cities Tab
      tabItem(tabName = "high_demand",
              fluidRow(
                box(title = "High Demand Cities (Sales-to-Inventory Ratio)", width = 12, status = "warning", solidHeader = TRUE,
                    plotlyOutput("high_demand_plot")
                )
              )
      ),
      
      # Average Unit Price Tab
      tabItem(tabName = "avg_unit_price",
              fluidRow(
                box(title = "Average Unit Price (Dollar Volume per Sale)", width = 12, status = "success", solidHeader = TRUE,
                    plotlyOutput("avg_unit_price_plot")
                )
              )
      )
    )
  )
)

# Server
server <- function(input, output) {
  output$unit_price_plot <- renderPlot({
    query <- "
      select city, avg(unit_price) as avg_unit_price
      from tx
      group by city
      order by avg_unit_price desc
    "
    
    tx_avg_unit_price <- sqldf(query)
    
    ggplot(tx_avg_unit_price, aes(x = reorder(city, avg_unit_price), y = avg_unit_price, fill = city)) +
      geom_col() +
      coord_flip() +  # Flip axes for better readability
      labs(title = "Average Unit Price by City",
           x = "City", y = "Average Unit Price ($)",
           fill = "City") +
      theme_minimal()
  })
  
  # Market Trends: Median Price Over Time
  output$median_price_plot <- renderPlotly({
  
    if (is.null(input$county_trends) || length(input$county_trends) == 0) return(NULL)
    
    filtered_data <- luxury_housing %>% filter(County %in% input$county_trends)
    
    p <- ggplot(filtered_data, aes(x = Date, y = Median.Price, color = County)) +
      geom_line(size = 1) +
      geom_point(size = 0.2) +
      labs(title = "Median Home Price Trends",
           x = "Date", y = "Median Price ($)", color = "County") +
      theme_minimal()
    
    ggplotly(p)
  })
  
  # Supply & Demand: Scatter Plot (Inventory vs Sales)
  output$supply_demand_plot <- renderPlotly({
    p <- ggplot(luxury_housing, aes(x = Active.Listings.EOM, y = Sales, color = County)) +
      geom_point(size = 3, alpha = 0.7) +
      labs(title = "Inventory vs Sales Volume",
           x = "Active Listings (End of Month)", y = "Sales Volume") +
      theme_minimal()
    
    ggplotly(p)
  })
  
  # Seasonality Trends: Monthly Sales Heatmap
  output$seasonality_plot <- renderPlotly({
    p <- ggplot(luxury_housing, aes(x = Month, y = factor(Year), fill = Sales)) +
      geom_tile() +
      scale_fill_gradient(low = "yellow", high = "red") +
      labs(title = "Seasonality of Luxury Real Estate Sales",
           x = "Month", y = "Year", fill = "Sales Volume") +
      theme_minimal()
    
    ggplotly(p)
  })
  
  # Predictive Insights: Inventory vs Price Correlation
  output$correlation_plot <- renderPlotly({
    p <- ggplot(luxury_housing, aes(x = Active.Listings.EOM, y = Median.Price, color = County)) +
      geom_point(size = 3, alpha = 0.7) +
      geom_smooth(method = "lm", se = FALSE, color = "black") +
      labs(title = "Correlation Between Inventory & Median Price",
           x = "Active Listings (EOM)", y = "Median Home Price ($)") +
      theme_minimal()
    
    ggplotly(p)
  })
  
  # High Demand Cities: Sales-to-Inventory Ratio
  output$high_demand_plot <- renderPlotly({
    p <- ggplot(luxury_housing, aes(x = County, y = Sales_to_Inventory, fill = County)) +
      geom_bar(stat = "summary", fun = mean) +
      labs(title = "High Demand Cities (Sales-to-Inventory Ratio)",
           x = "County", y = "Sales-to-Inventory Ratio") +
      theme_minimal()
    
    ggplotly(p)
  })
  
  # Geographic Insights: Household Income Heatmap
  output$geo_map <- renderLeaflet({
    # Mock data for per capita income (replace with real data)
    income_data <- data.frame(
      County = c("Montgomery County", "Collin County", "Austin County"),
      Lat = c(30.3, 33.2, 30.3),
      Lon = c(-95.5, -96.6, -97.7),
      Income = c(70000, 85000, 90000)
    )
    
    pal <- colorNumeric(palette = "Blues", domain = income_data$Income)
    
    leaflet(income_data) %>%
      addTiles() %>%
      addCircleMarkers(
        ~Lon, ~Lat, color = ~pal(Income), fillOpacity = 0.8, radius = 10,
        popup = ~paste(County, "<br>Income: $", Income)
      ) %>%
      addLegend("bottomright", pal = pal, values = income_data$Income, title = "Per Capita Income")
  })
  # Average Unit Price: Dollar Volume per Sale
  output$avg_unit_price_plot <- renderPlotly({
    p <- ggplot(luxury_housing, aes(x = County, y = Avg_Unit_Price, fill = County)) +
      geom_bar(stat = "summary", fun = mean) +
      labs(title = "Average Unit Price (Dollar Volume per Sale)",
           x = "County", y = "Average Price Per Unit ($)") +
      theme_minimal()
    
    ggplotly(p)
  })
}

# Run the app
shinyApp(ui, server)
