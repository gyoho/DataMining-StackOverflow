CREATE TABLE `cmpe239`.`postLink` (
  `postId` INT NOT NULL,
  `relatedPostId` INT NOT NULL,
  `linkTypeId` INT NOT NULL);


LOAD DATA INFILE '/Users/gyoho/Class/Data Mining/Project/Dataset-AskUbuntu/data/postLinks_data.txt' 
INTO TABLE postLink 
FIELDS TERMINATED BY '\t' 
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;



select count(postId)
from postLink;
# 109327

select count(distinct(postId))
from postLink;
# 68446

select count(*)
from postLink
where relatedPostId = postId
order by postId;
# 18


select *
from postLink
order by postId;



# combine post link data with comment link data
(select postId, relatedPostId
from postLink)
union
(select c.postId as postId, c.relatedPostId as relatedPostId
from 
	(select commentLink.*, posttypeid, parentid
	from commentLink, postsQuality
	where commentLink.postId = postsQuality.id) as c
where c.posttypeid = 1 and relatedPostId != 0 and c.postId != c.relatedPostID)
union
(select distinct c1.postId as postId, c2.relatedPostId as relatedPostId
from 
	(select commentLink.*, posttypeid, parentid
	from commentLink, postsQuality
	where commentLink.postId = postsQuality.id) as c1,
	(select commentLink.*, posttypeid, parentid
	from commentLink, postsQuality
	where commentLink.postId = postsQuality.id) as c2
where c1.posttypeid = 1 and c2.posttypeid = 2 and c1.postId = c2.parentid)
order by postId;