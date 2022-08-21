-- Q 3)	Display the total number of customers based on gender who have placed orders of worth at least Rs.3000.

SELECT COUNT(customerDetails.CUS_ID) AS No_of_Customer,customerDetails.CUS_GENDER
FROM customer AS customerDetails  INNER JOIN
(SELECT sum(orderDetails.ORD_Amount) as order_amt, orderDetails.CUS_ID FROM `order` AS orderDetails group by orderDetails.CUS_ID having sum(ORD_Amount)>=3000)
orderDetailsAtLeast ON customerDetails.CUS_ID = orderDetailsAtLeast.CUS_ID GROUP BY customerDetails.CUS_GENDER;



-- Q4)	Display all the orders along with product name ordered by a customer having Customer_Id=2

SELECT product.ORD_ID, productDetails.PRO_ID, productDetails.PRO_NAME, product.ORD_AMOUNT, product.ORD_DATE  FROM (SELECT PRO_NAME, PRO_ID FROM product) AS productDetails 
INNER JOIN (SELECT OrderDeTails.ORD_ID, Prices.PRO_ID, Prices.PRICING_ID, OrderDeTails.CUS_Id, OrderDeTails.ORD_AMOUNT,OrderDeTails.ORD_DATE 
FROM (SELECT PRICING_ID, PRO_ID FROM supplier_pricing) AS Prices 
INNER JOIN (SELECT ORD_ID,CUS_Id, PRICING_ID,ORD_AMOUNT, ORD_DATE FROM `order` WHERE CUS_Id = "2") AS OrderDeTails 
ON Prices.PRICING_ID = OrderDeTails.PRICING_ID) 
AS product ON product.PRO_ID = productDetails.PRO_ID; 

-- Q 5)	Display the Supplier details who can supply more than one product.

SELECT Supp_Details.SUPP_ID, Supp_Details.SUPP_NAME, Supp_Details.SUPP_CITY, Supp_Details.SUPP_PHONE FROM supplier as Supp_Details
inner join (SELECT count(PRO_ID) as ProductsSelling, SUPP_ID FROM supplier_pricing group by SUPP_ID having count(PRO_ID)>1) 
as MaxSupp on MaxSupp.SUPP_ID = Supp_Details.SUPP_ID;

-- Q6)	Find the least expensive product from each category and print the table with category id, name, product name and price of the product

SELECT productDetails.CAT_ID,productDetails.CAT_NAME, productDetails.PRO_NAME, min(supplier_pricing.SUPP_PRICE) as Price FROM supplier_pricing as supplier_pricing 
inner join (SELECT pro_cat_details.PRO_ID , pro_cat_details.PRO_NAME, category.CAT_ID, category.CAT_NAME FROM category as category 
inner join (SELECT PRO_ID, CAT_ID, PRO_NAME FROM product) as pro_cat_details on pro_cat_details.CAT_ID = category.CAT_ID) 
as productDetails on productDetails.PRO_ID = supplier_pricing.PRO_ID  group by  productDetails.CAT_ID order by  productDetails.CAT_ID;

-- Q7)	Display the Id and Name of the Product ordered after “2021-10-05”.;

SELECT p_details.PRO_ID, p_details.PRO_NAME,order_details.ORD_DATE FROM `order` as order_details 
inner join (SELECT product.PRO_ID, product.PRO_NAME, price_id_details.PRICING_ID FROM product as product 
inner join (SELECT PRICING_ID,PRO_ID FROM supplier_pricing) as price_id_details on price_id_details.PRO_ID = product.PRO_ID) 
as p_details on p_details.PRICING_ID = order_details.PRICING_ID where order_details.ORD_DATE > '2021-10-05';

-- Q8)	Display customer name and gender whose names start or end with character 'A'. 

-- Solution 1 -----------------
SELECT CUS_NAME,CUS_GENDER FROM customer where CUS_NAME like '%A%';

-- Solutions 2 -----------------
SELECT CUS_NAME,CUS_GENDER FROM customer where CUS_NAME like '%A' or CUS_NAME like 'A%';
-- ----------------------------
-- Q9)	Create a stored procedure to display supplier id, name, rating and Type_of_Service. 
-- For Type_of_Service, If rating =5, print “Excellent Service”,If rating >4 print “Good Service”, If rating >2 print “Average Service” else print “Poor Service”.

call display_type_of_service;



