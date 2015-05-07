# total questions --> 182017
select id
from postsQuality
where posttypeid = 1
order by id;


select AVG(score) as avgScore
from postsQuality;
# 2.1249

/***
DELETED:
	select AVG(viewcount) as avgViewCount
	from postsQuality
	where posttypeid = 1;
	# 2411.5050
***/

select AVG(answercount) as avgAnsCount
from postsQuality
where posttypeid = 1;
# 1.3060


select AVG(commentcount) as avgCommentCount
from postsQuality;
# 1.2655


select AVG(favoritecount) as avgFavCount
from postsQuality
where posttypeid = 1;
# 0.6257


-- ----------------------------------------------------------
-- normrize the viewcount by devide by 1000
-- ref: http://stackoverflow.com/questions/11749120/mysql-query-divide-column-by-100
-- ----------------------------------------------------------
update postsQuality set viewcount = viewcount/1000;

select MAX(viewcount) as avgScore
from postsQuality;
# 1223
## Decide to ignore viewcount as score


-- ----------------------------------------------------------
-- get the overall score of quality
-- ref: http://stackoverflow.com/questions/20062270/sql-query-to-get-the-sum-of-all-column-values-in-the-last-row-of-a-resultset-alo
-- ----------------------------------------------------------

# this only returns the questions having at least one answer
select question.questionId as Id, (question.questionQuality + answer.totalAnswerQuality) as Size
from 
		# include all: score, answercount, commentcount, favoritecount for Question type
		(select id as questionId, (score + answercount + commentcount + favoritecount) as questionQuality
		from postsQuality
		where posttypeid = 1) as question
	join 
		## reduce by the same parentid
		(select questionId, sum(answerQuality) as totalAnswerQuality
		from 
			# include only: score, commnetcount for Answer type
			(select parentid as questionId, (score + commentcount) as answerQuality
			from postsQuality
			where posttypeid = 2) as individualAnswer
		group by questionId) as answer
	on question.questionId = answer.questionId
union
# need to union with the questions with no answer
select id as Id, (score + answercount + commentcount + favoritecount) as Size
from postsQuality
where posttypeid = 1 and id not in
	(select parentid from postsQuality where posttypeid = 2)
Order by Id;

-- ----------------------------------------------------------
-- Test
-- ----------------------------------------------------------
select questionId, sum(answerQuality) as totalAnswerQuality
from 
	(# include only: score, commnetcount for Answer type
	select parentid as questionId, (score + commentcount) as answerQuality
	from postsQuality
	where posttypeid = 2) as individualAnswer
group by questionId
having questionId = 3;


-- ----------------------------------------------------------
-- Validation
-- ----------------------------------------------------------
select id as questionId, (score + answercount + commentcount + favoritecount) as questionQuality
from postsQuality
where id = 3;


select parentid, (score + commentcount) as answerQuality
from postsQuality
where parentid = 3;