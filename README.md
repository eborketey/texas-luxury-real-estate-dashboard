# Texas Luxury Real Estate Market Intelligence Dashboard
## Project Overview
Interactive R Shiny dashboard analyzing luxury real estate markets across Texas counties, providing comprehensive market intelligence for real estate professionals and investors.

## Key Features
- **Multi-County Analysis**: Collin, Montgomery, and Austin counties
- **Interactive Dashboards**: 9 specialized analytical views
- **Real-Time Filtering**: Dynamic county and time-based selections
- **Geographic Visualization**: Leaflet maps with income overlays
- **Predictive Analytics**: Correlation analysis and trend forecasting
- **Market Intelligence**: Supply-demand dynamics and seasonality patterns

## Technical Stack
- **R**: Core programming language
- **Shiny & shinydashboard**: Interactive web application framework
- **ggplot2 & plotly**: Advanced data visualization
- **leaflet**: Geographic mapping and spatial analysis
- **sqldf**: SQL queries on dataframes
- **dplyr & lubridate**: Data manipulation and time series

## Dashboard Components

### 1. Market Trends Analysis
- Time series visualization of median home prices
- County-specific trend comparisons
- Interactive plotly charts with zoom and filter capabilities

### 2. Supply & Demand Dynamics
- Inventory vs sales volume scatter plots
- Sales-to-inventory ratio analysis
- Market demand identification

### 3. Seasonality Insights
- Monthly sales heatmaps across years
- Seasonal pattern identification
- Peak sales period analysis

### 4. Predictive Analytics
- Correlation analysis between inventory and prices
- Trend line modeling with confidence intervals
- Investment opportunity scoring

### 5. Geographic Intelligence
- Interactive leaflet maps with county markers
- Household income overlays
- Spatial market analysis

## Business Impact
- **Investment Targeting**: Identified high-value investment opportunities
- **Market Timing**: Seasonal trend analysis for optimal buying/selling
- **Geographic Insights**: County-level performance comparison
- **Risk Assessment**: Supply-demand imbalance identification

## How to Run

### Prerequisites
```r
install.packages(c("shiny", "shinydashboard", "ggplot2", "dplyr", 
                   "plotly", "leaflet", "lubridate", "DT", "sqldf"))
