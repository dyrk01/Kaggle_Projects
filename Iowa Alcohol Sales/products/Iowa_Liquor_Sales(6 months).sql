--Objective 0 
--Importing csv to the database
--Convert to xls and reduce columns to 948k+ rows
--MethodL By SQL Import data wizard

--Objective 1 : Create five new colums in the sales table (done)
ALTER TABLE Sales
ADD DateQuarter VARCHAR(1) NULL,
	DateMonth VARCHAR(1) NULL,
	DateWeek VARCHAR(1) NULL,
	DateDay VARCHAR(2) NULL,
	GrossProfit DECIMAL(5,2) NULL

--Add the values into the new columns 
Update Sales
SET DateQuarter = DATEPART(quarter,Date),
	DateMonth = DATEPART(month,Date),
	DateWeek = DATEPART(week,Date),
	DateDay = DATEPART(weekday,Date),
	GrossProfit = (StateBottleRetail - StateBottleCost)

--Objective 2: Joining multiple tables together using Left Join (done)
SELECT *
INTO Sales2
FROM Sales
LEFT JOIN Stores ON (Sales.StoreNumber = Stores.Store)
LEFT JOIN Zipcode ON (Stores.ZipCodeaaStores = Zipcode.zipcodes)
LEFT JOIN Products ON (Sales.ItemNumber = Products.ItemNumberaaProducts)
LEFT JOIN CountyList ON (Zipcode.zipcodes_county = CountyList.countylist_county)

--Objective 3: Rename columns (done)
--Change Invoice/Item Number to InvoiceId
EXEC sp_rename 'Sales2.Invoice/Item Number','InvoiceId';
EXEC sp_rename 'Sales2.BottleVolume (ml)','BottleVolume(ml)';
EXEC sp_rename 'Sales2.Volume Sold(Gallons)','VolumeSold(Gallons)';

--Objective 4 : Check the null values in the dataset (done)

--List of Null values:
--Address,City,ZipCode,CountyNumber,County : 588 rows
--Category,CategoryName: 969 rows
--StoreLocation: 90,530

--Check for null values using the query below. Repeat for all columns
SELECT *
FROM Sales2
Where InvoiceId IS NULL

--Objective 5
--Replace the null values with values from other tables (done)
Update Sales2
SET
Address = AddressaaStores,
City = CityaaStores,
ZipCode = ZipCodeaaStores,
StoreLocation = StoreLocationaaStores,
CountyNumber = countylist_no,
County = countylist_county,
CategoryName = [Category Name]
Where Address IS NULL OR City IS NULL OR ZipCode IS NULL OR StoreLocation IS NULL OR CountyNumber IS NULL OR County IS NULL OR CategoryName IS NULL

--Objective 6
--Update the countynumber and county for rows with zipcode = 52303 only (done)
--Why: There are null values as the county number and county are not found in the matching table
Update Sales2 
SET
CountyNumber = '57',
County = 'LINN'
WHERE ZipCode = '52303' AND CountyNumber IS NULL AND County IS NULL

--Objective 7
--Null values in CountyNumber and County for city sheldon and sandborn
--Replace null values for countynumber with 71 for city sheldon and sanborn
UPDATE Sales2
SET
CountyNumber = ISNULL(CountyNumber,'71')

--Objective 8
--Replace null values for county with obrien for city sheldon and sanborn
UPDATE Sales2
SET 
County = ISNULL(County,'obrien')

--Objective 9
--Replace buena vist with buena vista (wrong code for all)
UPDATE Sales2
SET 
County = REPLACE('bueana vist','vist','vista')
WHERE CountyNumber = '11'

--Objective 10
--Replace cerro gord with cerro gordo
UPDATE Sales2
SET 
County = REPLACE('cerro gord','gord','gordo')
WHERE CountyNumber = '17'

--Objective 11
--Replace pottawatta with pottawattamie
UPDATE Sales2 
SET 
County = REPLACE('pottawatta','watta','wattamie')
WHERE CountyNumber = '78'

--Objective 12
--Drop all unncessary columns in the table(done)
ALTER TABLE Sales2
DROP COLUMN countylist_county,countylist_no,[Vendor Name],Vendor,[Item Description],[Category Name],ItemNumberaaProducts,zipcodes_county,zipcodes_city,zipcodes,StoreLocationaaStores,ZipCodeaaStores,CityaaStores,AddressaaStores,Name,Store

--Distinct Null values in Category column  : 969 rows
SELECT DISTINCT CategoryName,Category
FROM Sales2
WHERE Category IS NULL

--List of Category and CategoryName(Null + Not Null)
--There are multiple category name and numbers
SELECT DISTINCT CategoryName,Category
FROM Sales2
ORDER BY CategoryName ASC

--Objective 13
-- Change the category to one number 
-- Select category number with the most common number (done)

--Change the number from 1022100 to 1022200 
UPDATE Sales2
SET
Category =REPLACE('1022100','100','200')
WHERE CategoryName = '100% Agave Tequila'

--Change all null values to 1022200
UPDATE Sales2
SET
Category = ISNULL(Category,'1022200')
WHERE CategoryName = '100% Agave Tequila' 

--Change the number from 1062100 to 1062300
UPDATE Sales2
SET
Category =REPLACE('1062100','100','300')
WHERE CategoryName = 'Aged Dark Rum'

--Change all null values to 1062300
UPDATE Sales2
SET
Category = ISNULL(Category,'1062300')
WHERE CategoryName = 'Aged Dark Rum' 

--Change the number from the rest to 1081300
UPDATE Sales2
SET
Category =REPLACE('1081000','000','300')
WHERE CategoryName = 'American Cordials & Liqueur'

--Change the number from the rest to 1081300
UPDATE Sales2
SET
Category =REPLACE('1081000','000','300')
WHERE CategoryName = 'American Cordials & Liqueurs'

UPDATE Sales2
SET
Category =REPLACE('1011200','11200','81300')
WHERE CategoryName = 'American Cordials & Liqueur'

UPDATE Sales2
SET
Category =REPLACE('1091100','91100','81300')
WHERE CategoryName = 'American Cordials & Liqueur'

--Change all null values to 1081300
UPDATE Sales2
SET
Category = ISNULL(Category,'1081300')
WHERE CategoryName = 'American Cordials & Liqueur' 

--Change from American Cordials & Liqueur to American Cordials & Liqueurs
UPDATE Sales2 
SET
CategoryName = REPLACE('American Cordials & Liqueur','Liqueur','Liqueurs')
WHERE CategoryName = 'American Cordials & Liqueur'

--Change the number from 1091000 to 1091100
UPDATE Sales2
SET
Category =REPLACE('1091000','000','100')
WHERE CategoryName = 'American Distilled Spirits Specialty'

--Change from American Distilled Spirit Specialty (old value) to American Distilled Spirits Specialty (new value)
UPDATE Sales2 
SET 
CategoryName = REPLACE('American Distilled Spirit Specialty','Spirit','Spirits') 
WHERE CategoryName = 'American Distilled Spirit Specialty'

--Change all null values to 1091100
UPDATE Sales2
SET
Category = ISNULL(Category,'1091100')
WHERE CategoryName = 'American Distilled Spirits Specialty' 

--Change the number from 1031100 to 1031200
UPDATE Sales2
SET
Category =REPLACE('1031100','100','200')
WHERE CategoryName = 'American Flavored Vodka'

--Change the number from the rest to 1031100
UPDATE Sales2
SET
Category =REPLACE('1031000','000','100')
WHERE CategoryName = 'American Vodka'

UPDATE Sales2
SET
Category =REPLACE('1701100','701100','031100')
WHERE CategoryName = 'American Vodkas'

UPDATE Sales2
SET
Category =REPLACE('1032100','2100','1100')
WHERE CategoryName = 'American Vodkas'

--Change all null values to 1031100
UPDATE Sales2
SET
Category = ISNULL(Category,'1031100')
WHERE CategoryName = 'American Vodkas' 

--Change from American Vodka (old column) to American Vodkas (new column)
UPDATE Sales2 
SET 
CategoryName = REPLACE('American Vodka','Vodka','Vodkas') 
WHERE CategoryName = 'American Vodka'

--Change all null values to 1081400
UPDATE Sales2
SET
Category = ISNULL(Category,'1081400')
WHERE CategoryName = 'American Schnapps' 

--Change the number from 1011200 to 1011100
UPDATE Sales2
SET
Category =REPLACE('1011200','200','100')
WHERE CategoryName = 'Blended Whiskies'

--Change all null values to 1011100
UPDATE Sales2
SET
Category = ISNULL(Category,'1011100')
WHERE CategoryName = 'Blended Whiskies' 

--Change all null values to 1012100
UPDATE Sales2
SET
Category = ISNULL(Category,'1012100')
WHERE CategoryName = 'Canadian Whiskies' 

--Change the number from 1070000 to 1071100
UPDATE Sales2
SET
Category =REPLACE('1070000','0000','1100')
WHERE CategoryName = 'Cocktails / RTD'

--Change from Cocktails / RTD (old value) to Cocktails /RTD (new value)
UPDATE Sales2 
SET 
CategoryName = REPLACE('Cocktails / RTD',' / RTD',' /RTD') 
WHERE CategoryName = 'Cocktails / RTD'

--Change from Cocktails /RTD (old value) to Cocktails/RTD (new value)
UPDATE Sales2 
SET 
CategoryName = REPLACE('Cocktails /RTD','s /RTD','s/RTD') 
WHERE CategoryName = 'Cocktails /RTD'

--Change the number from 1071100 to 1081200
UPDATE Sales2
SET
Category =REPLACE('1071100','71100','81200')
WHERE CategoryName = 'Cream Liqueurs'

--Change the number from 1701100 to 1062500
UPDATE Sales2
SET
Category =REPLACE('1701100','701100','062500')
WHERE CategoryName = 'Flavored Rum'

--Change the number from the rest to 1062500
UPDATE Sales2
SET
Category =REPLACE('1062200','200','500')
WHERE CategoryName = 'Flavored Rum'

--Change all null values to 1062500
UPDATE Sales2
SET
Category = ISNULL(Category,'1062500')
WHERE CategoryName = 'Flavored Rum' 

--Change all null values to 1062100
UPDATE Sales2
SET
Category = ISNULL(Category,'1062100')
WHERE CategoryName = 'Gold Rum' 

--Change number from the rest to 1082000
UPDATE Sales2
SET
Category =REPLACE('1901200','901200','082000')
WHERE CategoryName = 'Imported Cordials & Liqueur'

UPDATE Sales2
SET
Category =REPLACE('1082100','100','000')
WHERE CategoryName = 'Imported Cordials & Liqueur'

--Change all null values to 1082000
UPDATE Sales2
SET
Category = ISNULL(Category,'1082000')
WHERE CategoryName = 'Imported Cordials & Liqueurs' 

--Change Imported Cordials & Liqueur (old value) to Imported Cordials & Liqueurs(new value)
UPDATE Sales2 
SET 
CategoryName = REPLACE('Imported Cordials & Liqueur','Liqueur','Liqueurs') 
WHERE CategoryName = 'Imported Cordials & Liqueur'

--Change number from 1092000 to 1092100
UPDATE Sales2
SET
Category =REPLACE('1092000','000','100')
WHERE CategoryName = 'Imported Distilled Spirits Specialty'

--Change Imported Distilled Spirit Specialty (old value) to Imported Distilled Spirits Specialty (new value)
UPDATE Sales2 
SET 
CategoryName = REPLACE('Imported Distilled Spirit Specialty','Spirit Specialty','Spirits Specialty') 
WHERE CategoryName = 'Imported Distilled Spirit Specialty'

--Change number from 1701100 to 1032200
UPDATE Sales2
SET
Category =REPLACE('1701100','701100','032200')
WHERE CategoryName = 'Imported Flavored Vodka'

--Change number from 1032000 to 1032100 
UPDATE Sales2
SET
Category =REPLACE('1032000','000','100')
WHERE CategoryName = 'Imported Vodka'

--Change all null values to 1032100
UPDATE Sales2
SET
Category = ISNULL(Category,'1032100')
WHERE CategoryName = 'Imported Vodka' 

--Change Imported Vodka (old value) to Imported Vodkas (new value)
UPDATE Sales2 
SET 
CategoryName = REPLACE('Imported Vodka','Vodka','Vodkas') 
WHERE CategoryName = 'Imported Vodka'

--Change all null values to 1032300
UPDATE Sales2
SET
Category = ISNULL(Category,'1032300')
WHERE CategoryName = 'Imported Whiskies' 

--Change from the rest to 1051100
UPDATE Sales2
SET
Category =REPLACE('1052100','2100','1100')
WHERE CategoryName = 'Iowa Distilleries'

UPDATE Sales2
SET
Category =REPLACE('1081600','81600','51100')
WHERE CategoryName = 'Iowa Distilleries'

UPDATE Sales2
SET
Category =REPLACE('1071100','71100','51100')
WHERE CategoryName = 'Iowa Distilleries'

UPDATE Sales2
SET
Category =REPLACE('1091100','91','51')
WHERE CategoryName = 'Iowa Distilleries'

UPDATE Sales2
SET
Category =REPLACE('1081300','81300','51100')
WHERE CategoryName = 'Iowa Distilleries'

UPDATE Sales2
SET
Category =REPLACE('1081200','81200','51100')
WHERE CategoryName = 'Iowa Distilleries'

UPDATE Sales2
SET
Category =REPLACE('1011800','11800','51100')
WHERE CategoryName = 'Iowa Distillery Whiskies'
	
--Change Iowa Distillery Whiskies (old value) to Iowa Distilleries (new value)
UPDATE Sales2 
SET 
CategoryName = REPLACE('Iowa Distillery Whiskies','Distillery Whiskies','Distilleries') 
WHERE CategoryName = 'Iowa Distillery Whiskies'

--Change all null values to 1091200
UPDATE Sales2
SET
Category = ISNULL(Category,'1091200')
WHERE CategoryName = 'Neutral Grain Spirits' 

--Change all null values to 1091300
UPDATE Sales2
SET
Category = ISNULL(Category,'1091300')
WHERE CategoryName = 'Neutral Grain Spirits Flavored' 

--Change number from 1701100 to 1012200
UPDATE Sales2
SET
Category =REPLACE('1701100','701100','012200')
WHERE CategoryName = 'Scotch Whiskies'

--Change all null values to 1012200
UPDATE Sales2
SET
Category = ISNULL(Category,'1012200')
WHERE CategoryName = 'Scotch Whiskies' 

--Change all null values to 1011300
UPDATE Sales2
SET
Category = ISNULL(Category,'1011300')
WHERE CategoryName = 'Single Barrel Bourbon Whiskies' 

--Change number from 1012200 to 1012300
UPDATE Sales2
SET
Category =REPLACE('1012200','200','300')
WHERE CategoryName = 'Single Malt Scotch'

--Change all null values to 1012300
UPDATE Sales2
SET
Category = ISNULL(Category,'1012300')
WHERE CategoryName = 'Single Malt Scotch' 

--Change number from 1062500 to 1062400
UPDATE Sales2
SET
Category =REPLACE('1062500','25','24')
WHERE CategoryName = 'Spiced Rum'

--Change number from the rest to 1011200
UPDATE Sales2
SET
Category =REPLACE('1701100','701100','011200')
WHERE CategoryName = 'Straight Bourbon Whiskies'

--Change number from the rest to 1011200
UPDATE Sales2
SET
Category =REPLACE('1091100','091100','011200')
WHERE CategoryName = 'Straight Bourbon Whiskies'

--Change number from the rest to 1011200
UPDATE Sales2
SET
Category =REPLACE('1901200','901200','011200')
WHERE CategoryName = 'Straight Bourbon Whiskies'

--Change number from the rest to 1011200
UPDATE Sales2
SET
Category =REPLACE('1011100','100','200')
WHERE CategoryName = 'Straight Bourbon Whiskies'

--Change all null values to 1011200
UPDATE Sales2
SET 
Category = ISNULL(Category,'1011200')
WHERE CategoryName = 'Straight Bourbon Whiskies'

--Change number from the 1701100 to 1011600
UPDATE Sales2
SET
Category =REPLACE('1701100','701100','011600')
WHERE CategoryName = 'Straight Rye Whiskies'

--Change all null values to 1011600
UPDATE Sales2
SET 
Category = ISNULL(Category,'1011600')
WHERE CategoryName = 'Straight Rye Whiskies'

--Change number from the rest to 1701100
UPDATE Sales2
SET
Category =REPLACE('1062500','062500','701100')
WHERE CategoryName = 'Temporary &  Specialty Packages'

UPDATE Sales2
SET
Category =REPLACE('1081200','081200','701100')
WHERE CategoryName = 'Temporary & Specialty Packages'

UPDATE Sales2
SET
Category =REPLACE('1011200','011200','701100')
WHERE CategoryName = 'Temporary & Specialty Packages'

UPDATE Sales2
SET
Category =REPLACE('1082000','082000','701100')
WHERE CategoryName = 'Temporary & Specialty Packages'

--Change Temporary &  Specialty Packages (old value) to Temporary & Specialty Packages (new value)
UPDATE Sales2 
SET 
CategoryName = REPLACE('Temporary &  Specialty Packages','&  Specialty','& Specialty') 
WHERE CategoryName = 'Temporary &  Specialty Packages'

--Change all null values to 1701100
UPDATE Sales2
SET 
Category = ISNULL(Category,'1701100')
WHERE CategoryName = 'Temporary & Specialty Packages'

--Change number from 1011100 to 1081600
UPDATE Sales2
SET
Category =REPLACE('1011100','11100','81600')
WHERE CategoryName = 'Whiskey Liqueur'

--Change all null values to 1081600
UPDATE Sales2
SET 
Category = ISNULL(Category,'1081600')
WHERE CategoryName = 'Whiskey Liqueur'

--Change all null values to 1062200
UPDATE Sales2
SET 
Category = ISNULL(Category,'1062200')
WHERE CategoryName = 'White Rum'

--Objective 14
--Standardise all text to lower case. (title-case is the most ideal) (done)
UPDATE Sales2
SET 
StoreName = LOWER(StoreName),
Address = LOWER(Address),
City = LOWER(City),
County = LOWER(County),
CategoryName = LOWER(CategoryName),
VendorName = LOWER(VendorName),
ItemDescription = LOWER(ItemDescription)

--Objective 15: There is a * in DateWeek column after week 9
--Drop DateWeek Column
ALTER TABLE Sales2
DROP COLUMN DateWeek

--Create column 
ALTER TABLE Sales2
ADD DateWeek VARCHAR(2) NULL

--Set first day of the week as 7(Sunday)
SET DATEFIRST 7;

--Update dateweek column to show week number
UPDATE Sales2
SET 
DateWeek = DATEPART(week,Date)

--Drop below columns as it is not useful for eda
ALTER TABLE Sales2
DROP COLUMN DateDay,DateWeek,DateQuarter,[VolumeSold(Gallons)]

--Data checking 
--City
--Check that the cities and spelling are correct
--How do i ensure this?
Select DISTINCT City
From Sales2
Order by City DESC

--ZipCode
--Check that the zipcodes are correct
Select DISTINCT ZipCode
From Sales2
ORDER BY ZipCode DESC

--County
--Check that the county/county number and spelling are correct
--How do i ensure this?
--CountyNumber should match with County name
Select Distinct County,CountyNumber
From Sales2
Order by County DESC

--CategoryName
--Check that the categoryname and spelling are correct
--How do i ensure this?
Select DISTINCT Category,CategoryName
From Sales2
ORDER BY CategoryName ASC

--Vendor Name
--Check that the spelling and name are correct
--How do i ensure this?
Select DISTINCT VendorNumber,VendorName
From Sales2
ORDER BY VendorName ASC

--ItemDescription
--Check that the spelling and name are correct
--How do i ensure this?
SELECT DISTINCT ItemNumber, ItemDescription
From Sales2
ORDER BY ItemDescription ASC

--Sales for the last 6 months 
SELECT Round(SUM([Sale(Dollars)]),0) AS Total_Sales,DateMonth
FROM Sales2
GROUP BY DateMonth
ORDER BY Total_Sales Desc 
--Insight: Sales are increasing every month. This may not be true as not all dates is in a month

--Profit margin of the products sold ? 
SELECT AVG((GrossProfit/ StateBottleCost) * 100) AS Average
FROM Sales2
--Insight: As they are allowed to markup up their prices by 50% maximum, it means that they are selling the products at the highest markup margin.

--Solution: Dashboard to track stuff / delivery route

SELECT *
FROM Sales2

--Top 10 store name/number by sales 
SELECT TOP(10) City,StoreNumber,StoreName, ROUND(Sum([Sale(Dollars)]),0) as Sales
FROM Sales2
GROUP BY StoreNumber,StoreName,City
ORDER BY Sales DESC

--Insights: Why are the sales for the store 4829,2633 two times more than the other 8 stores?
--Potential reasons why: Location to nearby amenities , Accessbility
--Top 2
SELECT * FROM Sales2
WHERE StoreNumber = '4829' OR StoreNumber = '2633'
--Top 3-10
SELECT * FROM Sales2
WHERE StoreNumber = '2512' OR StoreNumber = '5102' OR StoreNumber = '3952' OR StoreNumber = '3385' OR StoreNumber = '3773' OR StoreNumber = '3420' OR StoreNumber = '3814' OR StoreNumber = '2625'

--Bottom 10 stores 
SELECT TOP(10) City,StoreNumber,StoreName, ROUND(SUM([Sale(Dollars)]),0) AS Sales
FROM Sales2
GROUP BY StoreNumber,StoreName,City
ORDER BY Sales ASC
--Insights : Why are the sales so poor in these stores?
SELECT * FROM Sales2
WHERE StoreNumber = '9042' OR StoreNumber = '5506' OR StoreNumber = '4789' OR StoreNumber = '5161' OR StoreNumber = '9031' OR StoreNumber = '4676' OR StoreNumber = '5675' OR StoreNumber = '5355' OR StoreNumber = '5700' OR StoreNumber = '5659'

--Change the Name column in Population table to Lowercase
UPDATE Population
SET 
name = LOWER(name)

--Rename pop2021 column to population in Population table 
EXEC sp_rename 'Population.pop2021', 'population','COLUMN';

--Check for NUll values in table
SELECT DISTINCT City,name,population
FROM Iowa_Sales.dbo.Sales2
LEFT JOIN Iowa_Sales.dbo.Population 
ON Iowa_Sales.dbo.Population.name = Iowa_Sales.dbo.Sales2.City
WHERE population IS NULL

--Create temp table with Population & Sales2 Table
SELECT * 
INTO #temp_table 
FROM Iowa_Sales.dbo.Sales2
LEFT JOIN Iowa_Sales.dbo.Population 
ON Iowa_Sales.dbo.Population.name = Iowa_Sales.dbo.Sales2.City

--Replace Null values in population and city column 
UPDATE #temp_table
SET
name = City
WHERE name is NULL

--Replace the null values of population of 33 cities (stop at here replaced)
Select DISTINCT City,name,population
FROM #temp_table 
Where population IS NULL

UPDATE #temp_table
SET 
population =ISNULL(population,'338')
WHERE City = 'amana'	

UPDATE #temp_table
SET 
population =ISNULL(population,'393')
WHERE City = 'arlington'	

UPDATE #temp_table
SET 
population =ISNULL(population,'106')
WHERE City = 'baldwin'	

UPDATE #temp_table
SET 
population =ISNULL(population,'69')
WHERE City = 'bevington'	

UPDATE #temp_table
SET 
population =ISNULL(population,'397')
WHERE City = 'casey'	

UPDATE #temp_table
SET 
population =ISNULL(population,'7480')
WHERE City = 'clearlake'	

UPDATE #temp_table
SET 
population =ISNULL(population,'250')
WHERE City = 'corwith'	

UPDATE #temp_table
SET 
population =ISNULL(population,'399')
WHERE City = 'cumming'	

UPDATE #temp_table
SET 
population =ISNULL(population,'16871')
WHERE City = 'delaware'	

UPDATE #temp_table
SET 
population =ISNULL(population,'403')
WHERE City = 'earling'	

UPDATE #temp_table
SET 
population =ISNULL(population,'309')
WHERE City = 'floyd'	

UPDATE #temp_table
SET 
population =ISNULL(population,'316')
WHERE City = 'fort atkinson'	

UPDATE #temp_table
SET 
population =ISNULL(population,'642')
WHERE City = 'grand mounds'	

UPDATE #temp_table
SET 
population =ISNULL(population,'328')
WHERE City = 'harpers ferry'	

UPDATE #temp_table
SET 
population =ISNULL(population,'370')
WHERE City = 'holy cross'	

UPDATE #temp_table
SET 
population =ISNULL(population,'1111')
WHERE City = 'jewell'	

UPDATE #temp_table
SET 
population =ISNULL(population,'3765')
WHERE City = 'leclaire'	

UPDATE #temp_table
SET 
population =ISNULL(population,'9826')
WHERE City = 'lemars'	

UPDATE #temp_table
SET 
population =ISNULL(population,'368')
WHERE City = 'lorville'	

UPDATE #temp_table
SET 
population =ISNULL(population,'368')
WHERE City = 'lohrville'

UPDATE #temp_table
SET 
population =ISNULL(population,'446')
WHERE City = 'lost nation'	

UPDATE #temp_table
SET 
population =ISNULL(population,'8668')
WHERE City = 'mt pleasant'	

UPDATE #temp_table
SET 
population =ISNULL(population,'25023')
WHERE City = 'otunwa'	

UPDATE #temp_table
SET 
population =ISNULL(population,'25023')
WHERE City = 'otumwa'	

UPDATE #temp_table
SET 
population =ISNULL(population,'471')
WHERE City = 'pacific junction'	

UPDATE #temp_table
SET 
population =ISNULL(population,'103')
WHERE City = 'pleasant valley'	

UPDATE #temp_table
SET 
population =ISNULL(population,'1107')
WHERE City = 'st ansgar'	

UPDATE #temp_table
SET 
population =ISNULL(population,'1107')
WHERE City = 'saint ansgar'	

UPDATE #temp_table
SET 
population =ISNULL(population,'653')
WHERE City = 'st charles'	

UPDATE #temp_table
SET 
population =ISNULL(population,'143')
WHERE City = 'st lucas'	

UPDATE #temp_table
SET 
population =ISNULL(population,'362')
WHERE City = 'templeton'	

UPDATE #temp_table
SET 
population =ISNULL(population,'3221')
WHERE City = 'tipton'	

UPDATE #temp_table
SET 
population =ISNULL(population,'248')
WHERE City = 'washta'	

UPDATE #temp_table
SET 
population =ISNULL(population,'390')
WHERE City = 'wesley'	

UPDATE #temp_table
SET 
population =ISNULL(population,'92')
WHERE City = 'zwingle'	

--Checking of spelling 
Select DISTINCT City,population
FROM #temp_table 
ORDER BY City Desc

--Number of stores by city , sales , population (no null values in population with temp_table)
WITH City_Sum AS (
SELECT StoreNumber,City, population, [Sale(Dollars)]
FROM #temp_table 
)
SELECT City, population,COUNT(DISTINCT StoreNumber) AS NumberOfStores,ROUND(SUM([Sale(Dollars)]),0) AS Sales
FROM City_Sum 
GROUP BY City, population
ORDER BY population DESC

--Number of stores by city , sales , population (with null values)
WITH City_Sum AS (
SELECT Sales2.StoreNumber,Sales2.City, Population.population, [Sale(Dollars)]
FROM Population
LEFT JOIN Sales2 ON Population.name = Sales2.City
)
SELECT City, population,COUNT(DISTINCT StoreNumber) AS NumberOfStores,ROUND(SUM([Sale(Dollars)]),0) AS Sales
FROM City_Sum 
GROUP BY City, population
ORDER BY population DESC

--Insight: Why are there so many stores in some cities while there are so few in some?
--The population for des moines and cedar rapids are the two most populated cities in Iowa
--Number of store is high for highly populated cities and vice versa

--Number of stores by county
SELECT County,COUNT(DISTINCT StoreNumber) as NumberOfStores
FROM Sales2
GROUP BY County
ORDER BY NumberOFStores DESC

--Top city by sales 
SELECT TOP(10) City,ROUND(SUM([Sale(Dollars)]),0) AS Sales
FROM Sales2
GROUP BY [City]
ORDER BY Sales DESC

--Top county by sales
SELECT TOP(10) County,ROUND(SUM([Sale(Dollars)]),0) AS Sales
FROM Sales2
GROUP BY County
ORDER BY Sales DESC

--Top county number by sales
SELECT TOP(10) CountyNumber,Sum([Sale(Dollars)]) AS Sales
FROM Sales2
GROUP BY CountyNumber
ORDER BY Sales DESC

--Top category number by sales
SELECT TOP(20) Category,ROUND(Sum([Sale(Dollars)]),0) AS Sales
FROM Sales2
GROUP BY Category
ORDER BY Sales DESC

--Top Category Name by sales percentage
WITH CTE AS (
SELECT CategoryName,SUM([Sale(Dollars)]) AS Sales,(SELECT ROUND(SUM([Sale(Dollars)]),0) FROM Sales2) AS Total_Sales
FROM Sales2
Group by CategoryName
)
SELECT CategoryName,Sales/Total_Sales * 100 AS PercentageOfSales
FROM CTE	

--Top category name by sales
SELECT TOP(20) CategoryName,ROUND(SUM([Sale(Dollars)]),0) AS Sales
FROM Sales2
GROUP BY CategoryName
ORDER BY Sales DESC

--Category Name by Sales and Percentage in the city of 'des monies'
--Purpose: Finding out which category of alcohol has the highest percentage of sales

--CategoryName by sales and by des monies city
WITH Sum_Sales1 AS (
SELECT CategoryName, ROUND(SUM([Sale(Dollars)]),0) AS Sales , (SELECT ROUND(SUM([Sale(Dollars)]),0) FROM Sales2) AS Total_Sales
FROM Sales2
WHERE City = 'des moines'
GROUP BY CategoryName
)
SELECT CategoryName,ROUND(Sales * 100/Total_Sales,1) AS Percentage_Sales
FROM Sum_Sales1
ORDER BY Percentage_Sales DESC

--CategoryName by overall percentage of sales , all cities
WITH Sum_Sales2 AS (
SELECT CategoryName,ROUND(SUM([Sale(Dollars)]),0) AS Sales, (SELECT ROUND(SUM([Sale(Dollars)]),0) FROM Sales2) AS Total_Sales
FROM Sales2
GROUP BY CategoryName
)
SELECT CategoryName,ROUND(Sales/Total_Sales * 100,1)  AS Percentage_Sales
FROM Sum_Sales2
ORDER BY Percentage_Sales DESC

--Top vendor number by sales
SELECT TOP(20) VendorNumber,Sum([Sale(Dollars)]) AS Sales
FROM Sales2
GROUP BY VendorNumber
ORDER BY Sales DESC

--Top vendor by sales
SELECT TOP(20) VendorName,ROUND(SUM([Sale(Dollars)]),0) AS Sales
FROM Sales2
GROUP BY VendorName
ORDER BY Sales DESC

--Top item number by sales
SELECT TOP(20) ItemNumber,Sum([Sale(Dollars)]) AS Sales
FROM Sales2
GROUP BY ItemNumber
ORDER BY Sales DESC

--Top item number by sales
SELECT TOP(20) ItemDescription, Sum([Sale(Dollars)]) AS Sales
FROM Sales2
GROUP BY ItemDescription
ORDER BY Sales DESC

--Popularity of Category by ItemSold
SELECT Category,CategoryName,Sum(BottlesSold) AS Total_Items_Sold
FROM Sales2
GROUP BY Category,CategoryName
ORDER BY Total_Items_Sold DESC

--Popularity of Vendor by ItemSold
SELECT VendorNumber,VendorName,Sum(BottlesSold) AS Total_Items_Sold
FROM Sales2
GROUP BY VendorNumber,VendorName
ORDER BY Total_Items_Sold DESC

--Popularity of Items by ItemSold
SELECT ItemNumber,ItemDescription,Sum(BottlesSold) AS TotalBottlesSold
FROM Sales2
GROUP BY ItemNumber,ItemDescription
ORDER BY TotalBottlesSold DESC

--Popularity of Category by Volume Sold Liters
SELECT Category,CategoryName,ROUND(SUM([VolumeSold(Liters)]),0) AS VolumeSold_Liters
FROM Sales2
GROUP BY Category,CategoryName
ORDER BY VolumeSold_Liters DESC

--Popularity of Vendor by Volume Sold Liters
SELECT VendorNumber,VendorName,ROUND(SUM([VolumeSold(Liters)]),0) AS VolumeSold_Liters
FROM Sales2
GROUP BY VendorNumber,VendorName
ORDER BY VolumeSold_Liters DESC

--Popularity of Item by Volume Sold Liters
SELECT ItemNumber,ItemDescription,ROUND(SUM([VolumeSold(Liters)]),0) AS VolumeSold_Liters
FROM Sales2
GROUP BY ItemNumber,ItemDescription
ORDER BY VolumeSold_Liters DESC

--Popularity of Item by BottleVolume(ml)
SELECT ItemNumber,ItemDescription,[BottleVolume(ml)],COUNT([BottleVolume(ml)]) AS Number
FROM Sales2
GROUP BY ItemNumber,ItemDescription,[BottleVolume(ml)]
ORDER BY Number DESC

--View 1
--Purpose: Staff will be able to prepare the items and plan the delivery route according to the data.
CREATE VIEW NextWeekSales_view
AS 
SELECT InvoiceId,Date,StoreNumber,StoreName,Address,City,ZipCode,ItemNumber,ItemDescription,Pack,[BottleVolume(ml)],BottlesSold,[Sale(Dollars)]
FROM Sales2

--View all upcoming orders for the next 7 days (Assuming that 7 Jan is the next following day)
Select *
FROM NextWeekSales_view
WHERE Date BETWEEN '01/07/19' AND '01/14/19'
ORDER BY DATE,StoreNumber DESC

--View 2 
--List of prodcuts according to store and date 
--Purpose: The data will be useful for Iowa drivers when they do product count with the store employees.
WITH Store_Count AS(
SELECT *
FROM NextWeekSales_view
WHERE StoreNumber = '5078'
)
SELECT InvoiceId, Date, ItemNumber,ItemDescription,Pack,[BottleVolume(ml)],BottlesSold
FROM Store_Count
WHERE Date BETWEEN '01/07/19' AND '01/14/19'
ORDER BY ItemDescription ASC 

--Export the database to new excel file/csv 
SELECT *
FROM Sales2