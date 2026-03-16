create database marketing_campaign_db
use marketing_campaign_db

select count(*) from customers
select count(*) from campaigns
select count(*) from campaign_interactions

select top 5 * from customers
select top 5 * from campaigns
select top 5 * from campaign_interactions


select 
	i.customer_id,
	c.age,
	c.city,
	c.income_bracket,
	cam.campaign_name,
	cam.channel,
	i.email_opened,
	i.link_clicked,
	i.product_purchased,
	i.purchase_amount
from campaign_interactions i
join customers c
on i.customer_id=c.customer_id
join campaigns cam
on i.campaign_id=cam.campaign_id


--Funnel Analysis
select 
count(*) as total_interactions,
sum(cast(email_opened as int)) as total_opens,
sum(cast(link_clicked as int)) as total_clicks,
sum(cast(product_purchased as int)) as total_purchases
from campaign_interactions

--campaign performance
select
	cam.campaign_name,
	count(*) as emails_sent,
	sum(i.purchase_amount) as revenue,
	sum(cast(i.product_purchased as int)) as purchases,
	avg(cast(i.product_purchased as float))*100 as conversion_rate
from campaign_interactions i
join campaigns cam
on i.campaign_id = cam.campaign_id
group by cam.campaign_name
order by revenue desc

--channel performance 
select 
	cam.channel,
	count(*) as total_interactions,
	sum(cast(i.product_purchased as int)) as total_purchases,
	sum(i.purchase_amount) as revenue,
	avg(cast(i.product_purchased as float))* 100 as conversion_rate
from campaign_interactions i
join campaigns cam
on i.campaign_id= cam.campaign_id
group by channel
order by revenue desc


--city performance
select
	c.city,
	count(*) as total_intearctions,
	sum(cast(i.product_purchased as int)) as total_purchases,
	sum(i.purchase_amount) as revenue,
	avg(cast(i.product_purchased as float))* 100 as conversion_rate
from campaign_interactions i
join customers c
on i.customer_id = c.customer_id
group by city
order by revenue desc


--income segment
select
	c.income_bracket,
	count(*) as total_intearctions,
	sum(cast(i.product_purchased as int)) as total_purchases,
	sum(i.purchase_amount) as revenue,
	avg(cast(i.product_purchased as float))* 100 as conversion_rate
from campaign_interactions i
join customers c
on i.customer_id = c.customer_id
group by income_bracket
order by revenue desc


--Age group
select 
case
	when age<30 then 'Young'
	when age between 30 and 45 then 'Mid Age'
	when age>45 then 'Senior'
	else 'Unknown'
end as age_group,
sum(i.purchase_amount) as revenue,
avg(cast(i.product_purchased as float)) *100 as conversion_rate
from campaign_interactions i
join customers c
on i.customer_id = c.customer_id
group by
case
	when age<30 then 'Young'
	when age between 30 and 45 then 'Mid Age'
	when age>45 then 'Senior'
	else 'Unknown'
end 
order by revenue desc


--Customer value per campaign
select
	cam.campaign_name,
	count(distinct i.customer_id) as customer_acquired,
	sum(i.purchase_amount) as revenue,
	avg(i.purchase_amount) as avg_customer_value
from campaign_interactions i
join campaigns cam
on i.campaign_id=cam.campaign_id
where i.product_purchased=1
group by campaign_name
order by revenue desc

--Channel purchase efficiency
select
	cam.channel,
	count(*) as total_interactions,
	sum(i.purchase_amount) as revenue,
	sum(cast(i.product_purchased as int)) as purchases,
	round(sum(i.purchase_amount) * 1.0 / count(*), 2) as revenue_per_interaction
from campaign_interactions i
join campaigns cam
on i.campaign_id=cam.campaign_id
group by cam.channel
order by revenue_per_interaction