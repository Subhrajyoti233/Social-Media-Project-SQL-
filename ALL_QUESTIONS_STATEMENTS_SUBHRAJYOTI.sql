-- Included only questions, which are all required SQL queries:

-- Q1
select created_at,username,count(*) as occurence
from users
group by username,created_at
having count(*) > 1;

select image_url,user_id,created_dat,count(*) as occurence
from photos
group by image_url,user_id,created_dat
having count(*) > 1

select comment_text,user_id,photo_id,created_at,count(*) as occurence
from comments
group by comment_text,user_id,photo_id,created_at
having count(*) > 1;

select photo_id,user_id,count(*) as occurence
from likes
group by photo_id,user_id
having count(*) > 1;

SELECT follower_id, followee_id, COUNT(*) AS occurrences
FROM follows
GROUP BY follower_id, followee_id
HAVING COUNT(*) > 1;

select tag_name,created_at
from tags
group by tag_name,created_at
having count(*) > 1;

SELECT photo_id, tag_id, COUNT(*) AS occurrences
FROM photo_tags
GROUP BY photo_id, tag_id
HAVING COUNT(*) > 1;

-- Q2
 select username,
coalesce(c.Total_comments,0)Total_comments,
coalesce(l.Total_likes,0) as Total_likes,
coalesce(p.Total_photo,0) as Total_Photos,
case 
when coalesce(c.Total_comments,0)+coalesce(l.Total_likes,0)+coalesce(p.Total_photo,0) >= 20 then 'High'
when coalesce(c.Total_comments,0)+coalesce(l.Total_likes,0)+coalesce(p.Total_photo,0) between 6 and 19 then 'Medium'
else 'Low'
end as Activity_level
from users u
left join (
select user_id, count(*) as Total_comments
from comments
group by user_id
) c on u.id = c.user_id
left join (
select user_id,count(*) as Total_likes
from likes
group by user_id
) l on u.id=l.user_id
left join (
select user_id,count(*) as Total_photo
from photos
group by user_id
) p on u.id=p.user_id;

-- Q3

select AVG(count_perpost) as Avg_Per_Post
from (
    select p.id, count(pt.tag_id) as count_perpost
    FROM photos p
    left join photo_tags pt
    ON p.id = pt.photo_id
    GROUP BY p.id
) AS num_of_tags;

-- Q4

select u.id,
u.username,
count(distinct l.user_id) as num_likes,
count(distinct c.id) as num_comments,
((count(distinct l.user_id) + count(distinct c.id)) / nullif(count(p.id),0)) as engaement_rate,
rank() over (order by (count(distinct l.user_id) + count(distinct c.id)) / nullif(count(p.id), 0) desc) as rn
from users u 
join photos p on u.id= p.user_id
left join likes l on p.id = l.photo_id
left join comments c on p.id = c.photo_id
group by u.id, u.username
order by rn;


-- Q5

select 
    u.username,
    COUNT(distinct f1.followee_id) as following_count,
    COUNT(distinct f2.follower_id) as followers_count
from users u
left join follows f1 on u.id = f1.follower_id 
left join follows f2 on u.id = f2.followee_id 
group BY u.id, u.username
order BY followers_count desc, following_count desc;

-- Q6

SELECT 
    u.username,
    COALESCE(l.total_likes, 0) AS total_likes,
    COALESCE(c.total_comments, 0) AS total_comments,
    COALESCE(p.total_posts, 0) AS total_posts,
    CASE 
        WHEN COALESCE(p.total_posts, 0) = 0 THEN 0
        ELSE (COALESCE(l.total_likes,0) + COALESCE(c.total_comments,0)) / COALESCE(p.total_posts,1)
    END AS avg_engagement_per_post
FROM users u
LEFT JOIN (
    SELECT p.user_id, COUNT(l.user_id) AS total_likes
    FROM photos p
    LEFT JOIN likes l ON p.id = l.photo_id
    GROUP BY p.user_id
) l ON u.id = l.user_id
LEFT JOIN (
    SELECT p.user_id, COUNT(c.id) AS total_comments
    FROM photos p
    LEFT JOIN comments c ON p.id = c.photo_id
    GROUP BY p.user_id
) c ON u.id = c.user_id
LEFT JOIN (
    SELECT user_id, COUNT(id) AS total_posts
    FROM photos
    GROUP BY user_id
) p ON u.id = p.user_id
order by avg_engagement_per_post desc
limit 5;

-- Q7

select u.id, u.username
from users u
left join likes l on u.id = l.user_id
where l.user_id is null;


-- Q10

SELECT 
    u.username,
    COALESCE(l.total_likes, 0) AS total_likes,
    COALESCE(c.total_comments, 0) AS total_comments,
    COALESCE(pt.total_photo_tags, 0) AS total_photo_tags
FROM users u
LEFT JOIN (
    SELECT p.user_id, COUNT(l.user_id) AS total_likes
    FROM photos p
    LEFT JOIN likes l ON p.id = l.photo_id
    GROUP BY p.user_id
) l ON u.id = l.user_id
LEFT JOIN (
    SELECT p.user_id, COUNT(c.id) AS total_comments
    FROM photos p
    LEFT JOIN comments c ON p.id = c.photo_id
    GROUP BY p.user_id
) c ON u.id = c.user_id
LEFT JOIN (
    SELECT p.user_id, COUNT(pt.tag_id) AS total_photo_tags
    FROM photos p
    LEFT JOIN photo_tags pt ON p.id = pt.photo_id
    GROUP BY p.user_id
) pt ON u.id = pt.user_id;

-- Q11

SELECT 
    u.id,
    u.username,
    COALESCE(l.total_likes, 0) + COALESCE(c.total_comments, 0) + COALESCE(pt.total_tags, 0) AS total_engagement,
    RANK() OVER (ORDER BY COALESCE(l.total_likes, 0) + COALESCE(c.total_comments, 0) + COALESCE(pt.total_tags, 0) DESC) AS engagement_rank
FROM users u
LEFT JOIN (
    SELECT p.user_id, COUNT(l.user_id) AS total_likes
    FROM photos p
    LEFT JOIN likes l ON p.id = l.photo_id
    WHERE l.created_at >= DATE_SUB(CURDATE(), INTERVAL 1 MONTH)
    GROUP BY p.user_id
) l ON u.id = l.user_id
LEFT JOIN (
    SELECT p.user_id, COUNT(c.id) AS total_comments
    FROM photos p
    LEFT JOIN comments c ON p.id = c.photo_id
    WHERE c.created_at >= DATE_SUB(CURDATE(), INTERVAL 1 MONTH)
    GROUP BY p.user_id
) c ON u.id = c.user_id
LEFT JOIN (
    SELECT p.user_id, COUNT(pt.tag_id) AS total_tags
    FROM photos p
    LEFT JOIN photo_tags pt ON p.id = pt.photo_id
    WHERE p.created_dat >= DATE_SUB(CURDATE(), INTERVAL 1 MONTH)
    GROUP BY p.user_id
) pt ON u.id = pt.user_id
ORDER BY engagement_rank;

-- Q12

WITH photo_likes AS (
    SELECT 
        p.id AS photo_id,
        COUNT(l.user_id) AS total_likes
    FROM photos p
    LEFT JOIN likes l ON p.id = l.photo_id
    GROUP BY p.id
),
hashtag_avg_likes AS (
    SELECT 
        t.tag_name,
        AVG(pl.total_likes) AS avg_likes
    FROM tags t
    JOIN photo_tags pt ON t.id = pt.tag_id
    JOIN photo_likes pl ON pt.photo_id = pl.photo_id
    GROUP BY t.tag_name
)
SELECT tag_name, avg_likes
FROM hashtag_avg_likes
WHERE avg_likes = (SELECT MAX(avg_likes) FROM hashtag_avg_likes);

-- Q13

SELECT 
    f1.follower_id AS user_id,
    u.username,
    f1.followee_id AS followed_user_id,
    u2.username AS followed_username,
    f1.created_at AS followed_at,
    f2.created_at AS followed_by_at
FROM follows f1
JOIN follows f2 
    ON f1.follower_id = f2.followee_id 
    AND f1.followee_id = f2.follower_id
JOIN users u ON f1.follower_id = u.id
JOIN users u2 ON f1.followee_id = u2.id
WHERE f1.created_at >= f2.created_at; 

-- Subjective 

-- Q2:

select 
    u.id,
    u.username
from users u
left join photos p on u.id = p.user_id and p.created_dat >= date_sub(curdate(), interval 6 month)
left join likes l on u.id = l.user_id and l.created_at >= date_sub(curdate(), interval 6 month)
left join comments c on u.id = c.user_id and c.created_at >= date_sub(curdate(), interval 6 month)
where p.id is null 
  and l.photo_id is null 
  and c.id is null
order by u.username;

-- Q3

with photo_engagement as (
    select 
        p.id as photo_id,
        count(distinct l.user_id) as total_likes,
        count(distinct c.id) as total_comments
    from photos p
    left join likes l on p.id = l.photo_id
    left join comments c on p.id = c.photo_id
    group by p.id
),
hashtag_engagement as (
    select 
        t.tag_name,
        avg(coalesce(pe.total_likes,0) + coalesce(pe.total_comments,0)) as avg_engagement
    from tags t
    join photo_tags pt on t.id = pt.tag_id
    join photo_engagement pe on pt.photo_id = pe.photo_id
    group by t.tag_name
)
select tag_name, avg_engagement
from hashtag_engagement
order by avg_engagement desc
limit 10;

-- Q4

with user_cohort as (
    select 
        id as user_id,
        username,
        case 
            when created_at >= date_sub(curdate(), interval 3 month) then 'new_user'
            else 'old_user'
        end as cohort
    from users
),
photo_engagement as (
    select 
        p.id as photo_id,
        p.user_id,
        dayname(p.created_dat) as post_day,
        count(distinct l.user_id) as total_likes,
        count(distinct c.id) as total_comments
    from photos p
    left join likes l on p.id = l.photo_id
    left join comments c on p.id = c.photo_id
    group by p.id, p.user_id, dayname(p.created_dat)
),
weekdays as (
    select 'Monday' as day union all
    select 'Tuesday' union all
    select 'Wednesday' union all
    select 'Thursday' union all
    select 'Friday' union all
    select 'Saturday' union all
    select 'Sunday'
),
cohort_days as (
    select uc.cohort, w.day as post_day
    from (select distinct cohort from user_cohort) uc
    cross join weekdays w
)
select 
    cd.cohort,
    cd.post_day,
    round(coalesce(avg(pe.total_likes + pe.total_comments),0),2) as avg_engagement
from cohort_days cd
left join user_cohort uc on cd.cohort = uc.cohort
left join photo_engagement pe on uc.user_id = pe.user_id and cd.post_day = pe.post_day
group by cd.cohort, cd.post_day
order by cd.cohort, avg_engagement desc;

-- Q5

SELECT 
    u.username,
    COALESCE(followers_count, 0) AS total_followers,
    COALESCE(total_likes, 0) + COALESCE(total_comments, 0) AS total_engagement
FROM users u
LEFT JOIN (
    SELECT followee_id, COUNT(follower_id) AS followers_count
    FROM follows
    GROUP BY followee_id
) f ON u.id = f.followee_id
LEFT JOIN (
    SELECT p.user_id, 
           COUNT(DISTINCT l.user_id) AS total_likes,
           COUNT(DISTINCT c.id) AS total_comments
    FROM photos p
    LEFT JOIN likes l ON p.id = l.photo_id
    LEFT JOIN comments c ON p.id = c.photo_id
    GROUP BY p.user_id
) e ON u.id = e.user_id
ORDER BY total_followers DESC, total_engagement DESC;

-- Q6

SELECT 
    u.username,
    COALESCE(p.Total_Photos, 0) AS total_posts,
    COALESCE(l.Total_Likes, 0) AS total_likes,
    COALESCE(c.Total_Comments, 0) AS total_comments,
    CASE 
        WHEN COALESCE(p.Total_Photos, 0) + COALESCE(l.Total_Likes, 0) + COALESCE(c.Total_Comments, 0) >= 20 THEN 'High Activity'
        WHEN COALESCE(p.Total_Photos, 0) + COALESCE(l.Total_Likes, 0) + COALESCE(c.Total_Comments, 0) BETWEEN 6 AND 19 THEN 'Medium Activity'
        ELSE 'Low Activity'
    END AS activity_segment
FROM users u
LEFT JOIN (
    SELECT user_id, COUNT(*) AS Total_Photos
    FROM photos
    GROUP BY user_id
) p ON u.id = p.user_id
LEFT JOIN (
    SELECT user_id, COUNT(*) AS Total_Likes
    FROM likes
    GROUP BY user_id
) l ON u.id = l.user_id
LEFT JOIN (
    SELECT user_id, COUNT(*) AS Total_Comments
    FROM comments
    GROUP BY user_id
) c ON u.id = c.user_id
ORDER BY activity_segment DESC, total_posts DESC;

-- Q8

SELECT 
    u.username,
    COALESCE(p.Total_Photos, 0) AS total_posts,
    COALESCE(l.Total_Likes, 0) AS total_likes,
    COALESCE(c.Total_Comments, 0) AS total_comments,
    (COALESCE(p.Total_Photos, 0) + COALESCE(l.Total_Likes, 0) + COALESCE(c.Total_Comments, 0)) AS engagement_score
FROM users u
LEFT JOIN (
    SELECT user_id, COUNT(*) AS Total_Photos
    FROM photos
    GROUP BY user_id
) p ON u.id = p.user_id
LEFT JOIN (
    SELECT user_id, COUNT(*) AS Total_Likes
    FROM likes
    GROUP BY user_id
) l ON u.id = l.user_id
LEFT JOIN (
    SELECT user_id, COUNT(*) AS Total_Comments
    FROM comments
    GROUP BY user_id
) c ON u.id = c.user_id
ORDER BY engagement_score DESC
LIMIT 10;

-- Q10
UPDATE User_Interactions
SET Engagement_Type = 'Heart'
WHERE Engagement_Type = 'Like';