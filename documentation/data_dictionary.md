# Data Dictionary

## Texas Housing Dataset (txhousing)
Built-in R dataset from ggplot2 package

### Variables:
- `city`: City name (46 Texas cities)
- `year`: Year (2000-2015)
- `month`: Month (1-12)
- `sales`: Number of sales
- `volume`: Total dollar volume of sales
- `median`: Median sale price
- `listings`: Total active listings
- `inventory`: Months of inventory
- `date`: Date (year + month/12)

## County Housing Activity Files

### Structure (All three counties follow same format):
- **Date**: Transaction date
- **Sales**: Number of property sales
- **Dollar.Volume**: Total dollar volume of sales
- **Median.Price**: Median sale price
- **Active.Listings.EOM**: Active listings at end of month

### Counties Analyzed:
1. **Collin County** - Northern Dallas metro area
2. **Montgomery County** - Houston metro area  
3. **Austin County** - Austin metro area

## Calculated Variables (Created in App):
- `Sales_to_Inventory`: Sales / Active.Listings.EOM (demand indicator)
- `Avg_Unit_Price`: Dollar.Volume / Sales (average price per unit)
- `unit_price`: volume / sales (from txhousing dataset)
