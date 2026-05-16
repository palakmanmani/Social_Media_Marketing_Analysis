use social_media_marketing;

-- total revenue and ad spend per platform
SELECT platform, 
       SUM(ad_spend) AS total_ad_spend,
       SUM(revenue) AS total_revenue
FROM campaigns
GROUP BY platform
ORDER BY total_revenue DESC;

-- top 5 campaigns by ROI
SELECT campaign_name, platform, roi_percent
FROM campaigns
ORDER BY roi_percent DESC
LIMIT 5;

-- avg  engagement by content type
SELECT content_type,
       AVG(engagement_rate_percent) AS avg_engagement,
       SUM(likes) AS total_likes
FROM posts
GROUP BY content_type
ORDER BY avg_engagement DESC;


-- CTR and conversion for sales campaigns
SELECT campaign_type,
       AVG(ctr_percent) AS avg_ctr,
       AVG(conversion_rate_percent) AS avg_conversion
FROM campaigns
WHERE campaign_type = 'Sales'
GROUP BY campaign_type;


-- best posting time per platform


SELECT platform, posting_time,
       AVG(engagement_rate_percent) AS avg_engagement,
       SUM(views) AS total_views
FROM posts
GROUP BY platform, posting_time
ORDER BY platform, avg_engagement DESC;

-- Influencers with 1M+ followers by category
SELECT category,
       COUNT(*) AS influencer_count,
       AVG(engagement_rate_percent) AS avg_engagement
FROM influencers
WHERE followers > 1000000
GROUP BY category
ORDER BY avg_engagement DESC;


-- Rank influencers within each platform

SELECT influencer_name, platform, followers,
       engagement_rate_percent,
       RANK() OVER (PARTITION BY platform ORDER BY engagement_rate_percent DESC) AS rnk
FROM influencers;

-- CTE to find best campaign per platform
WITH ranked_campaigns AS (
    SELECT campaign_name, platform, roi_percent,
           RANK() OVER (PARTITION BY platform ORDER BY roi_percent DESC) AS rnk
    FROM campaigns
)
SELECT campaign_name, platform, roi_percent
FROM ranked_campaigns
WHERE rnk = 1;

-- month wise revenue trend 
SELECT MONTHNAME(campaign_date) AS month_name,
       MONTH(campaign_date) AS month_num,
       SUM(revenue) AS total_revenue,
       SUM(ad_spend) AS total_spend
FROM campaigns
GROUP BY month_name, month_num
ORDER BY month_num;


-- show post with more than 100,000 likes
SELECT post_id, platform, content_type, likes
FROM posts
WHERE likes > 100000
ORDER BY likes DESC;

-- count total campaigns per platform
SELECT platform, COUNT(*) AS total_campaigns
FROM campaigns
GROUP BY platform
ORDER BY total_campaigns DESC;


-- avg followers per influencer category
SELECT category,
       AVG(followers) AS avg_followers,
       COUNT(*) AS total_influencers
FROM influencers
GROUP BY category
ORDER BY avg_followers DESC;

-- total likes,share,comments per platform
SELECT platform,
       SUM(likes) AS total_likes,
       SUM(comments) AS total_comments,
       SUM(shares) AS total_shares
FROM posts
GROUP BY platform
ORDER BY total_likes DESC;

-- campaign with highest and lowest ad spend
SELECT campaign_name, platform, ad_spend
FROM campaigns
ORDER BY ad_spend DESC;
