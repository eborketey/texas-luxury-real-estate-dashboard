# Required R packages for Texas Luxury Real Estate Dashboard

required_packages <- c(
  "sqldf",
  "shiny",
  "ggplot2",
  "dplyr",
  "plotly",
  "leaflet",
  "lubridate",
  "DT",
  "shinydashboard"
)

# Install missing packages
new_packages <- required_packages[!(required_packages %in% installed.packages()[,"Package"])]
if(length(new_packages)) install.packages(new_packages)

# Load all packages
lapply(required_packages, library, character.only = TRUE)

cat("All required packages loaded successfully!\n")
cat("Run the dashboard with: shiny::runApp('app.R')\n")
