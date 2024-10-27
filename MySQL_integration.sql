juCREATE DATABASE amazon;

use amazon;

CREATE TABLE amazon_data(
	product_id VARCHAR(20),
    product_name VARCHAR(255),
    discounted_price DECIMAL(10, 2),
    actual_price DECIMAL(10, 2),
    discount_percentage DECIMAL(5, 2),
    rating DECIMAL(3, 2),
    rating_count FLOAT,
    about_product TEXT,
    user_id VARCHAR(255),
    user_name VARCHAR(255),
    review_id VARCHAR(255),
    review_title VARCHAR(255),
    review_content VARCHAR(255),
    img_link VARCHAR(255),
    product_link VARCHAR(255),
    category1 VARCHAR(255),
    category2 VARCHAR(255),
    rating_score VARCHAR(255),
	difference_price VARCHAR(255)
);
drop table amazon_data;
SELECT * FROM amazon_data;
select count(*) from amazon_data;

