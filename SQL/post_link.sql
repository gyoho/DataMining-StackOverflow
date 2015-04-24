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
# 109326

select count(distinct postId, relatedPostId)
from postLink;
# 87393


select postId, relatedPostId
from postLink
where postId<=1027 and relatedPostId<=1027
order by postId;



# combine post link data with comment link data
# by default 'union' selects only unique rows
(select distinct postId, relatedPostId
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