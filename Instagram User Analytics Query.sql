create database insta 



/*Comments*/
CREATE TABLE dw.comments(
	id INT IDENTITY(1,1) PRIMARY KEY,
	comment_text VARCHAR(255) NOT NULL,
	user_id INT NOT NULL,
	photo_id INT NOT NULL,
	created_at datetime default  current_timestamp,
	FOREIGN KEY(user_id) REFERENCES dw.users(id),
	FOREIGN KEY(photo_id) REFERENCES dw.photos(id)
);


/*Likes*/
CREATE TABLE DW.likes(
	user_id INT NOT NULL,
	photo_id INT NOT NULL,
	created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
	FOREIGN KEY(user_id) REFERENCES DW.users(id),
	FOREIGN KEY(photo_id) REFERENCES DW.photos(id),
	PRIMARY KEY(user_id,photo_id)
);


/*follows*/
CREATE TABLE dw.follows(
	follower_id INT NOT NULL,
	followee_id INT NOT NULL,
	created_at datetime default current_timestamp,
	FOREIGN KEY (follower_id) REFERENCES dw.users(id),
	FOREIGN KEY (followee_id) REFERENCES dw.users(id),
	PRIMARY KEY(follower_id,followee_id)
);



/*Tags*/
CREATE TABLE dw.tags(
	id INTEGER identity(1,1) PRIMARY KEY,
	tag_name VARCHAR(255) UNIQUE NOT NULL,
	created_at datetime default current_timestamp
);

/*junction table: Photos - Tags*/
CREATE TABLE dw.photo_tags(
	photo_id INT NOT NULL,
	tag_id INT NOT NULL,
	FOREIGN KEY(photo_id) REFERENCES dw.photos(id),
	FOREIGN KEY(tag_id) REFERENCES dw.tags(id),
	PRIMARY KEY(photo_id,tag_id)
);


select * from dw.users 

select * from dw.tags
select * from dw.follows
select * from dw.photo_tags

select * from dw.photos
select * from dw.likes 






-- Find the 5 oldest users of the Instagram from the database provided


select * , DATEDIFF(YEAR,a.created_at,a.enddate) AS Tenure   from 
(
select *, getdate() as enddate  from dw.users

)a
order by tenure desc



--Find the users who have never posted a single photo on Instagram



select u.id ,   p.user_id, count(p.id)  as counts , u.username as Name 
from dw.users  u left  join dw.photos p on u.id=p.user_id
where p.user_id is null 
group by user_id ,username , u.id  
order by id, user_id


--Declaring Contest Winner: 
--The team started a contest and the user who gets the most likes on a single photo will win the contest now they wish to declare the winner.
-- Identify the winner of the contest and provide their details to the team




 select a.* , b.username as UserName  from 
(
select l.*, p.user_id from 

(
  SELECT top 1
            photo_id,
            COUNT(*) AS Likes
        FROM
            dw.likes 
        GROUP BY
            photo_id
			order by 2 desc 
	) l
	
			join 
(
select id, user_id from dw.photos
		)  p 
		on l.photo_id=p.id
) a 
  
  join 

  ( select * from dw.users
  ) b 
  on a.user_id=b.id




 --Hashtag Researching: A partner brand wants to know, which hashtags to use in the post to reach the most people on the platform.
--Identify and suggest the top 5 most commonly used hashtags on the platform




select a.*, b.tag_name as Tagname from 
(
select  top 5   tag_id  ,  count(photo_id) as tagcounts from dw.photo_tags 
group by tag_id
order by 2 desc 
) a

join 
( select * from dw.tags
) b 
on a.tag_id=b.id




--Launch AD Campaign: The team wants to know, which day would be the best day to launch ADs.
-- What day of the week do most users register on? Provide insights on when to schedule an ad campaign


 select count(*) as Registers, Day  from 
(
select    DATEName(WEEKDAY,created_at) AS Day  from dw.users 
)a
group by Day 
order by 1 desc 





--User Engagement: Are users still as active and post on Instagram or they are making fewer posts
--Provide how many times does average user posts on Instagram. Also, provide the total number of photos on Instagram/total number of users





SELECT   USER_ID , COUNT(ID)AS COUNTS FROM DW.PHOTOS 
GROUP BY user_id




select count(id) as TotalUsers  from dw.users 




select count(id) as TotalPhotos from dw.photos





--Bots & Fake Accounts: The investors want to know if the platform is crowded with fake and dummy accounts
-- Provide data on users (bots) who have liked every single photo on the site (since any normal user would not be able to do this).





SELECT   PHOTO_ID, COUNT( user_id ) AS Likes  FROM DW.LIKES 
GROUP BY photo_id 
ORDER BY photo_id

-- result there is no photo which has a total likes of over 100 thus it is safe to say that all the user who are registgered are genuine 


select photo_id, user_id from dw.likes 
group by photo_id, user_id
order by photo_id , user_id





