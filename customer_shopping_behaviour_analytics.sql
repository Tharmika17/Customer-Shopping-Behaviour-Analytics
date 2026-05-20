create database customer_behaviour;
use customer_behaviour;
select * from customer limit 10;

-- Total Revenue by gender
SELECT gender,
       count(customer_id) AS total_customers,
       round(sum(purchase_amount), 2) AS total_revenue
FROM customer
GROUP BY gender
ORDER BY total_revenue DESC;

-- Discount users who spent above average
 SELECT customer_id,
       purchase_amount,
       rfm_segment,
       spend_tier
FROM customer
WHERE discount_applied = 'Yes'
  AND purchase_amount >= (SELECT AVG(purchase_amount) FROM customer)
ORDER BY purchase_amount DESC;
 
 -- Top 5 products by average review rating
SELECT item_purchased,
       ROUND(AVG(review_rating), 2) AS avg_rating,
       COUNT(customer_id) AS total_purchases
FROM customer
GROUP BY item_purchased
ORDER BY avg_rating DESC
LIMIT 5;
 
 -- Q4 The average spend by standard vs express shipping
SELECT shipping_type,
       COUNT(customer_id) AS total_orders,
       ROUND(AVG(purchase_amount), 2) AS avg_spend
FROM customer
WHERE shipping_type IN ('Standard', 'Express')
GROUP BY shipping_type
ORDER BY avg_spend DESC;
 
 -- Q5 Revenue and avg spend by subscription status
SELECT subscription_status,
       COUNT(customer_id) AS total_customers,
       ROUND(SUM(purchase_amount), 2) AS total_revenue,
       ROUND(AVG(purchase_amount), 2) AS avg_spend
FROM customer
GROUP BY subscription_status
ORDER BY total_revenue DESC;
 
 -- Q6 Top 5 products by discount usage rate
 -- CASE WHEN counts 1 for every discount used, 0 otherwise
SELECT item_purchased,
       COUNT(customer_id) AS total_purchases,
       ROUND(100.0 * SUM(CASE WHEN discount_applied = 'Yes' THEN 1 ELSE 0 END) / COUNT(*), 2) AS discount_rate_pct
FROM customer
GROUP BY item_purchased
ORDER BY discount_rate_pct DESC
LIMIT 5;
 
-- Q7. Customer segmentation by previous purchases (CTE)
-- CTE assigns each customer a segment based on number of previous purchases
-- 1-2 purchases = New, 3-10 = Returning, 11+ = Loyal

WITH customer_type AS (
    SELECT customer_id,
           previous_purchases,
           CASE
               WHEN previous_purchases <= 2  THEN 'New'
               WHEN previous_purchases <= 10 THEN 'Returning'
               ELSE 'Loyal'
           END AS customer_segment
    FROM customer
)
SELECT customer_segment,
       COUNT(*) AS total_customers
FROM customer_type
GROUP BY customer_segment
ORDER BY total_customers DESC;

-- Q8. Top 3 products per category by revenue (CTE + Window Function)
with ranked_items as (
    select category,
           item_purchased,
           sum(purchase_amount) as total_revenue,
           row_number() over (partition by category order by sum(purchase_amount) desc) as item_rank
    from customer
    group by category, item_purchased
)
select item_rank,
       category,
       item_purchased,
       round(total_revenue, 2) as total_revenue
from ranked_items
where item_rank <= 3
order by category, item_rank;

-- Q9. Repeat buyers vs subscription status
SELECT subscription_status,
       COUNT(customer_id) AS repeat_buyers
FROM customer
WHERE previous_purchases > 5
GROUP BY subscription_status
ORDER BY repeat_buyers DESC;

-- Q10. Revenue contribution by age group
SELECT age_group,
       COUNT(customer_id) AS total_customers,
       ROUND(SUM(purchase_amount), 2) AS total_revenue,
       ROUND(AVG(purchase_amount), 2) AS avg_spend
FROM customer
GROUP BY age_group
ORDER BY total_revenue DESC;

-- Q11. Revenue and avg spend by RFM segment
SELECT rfm_segment,
       COUNT(customer_id) AS total_customers,
       ROUND(AVG(purchase_amount), 2) AS avg_spend,
       ROUND(SUM(purchase_amount), 2) AS total_revenue
FROM customer
GROUP BY rfm_segment
ORDER BY total_revenue DESC;

-- Q12. Discount usage rate by RFM segment
SELECT rfm_segment,
       COUNT(customer_id) AS total_customers,
       SUM(CASE WHEN discount_applied = 'Yes' THEN 1 ELSE 0 END) AS discount_users,
       ROUND(100.0 * SUM(CASE WHEN discount_applied = 'Yes' THEN 1 ELSE 0 END) / COUNT(*), 2) AS discount_rate_pct
FROM customer
GROUP BY rfm_segment
ORDER BY discount_rate_pct DESC;

-- Q13. Behaviour changes across loyalty stages
-- 1_New, 2_Returning, 3_Established, 4_Loyal
SELECT loyalty_stage,
       COUNT(customer_id) AS total_customers,
       ROUND(AVG(purchase_amount), 2) AS avg_spend,
       ROUND(AVG(review_rating), 2) AS avg_rating,
       ROUND(100.0 * SUM(CASE WHEN subscription_status = 'Yes' THEN 1 ELSE 0 END) / COUNT(*), 2) AS subscription_pct,
       ROUND(100.0 * SUM(CASE WHEN discount_applied = 'Yes' THEN 1 ELSE 0 END) / COUNT(*), 2) AS discount_pct
FROM customer
GROUP BY loyalty_stage
ORDER BY loyalty_stage;

-- Q14. Revenue by season and category
SELECT season,
       category,
       COUNT(customer_id) AS total_orders,
       ROUND(SUM(purchase_amount), 2) AS total_revenue,
       ROUND(AVG(purchase_amount), 2) AS avg_spend
FROM customer
GROUP BY season, category
ORDER BY season, total_revenue DESC;

-- Q15. Top 10 states by total revenue
SELECT location AS state,
       COUNT(customer_id) AS total_customers,
       ROUND(SUM(purchase_amount), 2) AS total_revenue,
       ROUND(AVG(purchase_amount), 2) AS avg_spend
FROM customer
GROUP BY location
ORDER BY total_revenue DESC
LIMIT 10;

-- Q16. Payment method preference by spend tier
SELECT spend_tier,
       payment_method,
       COUNT(customer_id) AS total_customers,
       ROUND(AVG(purchase_amount), 2) AS avg_spend
FROM customer
GROUP BY spend_tier, payment_method
ORDER BY spend_tier, total_customers DESC;

-- Q17. Shipping type impact on spend and satisfaction
-- compares average spend and average review rating per shipping type
SELECT shipping_type,
       COUNT(customer_id) AS total_orders,
       ROUND(AVG(purchase_amount), 2) AS avg_spend,
       ROUND(AVG(review_rating), 2) AS avg_rating
FROM customer
GROUP BY shipping_type
ORDER BY avg_spend DESC;

-- Q18. Champion customer profile
SELECT gender,
       age_group,
       category,
       payment_method,
       COUNT(customer_id) AS total_customers,
       ROUND(AVG(purchase_amount), 2) AS avg_spend
FROM customer
WHERE rfm_segment = 'Champions'
GROUP BY gender, age_group, category, payment_method
ORDER BY total_customers DESC
LIMIT 10;

-- Q19. Revenue and behaviour summary by customer cluster
-- groups customers into Budget Shopper, Mid Range, High Value segments
SELECT cluster_label,
       COUNT(customer_id) AS total_customers,
       ROUND(AVG(age), 1) AS avg_age,
       ROUND(AVG(purchase_amount), 2) AS avg_spend,
       ROUND(AVG(previous_purchases), 1) AS avg_purchases,
       ROUND(100.0 * SUM(CASE WHEN subscription_status = 'Yes' THEN 1 ELSE 0 END) / COUNT(*), 2) AS subscription_pct
FROM customer
GROUP BY cluster_label
ORDER BY avg_spend DESC;

-- Q20. Top 5 spenders within each RFM segment (CTE + Window Function)
WITH ranked_customers AS (
    SELECT customer_id,
           age_group,
           gender,
           rfm_segment,
           loyalty_stage,
           spend_tier,
           purchase_amount,
           RANK() OVER (PARTITION BY rfm_segment ORDER BY purchase_amount DESC) AS spend_rank
    FROM customer
)
SELECT customer_id,
       age_group,
       gender,
       rfm_segment,
       loyalty_stage,
       spend_tier,
       purchase_amount,
       spend_rank
FROM ranked_customers
WHERE spend_rank <= 5
ORDER BY rfm_segment, spend_rank;
