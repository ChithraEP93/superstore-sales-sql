--Goal 1: Top 10 products by revenue.
SELECT "Product Name",SUM(Sales) AS Total_Sales
FROM orders
GROUP BY "Product Name"
ORDER BY Total_Sales DESC
LIMIT 10

--Goal 2: Top 10 Customers by Lifetime Sales
SELECT "Customer ID","Customer Name", SUM(Sales)
FROM orders
GROUP BY "Customer ID", "Customer Name"
ORDER BY SUM(Sales) DESC
LIMIT 10

--Goal 3: Category & Sub-Category Performance
SELECT Category,"Sub-Category",SUM(Sales) as total_sales,SUM(Profit) as total_profit
FROM orders
GROUP BY Category,"Sub-Category"
ORDER BY SUM(Sales)

--Goal 4: Average Discount by Region
SELECT Region,SUM(Sales) as total_sales,ROUND(AVG(Discount),4) as average_discount
FROM orders
GROUP BY Region
ORDER BY SUM(Sales) DESC

--Goal 5: Customers Above Average Sales
SELECT "Customer Name" AS Customer_Name,SUM(Sales) AS sales_sum
FROM orders
GROUP BY "Customer Name"
HAVING SUM(Sales) > (SELECT AVG(total_sales) FROM (SELECT SUM(Sales) AS total_sales
                                          FROM orders
                                          GROUP BY "Customer Name")) 

--Goal 6: Top 5 Products per Category
SELECT "Product ID","Product Name",Category,total_sales
FROM ( SELECT "Product ID","Product Name",Category,SUM(Sales) as total_sales,
         ROW_NUMBER() OVER(
		 PARTITION BY Category
		 ORDER BY SUM(Sales) DESC) AS rn
        FROM orders
        GROUP BY Category,"Product ID","Product Name"
	 ) WHERE RN<=5
	  ORDER BY Category 


--Goal 7:Cumulative Monthly Sales
WITH monthly_sales AS (
  SELECT substr("Order Date", 7, 4) || '-' || substr("Order Date", 1, 2) AS Month,
         SUM(Sales) AS Monthly_Sales
  FROM orders
  GROUP BY Month
  ORDER BY Month
)
SELECT Month, Monthly_Sales,
       SUM(Monthly_Sales) OVER (ORDER BY Month) AS Cumulative_Sales
FROM monthly_sales; 

