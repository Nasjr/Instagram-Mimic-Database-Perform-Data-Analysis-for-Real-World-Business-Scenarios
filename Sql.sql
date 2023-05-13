/*We want to reward our users who have been around the longest.  
Find the 5 oldest users.*/
select username,created_at
from users
order by created_at asc
limit 5;

/* What day of the week do most users register on need to figure out when to schedule an ad campgain*/
select extract(dow from created_at) as dow,count(*)
from users
group by dow
order by dow asc;

/*We want to target our inactive users with an email campaign.
Find the users who have never posted a photo*/

select username
from users
left join photos on
users.id = photos.user_id
where photos.id is null;


/*We're running a new contest to see who can get the most likes on a single photo.
WHO WON??!!*/

select username,image_url,photo_id,count(*) as total_likes
from likes
join photos p on p.id=likes.photo_id
join users u on u.id=p.user_id
group by username,image_url,photo_id
order by total_likes desc
limit 5;

/*Our Investors want to know...
How many times does the average user post?*/
/*total number of photos/total number of users*/


select count(*)/(select count(*) from users) as average_times_post
from photos;

/*user ranking by postings higher to lower*/
select user_id,count(image_url) as total_number_of_photos
from photos
inner join users 
on users.id=photos.user_id
group by user_id
order by total_number_of_photos desc;

/*Total Posts by users (longer versionof SELECT COUNT(*)FROM photos) */
with total as (
	select user_id,count(image_url) as total_number_of_photos
	from photos
	inner join users 
	on users.id=photos.user_id
	group by user_id
	order by total_number_of_photos desc)
select sum(total_number_of_photos)
from total

/*total numbers of users who have posted at least one time */
select count(distinct(users.id)) as total_count_of_users
from users
inner join photos
on photos.user_id=users.id

/*A brand wants to know which hashtags to use in a post
What are the top 5 most commonly used hashtags?*/
select tag_name,count(tag_name) total_tag
from tags
join photo_tags on photo_tags.tag_id = tags.id
group by tag_name
order by total_tag desc
limit 5;

/*We have a small problem with bots on our site...
Find users who have liked every single photo on the site*/

select username,count(user_id) as total_likes
from users
inner join likes on likes.user_id=users.id
group by username
Having count(*) = (select count(*) from photos);


/*We also have a problem with celebrities
Find users who have never commented on a photo*/
select username,count(comments.id) as total_likes
from users
left join comments on comments.user_id = users.id
group by username
Having count(comments.id) = 0;

with table_a as (
	select count(*) / ROUND((select count(*) from users),2)*100 as percentage_of_people_who_never_comments
	from (select username,count(comments.id) as total_likes
	from users
	left join comments on comments.user_id = users.id
	group by username
)
select * 
from table_a

select count(*)/round((select count(id) from users),2) * 100 as percentage_of_most_likely_bots
	from(
		select username,count(comments.comment_text) as total_number_of_comments
	from users
	left join comments on comments.user_id=users.id
	group by username
	Having count(comments.comment_text) = (select count(*) from photos)) as people_who_commented_on_each_post

	


/*Are we overrun with bots and celebrity accounts?
Find the percentage of our users who have either never commented on a photo or have commented on photos before*/

SELECT 
  COUNT(CASE WHEN c.comment_text IS NULL THEN user_id END) AS Number_of_Users_who_never_commented,
  (COUNT(CASE WHEN c.comment_text IS NULL THEN user_id END)::float / COUNT(*)::float) * 100 AS percent1,
  COUNT(CASE WHEN c.comment_text IS NOT NULL THEN user_id END) AS Number_of_comments,
  (COUNT(CASE WHEN c.comment_text IS NOT NULL THEN user_id END)::float / COUNT(*)::float) * 100 AS percent2
FROM users u
LEFT JOIN comments c ON u.id = c.user_id




