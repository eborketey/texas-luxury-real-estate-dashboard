# Analysis Methodology
## Dashboard Architecture
Built using R Shiny with shinydashboard framework for professional UI/UX

## Data Processing Pipeline
### 1. Data Cleaning & Preparation
```r
# Handle missing values with median imputation
tx$sales[is.na(tx$sales)] <- median(tx$sales, na.rm = TRUE)

# Create derived metrics
luxury_housing <- luxury_housing %>%
  mutate(
    Sales_to_Inventory = ifelse(Active.Listings.EOM == 0, NA, Sales / Active.Listings.EOM),
    Avg_Unit_Price = ifelse(Sales == 0, NA, Dollar.Volume / Sales)
  )

Analytical Components

Market Trends Analysis
Method: Time series visualization using ggplot2 + plotly
Purpose: Track median price movements over time
Interactive Elements: County filtering, zoom capabilities

Supply & Demand Dynamics
Method: Scatter plot analysis (Inventory vs Sales Volume)
Purpose: Identify market imbalances and opportunities
Visualization: Color-coded by county with trend overlays

Seasonality Analysis
Method: Heatmap visualization (Month vs Year vs Sales)
Purpose: Identify seasonal buying/selling patterns
Implementation: ggplot2 geom_tile with gradient coloring

Predictive Insights
Method: Correlation analysis with linear modeling
Purpose: Understand inventory-price relationships
Statistical Approach: Linear regression with confidence intervals

Geographic Intelligence
Method: Leaflet interactive mapping
Purpose: Spatial analysis of market performance
Data Integration: Household income overlays

SQL Integration
# Example: Average unit price analysis
query <- "
  SELECT city, AVG(unit_price) as avg_unit_price
  FROM tx
  GROUP BY city
  ORDER BY avg_unit_price DESC
"

Key Performance Indicators (KPIs)
Demand Indicator: Sales-to-Inventory ratio
Price Performance: Average unit price by location
Market Activity: Sales volume trends
Seasonal Patterns: Monthly sales distribution
Geographic Performance: County-level comparisons

Technical Implementation
Framework: Shiny with reactive programming
Visualization: ggplot2, plotly, leaflet integration
Data Management: dplyr for transformation, sqldf for queries
UI/UX: shinydashboard for professional layout
