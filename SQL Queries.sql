# QUERIES 
#1 Find the top 10 products with the highest average rating:
SELECT product_name, rating, rating_count
FROM amazon_data
ORDER BY rating DESC, rating_count DESC
LIMIT 10;

#2 Identify the top 10 products with the highest discount percentage:
SELECT product_name, discounted_price, actual_price, discount_percentage
FROM amazon_data
ORDER BY discount_percentage DESC
LIMIT 10;

#3 Popular Categories:
SELECT category1, COUNT(*) AS product_count
FROM amazon_data
GROUP BY category1
ORDER BY product_count DESC;

#4 Average Rating by Category:
SELECT category1, AVG(rating) AS avg_rating
FROM amazon_data
GROUP BY category1
ORDER BY avg_rating DESC;

#5 Products with Low Ratings but High Discounts:
SELECT product_name, rating, discount_percentage, discounted_price
FROM amazon_data
WHERE rating < 3.0 AND discount_percentage > 30
ORDER BY discount_percentage DESC;

#6 Products with the Most Reviews:
SELECT product_name, rating_count
FROM amazon_data
ORDER BY rating_count DESC
LIMIT 10;

#7 Correlation Between Rating and Discount Percentage, correlation= cov(x,y)/sd(x)*sd(y)
SELECT 
    ROUND((SUM((rating - avg_rating) * (discount_percentage - avg_discount)) / (COUNT(*) - 1)) /
	(SQRT(SUM(POW(rating - avg_rating, 2)) / (COUNT(*) - 1)) * SQRT(SUM(POW(discount_percentage - avg_discount, 2)) / (COUNT(*) - 1))),2) 
	AS rating_discount_correlation
FROM 
    (SELECT rating, discount_percentage, 
    AVG(rating) OVER() AS avg_rating,
    AVG(discount_percentage) OVER() AS avg_discount
	FROM amazon_data) AS subquery;

#8#7 Correlation Between Rating and Actual price, correlation= cov(x,y)/sd(x)*sd(y)
SELECT 
    ROUND((SUM((rating - avg_rating) * (actual_price - avg_actual)) / (COUNT(*) - 1)) /
	(SQRT(SUM(POW(rating - avg_rating, 2)) / (COUNT(*) - 1)) * SQRT(SUM(POW(actual_price - avg_actual, 2)) / (COUNT(*) - 1))),2) 
	AS rating_actual_correlation
FROM 
    (SELECT rating, actual_price, 
    AVG(rating) OVER() AS avg_rating,
    AVG(actual_price) OVER() AS avg_actual
	FROM amazon_data) AS subquery;
    
#9 Find Products with the Highest Price Difference
SELECT product_name, actual_price, discounted_price, 
       (actual_price - discounted_price) AS price_difference
FROM amazon_data
ORDER BY price_difference DESC
LIMIT 10;

#10 Find products that have high ratings but relatively few reviews
SELECT product_name, rating, rating_count
FROM amazon_data
WHERE rating >= 4.5 AND rating_count < 100
ORDER BY rating DESC;

#11 Average Discount Percentage by Category
SELECT category1, AVG(discount_percentage) AS avg_discount
FROM amazon_data
GROUP BY category1
ORDER BY avg_discount DESC;

#12 Find the most reviewed product within each main category
SELECT category1, product_name, rating_count AS max_reviews
FROM amazon_data
WHERE (category1, rating_count) 
    IN (SELECT category1, MAX(rating_count)
    FROM amazon_data
    GROUP BY category1)
ORDER BY max_reviews DESC
LIMIT 100;

#13 Compare Average Rating for Products With and Without Discounts
SELECT 
    CASE WHEN discount_percentage > 0 THEN 'Discounted' ELSE 'Non-discounted' END AS discount_status,
    AVG(rating) AS avg_rating
FROM amazon_data
GROUP BY discount_status;

#14 Top Products by Rating in Each Category
SELECT p.category,
       p.product_name,
       MAX(r.rating) AS max_rating
FROM products p
JOIN reviews r ON p.product_id = r.product_id
GROUP BY p.category, p.product_name
ORDER BY max_rating DESC;

#15. Average Price and Rating per Category with Product Count
SELECT category1,
       AVG(actual_price) AS avg_price,
       AVG(rating) AS avg_rating,
       COUNT(product_id) AS product_count
FROM amazon_data
GROUP BY category1
HAVING avg_rating > 4.0
ORDER BY avg_rating DESC;

#16. Products with Lower-than-Average Ratings per Category
SELECT t1.product_name,
       t1.category1,
       t1.rating AS product_rating,
       t2.avg_category_rating
FROM amazon_data t1
JOIN (SELECT category1, AVG(rating) AS avg_category_rating
      FROM amazon_data
      GROUP BY category1) t2
ON t1.category1 = t2.category1
WHERE t1.rating < t2.avg_category_rating
ORDER BY t1.category1, product_rating;