## Contents
- Raw Data [[link]](https://github.com/dyrk01/Kaggle_Projects/tree/master/Iowa%20Alcohol%20Sales/data/raw_data)
  - City population 
  - Iowa counties
  - Iowa liquor products
  - Iowa liquor stores
  - Zipcodes of cities in Iowa
 
- Processed Data
  - Iowa alcohol sales cleaned (5 months) [[link]](https://docs.google.com/spreadsheets/d/1oP9W6Q-4mrQzBHyZ6HWv5cncvtoouMFG/edit?usp=sharing&ouid=115633765262776346707&rtpof=true&sd=true)
  - Iowa alcohol sales cleaned (1 year) [[link]](https://drive.google.com/file/d/1IQq89SwXKdi22cW5x5uqf-wNZJfdIsTN/view?usp=sharing)
  
- Code [[link]](https://github.com/dyrk01/Kaggle_Projects/tree/master/Iowa%20Alcohol%20Sales/code)
  - Data prep jupyter notebook
  - Data analysis jupyter notebook

- Products [[link]](https://github.com/dyrk01/Kaggle_Projects/tree/master/Iowa%20Alcohol%20Sales/products)
  - Tableau Story [[link]](https://public.tableau.com/app/profile/dyrk/viz/IowaAlcoholsales/Story1)
  - SQL (data cleaning and queries using the 5 months dataset)
  - Excel (data cleaning and analysis using the 5 months dataset)

## Dataset
This dataset contains the spirits purchase information of Iowa Class “E” liquor licensees by product and date of purchase for calendar year 2019. The dataset can be used to analyze total spirits sales in Iowa of individual products at the store level.

Link: https://data.iowa.gov/Sales-Distribution/2019-Iowa-Liquor-Sales/38x4-vs5h

## Data Description
Columns | Description
--- | ---
Invoice/Item number | Unique Id for each order
Date | Date of order
Store number | Unique number assigned to store 
Store name | Name of store
Address | Address of store 
City | City where the store is located
Zip code | Zip code where the store is located 
Store location | Longtitude and Latitude of store
County number | Iowa county number of store 
County | County of store
Category number | Category number of liquor
Category name | Category of liquor
Vendor number |  Vendor code of the company for the brand of liquor 
Vendor name | Vendor name of the company for the brand of liquor
Item number | Item number of the liquor product  
Item description | Description of the liquor product  
Pack | Number of bottles in a case ordered 
Bottle volume (ml) | Volume of each bottle prdered in ml 
State bottle cost | Cost price of each bottle
State bottle retail | Selling price of each bottle to store
Bottles sold | Number of bottles sold 
Sale (Dollars) | Total cost of liquor order
Volume sold (liters) | Total volume of liquor ordered in liters 
Volume sold (gallons) | Total volume of liquor ordered in gallons 


