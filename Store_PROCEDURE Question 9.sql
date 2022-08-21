CREATE DEFINER=`root`@`localhost` PROCEDURE `display_type_of_service`()
BEGIN
	SELECT supplier.SUPP_ID,supplier.SUPP_NAME, avg_ratings.avgRating, 
CASE
    WHEN avg_ratings.avgRating = 5 THEN "Excellent Service"
    WHEN avg_ratings.avgRating >=4 THEN "Good Service"
    WHEN avg_ratings.avgRating >=2 THEN "Average Service"
    ELSE "Poor Service"
END as Type_of_Service
FROM supplier as supplier 
inner join  (
SELECT supplier_pricing.SUPP_ID, avg(order_ratings.RAT_RATSTARS) as avgRating FROM supplier_pricing as supplier_pricing 
inner join (SELECT rating.ORD_ID, rating.RAT_RATSTARS,rating_details.PRICING_ID FROM rating as rating 
inner join (SELECT ORD_ID, PRICING_ID FROM `order`) as rating_details on rating_details.ORD_ID = rating.ORD_ID) as order_ratings 
on order_ratings.PRICING_ID = supplier_pricing.PRICING_ID group by supplier_pricing.SUPP_ID ) as avg_ratings on avg_ratings.SUPP_ID = supplier.SUPP_ID order by supplier.SUPP_ID
;
END