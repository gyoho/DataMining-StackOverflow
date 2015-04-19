CREATE TABLE `cmpe239`.`commentLink` (
  `postId` INT NOT NULL,
  `relatedPostId` INT NOT NULL,
  `userId` INT NULL);


LOAD DATA INFILE '/Users/gyoho/Class/Data Mining/Project/Dataset-AskUbuntu/data/comment_links_data.txt' 
INTO TABLE commentLink_temp 
FIELDS TERMINATED BY '\t' 
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

# Append postTypeId and ParentId to the comment row
select commentLink.*, posttypeid, parentid
from commentLink, postsQuality
where commentLink.postId = postsQuality.id;

# extract links in questions
select c.postId, c.relatedPostId
from 
	(select commentLink.*, posttypeid, parentid
	from commentLink, postsQuality
	where commentLink.postId = postsQuality.id) as c
where c.posttypeid = 1 and relatedPostId != 0 and c.postId != c.relatedPostID
order by c.postId;

# extract links in answers and add to its parent question
select distinct c1.postId, c2.relatedPostId
from 
	(select commentLink.*, posttypeid, parentid
	from commentLink, postsQuality
	where commentLink.postId = postsQuality.id) as c1,
	(select commentLink.*, posttypeid, parentid
	from commentLink, postsQuality
	where commentLink.postId = postsQuality.id) as c2
where c1.posttypeid = 1 and c2.posttypeid = 2 and c1.postId = c2.parentid
order by c1.postId;


# generate the final result
select c.postId as postId, c.relatedPostId as relatedPostId
from 
	(select commentLink.*, posttypeid, parentid
	from commentLink, postsQuality
	where commentLink.postId = postsQuality.id) as c
where c.posttypeid = 1 and relatedPostId != 0 and c.postId != c.relatedPostID
union
select distinct c1.postId as postId, c2.relatedPostId as relatedPostId
from 
	(select commentLink.*, posttypeid, parentid
	from commentLink, postsQuality
	where commentLink.postId = postsQuality.id) as c1,
	(select commentLink.*, posttypeid, parentid
	from commentLink, postsQuality
	where commentLink.postId = postsQuality.id) as c2
where c1.posttypeid = 1 and c2.posttypeid = 2 and c1.postId = c2.parentid
order by postId;