**📊 Social Media Engagement Analysis**
SQL-driven analysis of user behaviour, influencer segmentation, and hashtag intelligence on an Instagram clone dataset.

**🗂️ Project Overview**
This project analyses engagement patterns across a simulated social media platform using structured SQL queries. The goal was to move beyond raw data — turning join results into actionable insights a product or marketing team could actually use.

   Metric	              Value
Total Users	           100
Total Photos	         1,000+
Total Likes	           8,782
Total Comments	       7,488
Avg Tags per Post	     ~1.95

**🗃️ Database Schema**
The dataset (ig_clone.sql) consists of 5 relational tables:
<img width="430" height="118" alt="image" src="https://github.com/user-attachments/assets/6705c343-bf74-4c3a-96cf-c918a19a47e5" />

Table	                         Description
users	                   User profiles (id, username, created_at)
photos	                 Posts made by users (id, image_url, user_id)
likes	                   Like events linking users to photos
comments	               Comment text linked to users and photos
tags	                   Hashtags associated with photos

**🎯 Objectives**
Analyse engagement distribution across users
Identify top influencers by per-post engagement score
Surface high-performing hashtags for ad campaign targeting
Segment users into actionable tiers

**🔍 Key Findings**
**1. Engagement Distribution**
User activity is highly skewed — the platform has a healthy engagement rate among active users, but a large dormant base drags overall averages down.

     Segment	          Share	                            Description
Power Creators	        ~10%	                 High post frequency + high engagement per post
Active Engagers	        ~35%	                 Regular interaction, moderate posting
Casual Users	          ~15%	                 Occasional activity
Dormant Users	          ~40–45%	               Zero engagement — re-activation targets

**2. Top Influencer Candidates**
Users ranked by a composite engagement score (likes + comments + tags weighted per post):

Rank	                User	          Avg Engagement/Post
1	                  Meggie_Doyle	         75.0
2	                  Alexandro35         	 —
3	                  Adelle96	             —
…	                   …	                   …
Insight: Power Creators account for ~10% of users but generate a disproportionate share of total platform engagement.

**3. Hashtag Intelligence**
Average likes across all hashtags: 688.6

Hashtag	             Avg Likes	                       Ad Category
#dreamy	               35.75	                       Travel / Lifestyle
#beauty 	             —	                           Cosmetics / Hair
#stunning	             —	                           Travel / Lifestyle
#delicious	           —	                           Restaurants / F&B
Insight: Hashtag performance maps cleanly to advertiser verticals — enabling data-driven campaign targeting without guesswork.

**4. Ad Campaign KPI Framework**
KPI	                                  Description
CTR	                          Click-through rate — awareness quality
CVR	                          Conversion rate — landing page effectiveness
CPC	                          Cost per click — bid efficiency
CPA	                          Cost per acquisition — funnel cost
ROAS	                        Return on ad spend — budget allocation signal
Rule of thumb: Shift budget toward campaigns with ROAS > 4.

**💡 Strategic Recommendations**
Activate Power Creators — Creator badges, analytics dashboards, and brand collab pipelines
Hashtag-driven Ad Targeting — Map #dreamy, #beauty, #delicious to relevant advertiser categories
Re-engage Dormant Users — Comeback campaigns, personalised content reminders, re-activation emails
Influencer Tier Program — 4-tier framework (Brand Ambassador → Influencer Candidate → High Engagement Creator → Community Advocate)
Optimise Ad Spend via ROAS — Reallocate budget from underperforming campaigns (ROAS < 2) to high-ROAS ones (> 4)

**📁 Repository Structure**
<img width="683" height="301" alt="image" src="https://github.com/user-attachments/assets/7859ddd3-8dea-4fbb-90be-b9f563f0b5dc" />

👤 Author
Subhrajyoti Guha  — Data Analyst

Linkdien - https://www.linkedin.com/in/subhrajyoti-guha-50bba0211/
